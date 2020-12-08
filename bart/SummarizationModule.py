import argparse
from collections import defaultdict
from typing import Any, Dict, List
from transformers import AdamW, BartConfig, BartTokenizer
from transformers.optimization import (
    get_cosine_schedule_with_warmup,
    get_cosine_with_hard_restarts_schedule_with_warmup,
    get_linear_schedule_with_warmup,
    get_polynomial_decay_schedule_with_warmup,
)
import time
import numpy as np
import pytorch_lightning as pl
import torch
import evaluation_utils
from transformers import BartForConditionalGeneration
from transformers.models.bart.modeling_bart import shift_tokens_right

# scheduler options
from list_utils import flatten_list

arg_to_scheduler = {
    "linear": get_linear_schedule_with_warmup,
    "cosine": get_cosine_schedule_with_warmup,
    "cosine_w_restarts": get_cosine_with_hard_restarts_schedule_with_warmup,
    "polynomial": get_polynomial_decay_schedule_with_warmup,
}
arg_to_scheduler_choices = sorted(arg_to_scheduler.keys())
arg_to_scheduler_metavar = "{" + ", ".join(arg_to_scheduler_choices) + "}"


class SummarizationModule(pl.LightningModule):

    def __init__(self, hparams):
        super().__init__()
        if isinstance(hparams, dict):
            hparams = argparse.Namespace(**hparams)
        self.save_hyperparameters(hparams)
        cache_dir = hparams.cache_dir if hparams.cache_dir else None

        # load config
        self.config: BartConfig = BartConfig.from_pretrained(
            hparams.model,
            cache_dir=cache_dir
        )

        # load tokenizer
        self.tokenizer: BartTokenizer = BartTokenizer.from_pretrained(
            hparams.model,
            cache_dir=cache_dir
        )

        # load model
        self.model = BartForConditionalGeneration.from_pretrained(
            hparams.model,
            config=self.config,
            cache_dir=cache_dir
        )

        # update the model config with task specific ('summarization') parameters
        task_specific_params = self.model.config.task_specific_params
        if task_specific_params is not None:
            pars = task_specific_params.get('summarization', {})
            print(f"using task specific params for summarization: {pars}")
            self.model.config.update(pars)

        # generation parameters:
        self.eval_beams = self.model.config.num_beams if hparams.eval_beams is None else hparams.eval_beams
        self.eval_max_gen_length = self.model.config.max_length if hparams.eval_max_gen_length is None else hparams.eval_max_gen_length

        # optimizer parameters:
        self.gpus = 0 if hparams.gpus is None else hparams.gpus

        self.get_dataset_size_fcn = None
        self.train_batch_size = 0 if hparams.train_batch_size is None else hparams.train_batch_size
        self.max_epochs = 0 if hparams.max_epochs is None else hparams.max_epochs

        self.accumulate_grad_batches = hparams.accumulate_grad_batches
        self.lr_scheduler = hparams.lr_scheduler
        self.warmup_steps = hparams.warmup_steps
        self.learning_rate = hparams.learning_rate
        self.adam_epsilon = hparams.adam_epsilon
        self.weight_decay = hparams.weight_decay

        # state
        self.opt = None

        # save validation & test outputs so that SummarizationLoggingCallback can access them
        self.summarization_output = defaultdict(list)

        # log all hparams to tensorboard
        self.hparams = hparams

    # ------------------------------------------------------------------------------------------------------------------
    # Inference
    # ------------------------------------------------------------------------------------------------------------------

    # Use for inference only (separate from training_step)
    def forward(self, batch):
        # generate summary
        generated_ids = self.model.generate(
            batch["input_ids"],
            attention_mask=batch["attention_mask"],
            use_cache=True,
            num_beams=self.eval_beams,
            max_length=self.eval_max_gen_length,
        )

        # convert the generated summary back to text
        preds: List[str] = self.ids_to_clean_text(generated_ids)

        return preds

    # ------------------------------------------------------------------------------------------------------------------
    # Prediction & Loss Calculation
    # ------------------------------------------------------------------------------------------------------------------

    def _step(self, batch):
        # prepare input
        src_ids, src_mask, tgt_ids = batch["input_ids"], batch["attention_mask"], batch["labels"]
        decoder_input_ids = shift_tokens_right(tgt_ids, self.tokenizer.pad_token_id)

        # TODO: implement debugging utility?

        # predict
        outputs = self.model(src_ids, attention_mask=src_mask, decoder_input_ids=decoder_input_ids, use_cache=False)
        lm_logits = outputs["logits"]

        # TODO: implement label smoothing?

        # calculate cross entropy loss
        loss_function = torch.nn.CrossEntropyLoss(ignore_index=self.tokenizer.pad_token_id)
        assert lm_logits.shape[-1] == self.config.vocab_size
        loss = loss_function(lm_logits.view(-1, lm_logits.shape[-1]), tgt_ids.view(-1))

        return loss

    # ------------------------------------------------------------------------------------------------------------------
    # Training
    # ------------------------------------------------------------------------------------------------------------------

    # the full training loop
    def training_step(self, batch, batch_idx):
        loss = self._step(batch)

        # create a log object
        pad = self.tokenizer.pad_token_id
        logs = {
            'loss': loss,
            'tokens_per_batch': batch["input_ids"].ne(pad).sum() + batch["labels"].ne(pad).sum(),
            'batch_size': batch["input_ids"].shape[0],
            'src_pad_tok': batch["input_ids"].eq(pad).sum(),
            'src_pad_frac': batch["input_ids"].eq(pad).float().mean()
        }

        # TODO: log stuff
        # log to the progress bar and logger
        # the metrics for each training step
        # and the average across the epoch
        self.log('train_loss', loss, prog_bar=False, logger=True, on_step=False, on_epoch=True)

        return loss

    def training_epoch_end(self, outputs: List[Any]) -> None:
        # log learning rates
        for i, param in enumerate(self.trainer.optimizers[0].param_groups):
            self.log(f'lr_group_{i}', param['lr'])

    # ------------------------------------------------------------------------------------------------------------------
    # Generation
    # ------------------------------------------------------------------------------------------------------------------

    def ids_to_clean_text(self, generated_ids: List[int]):
        gen_text = self.tokenizer.batch_decode(
            generated_ids, skip_special_tokens=True, clean_up_tokenization_spaces=True
        )
        return list(map(str.strip, gen_text))

    def _generative_step(self, batch: dict) -> dict:
        t0 = time.time()  # measure the time needed for generation

        # generate summary
        generated_ids = self.model.generate(
            batch["input_ids"],
            attention_mask=batch["attention_mask"],
            use_cache=True,
            num_beams=self.eval_beams,
            max_length=self.eval_max_gen_length,
        )

        gen_time = (time.time() - t0) / batch["input_ids"].shape[0]  # measure the time needed for generation

        # convert the generated summary and the gold summary back to text
        preds: List[str] = self.ids_to_clean_text(generated_ids)
        target: List[str] = self.ids_to_clean_text(batch["labels"])

        # calculate rouge score to compare generated summary with golden summary
        rouge: Dict = evaluation_utils.calculate_rouge(preds, target)

        # calculate average length of the generated summaries
        summ_len = np.mean(list(map(len, generated_ids)))

        # calculate loss
        loss_tensors = self._step(batch)

        # construct result object
        result = {'loss': loss_tensors}
        result.update(gen_time=gen_time, gen_len=summ_len, preds=preds, target=target, **rouge)
        return result

    # ------------------------------------------------------------------------------------------------------------------
    # Evaluation: Validation & Testing
    # ------------------------------------------------------------------------------------------------------------------

    def log_eval_epoch(self, outputs: List[Any]):
        summarization_output = defaultdict()

        # get all predictions, targets for this epoch
        preds = flatten_list([x["preds"] for x in outputs])
        targets = flatten_list([x["target"] for x in outputs])
        summarization_output.update({'preds': preds})
        summarization_output.update({'targets': targets})

        # these outputs are written to a file by SummarizationLoggingCallback
        self.summarization_output = summarization_output

    def log_eval_step(self, result, mode):
        self.log(f'{mode}_rouge1', result['rouge1'], prog_bar=False, logger=True, on_step=False, on_epoch=True, sync_dist=True)
        self.log(f'{mode}_rouge2', result['rouge2'], prog_bar=False, logger=True, on_step=False, on_epoch=True, sync_dist=True)
        self.log(f'{mode}_rougeL', result['rougeL'], prog_bar=False, logger=True, on_step=False, on_epoch=True, sync_dist=True)
        self.log(f'{mode}_rougeLsum', result['rougeLsum'], prog_bar=False, logger=True, on_step=False, on_epoch=True, sync_dist=True)
        self.log(f'{mode}_gen_time', result['gen_time'], prog_bar=False, logger=True, on_step=False, on_epoch=True, sync_dist=True)
        self.log(f'{mode}_gen_len', result['gen_len'], prog_bar=False, logger=True, on_step=False, on_epoch=True, sync_dist=True)

    def validation_step(self, batch, batch_idx):
        result = self._generative_step(batch)
        self.log('val_loss', result['loss'], prog_bar=True, logger=True, on_step=False, on_epoch=True, sync_dist=True)
        self.log_eval_step(result, 'val')
        return result

    def validation_epoch_end(self, outputs: List[Any]):
        self.log_eval_epoch(outputs)

    def test_step(self, batch, batch_idx):
        result = self._generative_step(batch)
        self.log('test_loss', result['loss'], prog_bar=False, logger=True, on_step=False, on_epoch=True, sync_dist=True)
        self.log_eval_step(result, 'test')
        return result

    def test_epoch_end(self, outputs: List[Any]):
        self.log_eval_epoch(outputs)

    # ------------------------------------------------------------------------------------------------------------------
    # Optimizer
    # ------------------------------------------------------------------------------------------------------------------

    def total_steps(self) -> int:
        """The number of total training steps that will be run. Used for lr scheduler purposes."""
        num_devices = max(1, self.gpus)  # TODO: consider num_tpu_cores
        effective_batch_size = self.train_batch_size * self.accumulate_grad_batches * num_devices
        return (self.get_dataset_size_fcn() / effective_batch_size) * self.max_epochs

    def get_lr_scheduler(self):

        get_schedule_func = arg_to_scheduler[self.lr_scheduler]
        scheduler = get_schedule_func(
            self.opt, num_warmup_steps=self.warmup_steps, num_training_steps=self.total_steps()
        )
        scheduler = {"scheduler": scheduler, "interval": "step", "frequency": 1}
        return scheduler

    def configure_optimizers(self):
        """Prepare optimizer and schedule (linear warmup and decay)"""
        no_decay = ["bias", "LayerNorm.weight"]
        optimizer_grouped_parameters = [
            {
                "params": [p for n, p in self.model.named_parameters() if not any(nd in n for nd in no_decay)],
                "weight_decay": self.weight_decay,
            },
            {
                "params": [p for n, p in self.model.named_parameters() if any(nd in n for nd in no_decay)],
                "weight_decay": 0.0,
            },
        ]
        optimizer = AdamW(optimizer_grouped_parameters, lr=self.learning_rate, eps=self.adam_epsilon)
        self.opt = optimizer
        scheduler = self.get_lr_scheduler()
        return [optimizer], [scheduler]

    # ------------------------------------------------------------------------------------------------------------------
    # Arguments
    # ------------------------------------------------------------------------------------------------------------------

    @staticmethod
    def add_arguments(parser):
        # Huggingface model
        parser.add_argument(
            "--model",
            default="sshleifer/bart-tiny-random",
            type=str,
            help="Path to pretrained model or model identifier from huggingface.co/models",
        )

        # Cache
        parser.add_argument(
            "--cache_dir",
            default="",
            type=str,
            help="Where do you want to store the pre-trained models downloaded from huggingface.co",
        )

        # Optimizer
        parser.add_argument("--learning_rate", default=5e-5, type=float, help="The initial learning rate for Adam.")
        parser.add_argument(
            "--lr_scheduler",
            default="linear",
            choices=arg_to_scheduler_choices,
            metavar=arg_to_scheduler_metavar,
            type=str,
            help="Learning rate scheduler",
        )
        parser.add_argument("--weight_decay", default=0.0, type=float, help="Weight decay if we apply some.")
        parser.add_argument("--adam_epsilon", default=1e-8, type=float, help="Epsilon for Adam optimizer.")
        parser.add_argument("--warmup_steps", default=0, type=int, help="Linear warmup over warmup_steps.")
        parser.add_argument(
            "--gradient_accumulation_steps",
            dest="accumulate_grad_batches",
            type=int,
            default=1,
            help="Number of updates steps to accumulate before performing a backward/update pass.",
        )

        # Generation
        parser.add_argument("--eval_beams", type=int, default=1)
        parser.add_argument("--eval_max_gen_length", type=int, default=142, help="never generate more than n tokens")

        return parser

    # ------------------------------------------------------------------------------------------------------------------
    # Other
    # ------------------------------------------------------------------------------------------------------------------

    def half_precision(self):
        self.model = self.model.half()
