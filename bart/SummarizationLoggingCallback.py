import logging
from pathlib import Path
import numpy as np
import pytorch_lightning as pl
import torch
from pytorch_lightning.utilities import rank_zero_only

logger = logging.getLogger(__name__)


class SummarizationLoggingCallback(pl.Callback):

    @rank_zero_only
    def _write_logs(self, trainer: pl.Trainer, pl_module: pl.LightningModule, type_path: str) -> None:
        """Writes results of an evaluation epoch (validation or test) to text files."""
        metrics = trainer.callback_metrics
        summarization_output = pl_module.summarization_output

        # create log files
        od = Path(trainer.logger.log_dir)
        if type_path == "test":
            results_file = od / "test_results.txt"
            generations_file = od / "test_generations.txt"
            targets_file = od / "test_targets.txt"
        else:
            results_file = od / f"{type_path}_results/{trainer.global_step:05d}.txt"
            generations_file = od / f"{type_path}_generations/{trainer.global_step:05d}.txt"
            targets_file = od / f"{type_path}_targets/{trainer.global_step:05d}.txt"
        results_file.parent.mkdir(exist_ok=True)
        generations_file.parent.mkdir(exist_ok=True)
        targets_file.parent.mkdir(exist_ok=True)

        # write metrics
        with open(results_file, "a+") as writer:
            for key in sorted(metrics):
                if key.startswith(type_path):
                    val = metrics[key]
                    if isinstance(val, torch.Tensor):
                        val = val.item()
                    msg = f"{key}: {val}\n"
                    writer.write(msg)

        # write generations
        if "preds" in summarization_output:
            content = "\n".join(summarization_output["preds"])
            generations_file.open("w+").write(content)

        # write targets
        if "targets" in summarization_output:
            content = "\n".join(summarization_output["targets"])
            targets_file.open("w+").write(content)

    @rank_zero_only
    def on_train_start(self, trainer, pl_module):
        try:
            npars = pl_module.model.model.num_parameters()
        except AttributeError:
            npars = pl_module.model.num_parameters()

        n_trainable_pars = SummarizationLoggingCallback.count_trainable_parameters(pl_module)
        trainer.logger.log_metrics({"params_in_million": npars / 1e6, "params_trainable_in_millions": n_trainable_pars / 1e6})

    @rank_zero_only
    def on_test_end(self, trainer: pl.Trainer, pl_module: pl.LightningModule):
        self._write_logs(trainer, pl_module, "test")

    @rank_zero_only
    def on_validation_end(self, trainer: pl.Trainer, pl_module):
        self._write_logs(trainer, pl_module, "val")

    @staticmethod
    def count_trainable_parameters(model):
        model_parameters = filter(lambda p: p.requires_grad, model.parameters())
        params = sum([np.prod(p.size()) for p in model_parameters])
        return params
