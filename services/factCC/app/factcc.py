# Copyright (c) 2020, Salesforce.com, Inc.
# Copyright 2018 The Google AI Language Team Authors and The HuggingFace Inc. team.
# Copyright (c) 2018, NVIDIA CORPORATION.  All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
""" Finetuning the library models for sequence classification on GLUE (Bert, XLM, XLNet)."""

from __future__ import absolute_import, division, print_function

import argparse
import logging
import os
import random

import numpy as np
import torch

from data_processors import processors, output_modes
from inputs import InputFeatures, InputExample
from model import BertPointer

from torch.utils.data import (DataLoader, SequentialSampler, TensorDataset)
from torch.utils.data.distributed import DistributedSampler
from tqdm import tqdm
from pytorch_transformers import (BertConfig, BertForSequenceClassification, BertTokenizer)
import torch.nn.functional as F

import pathlib
directory = pathlib.Path(__file__).parent.parent.absolute()

logger = logging.getLogger(__name__)

ALL_MODELS = sum((tuple(conf.pretrained_config_archive_map.keys()) for conf in (BertConfig,)), ())

MODEL_CLASSES = {
    'pbert': (BertConfig, BertPointer, BertTokenizer),
    'bert': (BertConfig, BertForSequenceClassification, BertTokenizer),
}

model = None
tokenizer = None
args = None


def _truncate_seq_pair(tokens_a, tokens_b, max_length):
    """Truncates a sequence pair in place to the maximum length."""

    # This is a simple heuristic which will always truncate the longer sequence
    # one token at a time. This makes more sense than truncating an equal percent
    # of tokens from each, since if one sequence is very short then each token
    # that's truncated likely contains more information than a longer sequence.
    while True:
        total_length = len(tokens_a) + len(tokens_b)
        if total_length <= max_length:
            break
        if len(tokens_a) > len(tokens_b):
            tokens_a.pop()
        else:
            tokens_b.pop()


def convert_examples_to_features(examples, label_list, max_seq_length,
                                 tokenizer, output_mode,
                                 cls_token_at_end=False,
                                 cls_token='[CLS]',
                                 cls_token_segment_id=1,
                                 sep_token='[SEP]',
                                 sep_token_extra=False,
                                 pad_on_left=False,
                                 pad_token=0,
                                 pad_token_segment_id=0,
                                 sequence_a_segment_id=0,
                                 sequence_b_segment_id=1,
                                 mask_padding_with_zero=True):
    """ Loads a data file into a list of `InputBatch`s
        `cls_token_at_end` define the location of the CLS token:
            - False (Default, BERT/XLM pattern): [CLS] + A + [SEP] + B + [SEP]
            - True (XLNet/GPT pattern): A + [SEP] + B + [SEP] + [CLS]
        `cls_token_segment_id` define the segment id associated to the CLS token (0 for BERT, 2 for XLNet)
    """

    label_map = {label : i for i, label in enumerate(label_list)}

    features = []
    for (ex_index, example) in enumerate(examples):
        if ex_index % 10000 == 0:
            logger.info("Writing example %d of %d" % (ex_index, len(examples)))

        tokens_a = tokenizer.tokenize(example.text_a)

        tokens_b = None
        if example.text_b:
            tokens_b = tokenizer.tokenize(example.text_b)
            # Modifies `tokens_a` and `tokens_b` in place so that the total
            # length is less than the specified length.
            # Account for [CLS], [SEP], [SEP] with "- 3". " -4" for RoBERTa.
            special_tokens_count = 4 if sep_token_extra else 3
            _truncate_seq_pair(tokens_a, tokens_b, max_seq_length - special_tokens_count)
        else:
            # Account for [CLS] and [SEP] with "- 2" and with "- 3" for RoBERTa.
            special_tokens_count = 3 if sep_token_extra else 2
            if len(tokens_a) > max_seq_length - special_tokens_count:
                tokens_a = tokens_a[:(max_seq_length - special_tokens_count)]

        # The convention in BERT is:
        # (a) For sequence pairs:
        #  tokens:   [CLS] is this jack ##son ##ville ? [SEP] no it is not . [SEP]
        #  type_ids:   0   0  0    0    0     0       0   0   1  1  1  1   1   1
        # (b) For single sequences:
        #  tokens:   [CLS] the dog is hairy . [SEP]
        #  type_ids:   0   0   0   0  0     0   0
        #
        # Where "type_ids" are used to indicate whether this is the first
        # sequence or the second sequence. The embedding vectors for `type=0` and
        # `type=1` were learned during pre-training and are added to the wordpiece
        # embedding vector (and position vector). This is not *strictly* necessary
        # since the [SEP] token unambiguously separates the sequences, but it makes
        # it easier for the model to learn the concept of sequences.
        #
        # For classification tasks, the first vector (corresponding to [CLS]) is
        # used as as the "sentence vector". Note that this only makes sense because
        # the entire model is fine-tuned.
        tokens = tokens_a + [sep_token]
        if sep_token_extra:
            # roberta uses an extra separator b/w pairs of sentences
            tokens += [sep_token]
        segment_ids = [sequence_a_segment_id] * len(tokens)

        if tokens_b:
            tokens += tokens_b + [sep_token]
            segment_ids += [sequence_b_segment_id] * (len(tokens_b) + 1)

        if cls_token_at_end:
            tokens = tokens + [cls_token]
            segment_ids = segment_ids + [cls_token_segment_id]
        else:
            tokens = [cls_token] + tokens
            segment_ids = [cls_token_segment_id] + segment_ids

        input_ids = tokenizer.convert_tokens_to_ids(tokens)

        # The mask has 1 for real tokens and 0 for padding tokens. Only real
        # tokens are attended to.
        input_mask = [1 if mask_padding_with_zero else 0] * len(input_ids)

        ####### AUX LOSS DATA
        # get tokens_a mask
        extraction_span_len = len(tokens_a) + 2
        extraction_mask = [1 if 0 < ix < extraction_span_len else 0 for ix in range(max_seq_length)]

        # get extraction labels
        if example.extraction_span:
            ext_start, ext_end = example.extraction_span
            extraction_start_ids = ext_start + 1
            extraction_end_ids = ext_end + 1
        else:
            extraction_start_ids = extraction_span_len
            extraction_end_ids = extraction_span_len

        augmentation_mask = [1 if extraction_span_len <= ix < extraction_span_len + len(tokens_b) + 1  else 0 for ix in range(max_seq_length)]

        if example.augmentation_span:
            aug_start, aug_end = example.augmentation_span
            augmentation_start_ids = extraction_span_len + aug_start
            augmentation_end_ids = extraction_span_len + aug_end
        else:
            last_sep_token = extraction_span_len + len(tokens_b)
            augmentation_start_ids = last_sep_token
            augmentation_end_ids = last_sep_token

        # Zero-pad up to the sequence length.
        padding_length = max_seq_length - len(input_ids)
        if pad_on_left:
            input_ids = ([pad_token] * padding_length) + input_ids
            input_mask = ([0 if mask_padding_with_zero else 1] * padding_length) + input_mask
            segment_ids = ([pad_token_segment_id] * padding_length) + segment_ids
        else:
            input_ids = input_ids + ([pad_token] * padding_length)
            input_mask = input_mask + ([0 if mask_padding_with_zero else 1] * padding_length)
            segment_ids = segment_ids + ([pad_token_segment_id] * padding_length)

        assert len(input_ids) == max_seq_length
        assert len(input_mask) == max_seq_length
        assert len(segment_ids) == max_seq_length

        if output_mode == "classification":
            label_id = label_map[example.label]
        elif output_mode == "regression":
            label_id = float(example.label)
        else:
            raise KeyError(output_mode)

        logger.info("*** Example ***")
        logger.info("guid: %s" % (example.guid))
        logger.info("tokens: %s" % " ".join([str(x) for x in tokens]))
        logger.info("input_ids: %s" % " ".join([str(x) for x in input_ids]))
        logger.info("input_mask: %s" % " ".join([str(x) for x in input_mask]))
        logger.info("ext mask: %s" % " ".join([str(x) for x in extraction_mask]))
        logger.info("ext start: %d" % extraction_start_ids)
        logger.info("ext end: %d" % extraction_end_ids)
        logger.info("aug mask: %s" % " ".join([str(x) for x in augmentation_mask]))
        logger.info("aug start: %d" % augmentation_start_ids)
        logger.info("aug end: %d" % augmentation_end_ids)
        logger.info("label: %d" % label_id)

        extraction_start_ids = min(extraction_start_ids, 511)
        extraction_end_ids = min(extraction_end_ids, 511)
        augmentation_start_ids = min(augmentation_start_ids, 511)
        augmentation_end_ids = min(augmentation_end_ids, 511)

        features.append(
            InputFeatures(input_ids=input_ids,
                          input_mask=input_mask,
                          segment_ids=segment_ids,
                          label_id=label_id,
                          extraction_mask=extraction_mask,
                          extraction_start_ids=extraction_start_ids,
                          extraction_end_ids=extraction_end_ids,
                          augmentation_mask=augmentation_mask,
                          augmentation_start_ids=augmentation_start_ids,
                          augmentation_end_ids=augmentation_end_ids))
    return features


def set_seed(args):
    random.seed(args.seed)
    np.random.seed(args.seed)
    torch.manual_seed(args.seed)
    if args.n_gpu > 0:
        torch.cuda.manual_seed_all(args.seed)


def make_model_input(args, batch):
    inputs = {'input_ids':        batch[0],
              'attention_mask':   batch[1],
              'token_type_ids':   batch[2],
              'labels':           batch[3]}

    # add extraction and augmentation spans for PointerBert model
    if args.model_type == "pbert":
        inputs["ext_mask"] = batch[4]
        inputs["ext_start_labels"] = batch[5]
        inputs["ext_end_labels"] = batch[6]
        inputs["aug_mask"] = batch[7]
        inputs["aug_start_labels"] = batch[8]
        inputs["aug_end_labels"] = batch[9]
        inputs["loss_lambda"] = args.loss_lambda

    return inputs


def evaluate(json_inputs, prefix=""):
    global args, model, tokenizer

    if args is None or model is None or tokenizer is None:
        logger.error("You have to call init() before calling evaluate!")
        return

    # Loop to handle MNLI double evaluation (matched, mis-matched)
    eval_task = args.task_name

    eval_dataset = load_and_cache_examples(args, json_inputs, eval_task, tokenizer, evaluate=True)

    args.eval_batch_size = args.per_gpu_eval_batch_size * max(1, args.n_gpu)
    # Note that DistributedSampler samples randomly
    eval_sampler = SequentialSampler(eval_dataset) if args.local_rank == -1 else DistributedSampler(eval_dataset)
    eval_dataloader = DataLoader(eval_dataset, sampler=eval_sampler, batch_size=args.eval_batch_size)

    # Eval!
    logger.info("***** Running evaluation {} *****".format(prefix))
    logger.info("  Num examples = %d", len(eval_dataset))
    logger.info("  Batch size = %d", args.eval_batch_size)

    nb_eval_steps = 0
    preds = None
    out_label_ids = None

    for batch in tqdm(eval_dataloader, desc="Evaluating"):
        model.eval()
        batch = tuple(t.to(args.device) for t in batch)

        with torch.no_grad():
            inputs = make_model_input(args, batch)
            outputs = model(**inputs)
            # outputs = (label_logits, ext_start_logits, ext_end_logits, aug_start_logits, aug_end_logits, bert_outputs[2:])


            # monitoring
            logits_ix = 1 if args.model_type == "bert" else 0
            logits = outputs[logits_ix]

            if args.model_type == 'pbert':
                ext_start_logits = outputs[1]
                ext_end_logits = outputs[2]
                aug_start_logits = outputs[3]
                aug_end_logits = outputs[4]

            nb_eval_steps += 1

        if preds is None:
            preds = logits.detach().cpu()
            out_label_ids = inputs['labels'].detach().cpu()
        else:
            preds = np.append(preds, logits.detach().cpu(), axis=0)
            out_label_ids = np.append(out_label_ids, inputs['labels'].detach().cpu(), axis=0)

    labels = torch.argmax(preds, dim=1).tolist()
    scores = F.softmax(preds, dim=1).tolist()


    return labels, scores


def load_and_cache_examples(args, json_inputs, task, tokenizer, evaluate=False):
    processor = processors[task]()
    output_mode = output_modes[task]

    logger.info("Creating features from json input")

    # convert inputs to examples
    examples = []
    for (i, example) in enumerate(json_inputs):
        guid = str(i)
        text_a = example["text"]
        text_b = example["claim"]
        label = example["label"]
        examples.append(InputExample(guid=guid, text_a=text_a, text_b=text_b, label=label))

    label_list = processor.get_labels()
    features = convert_examples_to_features(examples, label_list, args.max_seq_length, tokenizer, output_mode,
        cls_token_at_end=bool(args.model_type in ['xlnet']),            # xlnet has a cls token at the end
        cls_token=tokenizer.cls_token,
        cls_token_segment_id=2 if args.model_type in ['xlnet'] else 0,
        sep_token=tokenizer.sep_token,
        sep_token_extra=bool(args.model_type in ['roberta']),
        pad_on_left=bool(args.model_type in ['xlnet']),                 # pad on the left for xlnet
        pad_token=tokenizer.convert_tokens_to_ids([tokenizer.pad_token])[0],
        pad_token_segment_id=4 if args.model_type in ['xlnet'] else 0)

    # Convert to Tensors and build dataset
    all_input_ids = torch.tensor([f.input_ids for f in features], dtype=torch.long)
    all_input_mask = torch.tensor([f.input_mask for f in features], dtype=torch.long)
    all_segment_ids = torch.tensor([f.segment_ids for f in features], dtype=torch.long)
    all_ext_mask = torch.tensor([f.extraction_mask for f in features], dtype=torch.float)
    all_ext_start_ids = torch.tensor([f.extraction_start_ids for f in features], dtype=torch.long)
    all_ext_end_ids = torch.tensor([f.extraction_end_ids for f in features], dtype=torch.long)
    all_aug_mask = torch.tensor([f.augmentation_mask for f in features], dtype=torch.float)
    all_aug_start_ids = torch.tensor([f.augmentation_start_ids for f in features], dtype=torch.long)
    all_aug_end_ids = torch.tensor([f.augmentation_end_ids for f in features], dtype=torch.long)

    if output_mode == "classification":
        all_label_ids = torch.tensor([f.label_id for f in features], dtype=torch.long)
    elif output_mode == "regression":
        all_label_ids = torch.tensor([f.label_id for f in features], dtype=torch.float)

    dataset = TensorDataset(all_input_ids, all_input_mask, all_segment_ids, all_label_ids,
                            all_ext_mask, all_ext_start_ids, all_ext_end_ids,
                            all_aug_mask, all_aug_start_ids, all_aug_end_ids)
    return dataset


def init():
    global args, model, tokenizer

    logger.info("INITIALIZING MODEL")

    parser = argparse.ArgumentParser()

    ## Required parameters
    parser.add_argument("--model_type", default=None, type=str,
                        help="Model type selected in the list: " + ", ".join(MODEL_CLASSES.keys()))
    parser.add_argument("--model_name_or_path", default=None, type=str,
                        help="Path to pre-trained model or shortcut name selected in the list: " + ", ".join(ALL_MODELS))
    parser.add_argument("--task_name", default=None, type=str,
                        help="The name of the task to train selected in the list: " + ", ".join(processors.keys()))

    ## Other parameters
    parser.add_argument("--config_name", default="", type=str,
                        help="Pretrained config name or path if not the same as model_name")
    parser.add_argument("--tokenizer_name", default="", type=str,
                        help="Pretrained tokenizer name or path if not the same as model_name")
    parser.add_argument("--cache_dir", default="", type=str,
                        help="Where do you want to store the pre-trained models downloaded from s3")
    parser.add_argument("--max_seq_length", default=512, type=int,
                        help="The maximum total input sequence length after tokenization. Sequences longer "
                             "than this will be truncated, sequences shorter will be padded.")
    parser.add_argument("--evaluate_during_training", action='store_true',
                        help="Run evaluation during training at each logging step.")
    parser.add_argument("--do_lower_case", action='store_true',
                        help="Set this flag if you are using an uncased model.")

    parser.add_argument("--per_gpu_train_batch_size", default=8, type=int,
                        help="Batch size per GPU/CPU for training.")
    parser.add_argument("--per_gpu_eval_batch_size", default=8, type=int,
                        help="Batch size per GPU/CPU for evaluation.")
    parser.add_argument('--gradient_accumulation_steps', type=int, default=1,
                        help="Number of updates steps to accumulate before performing a backward/update pass.")
    parser.add_argument("--learning_rate", default=5e-5, type=float,
                        help="The initial learning rate for Adam.")
    parser.add_argument("--loss_lambda", default=0.1, type=float,
                        help="The lambda parameter for loss mixing.")
    parser.add_argument("--weight_decay", default=0.0, type=float,
                        help="Weight deay if we apply some.")
    parser.add_argument("--adam_epsilon", default=1e-8, type=float,
                        help="Epsilon for Adam optimizer.")
    parser.add_argument("--max_grad_norm", default=1.0, type=float,
                        help="Max gradient norm.")
    parser.add_argument("--num_train_epochs", default=3.0, type=float,
                        help="Total number of training epochs to perform.")
    parser.add_argument("--max_steps", default=-1, type=int,
                        help="If > 0: set total number of training steps to perform. Override num_train_epochs.")
    parser.add_argument("--warmup_steps", default=0, type=int,
                        help="Linear warmup over warmup_steps.")

    parser.add_argument('--logging_steps', type=int, default=100,
                        help="Log every X updates steps.")
    parser.add_argument('--save_steps', type=int, default=50,
                        help="Save checkpoint every X updates steps.")
    parser.add_argument("--eval_all_checkpoints", action='store_true',
                        help="Evaluate all checkpoints starting with the same prefix as model_name ending and ending with step number")
    parser.add_argument("--no_cuda", action='store_true',
                        help="Avoid using CUDA when available")
    parser.add_argument('--overwrite_output_dir', action='store_true',
                        help="Overwrite the content of the output directory")
    parser.add_argument('--overwrite_cache', action='store_true',
                        help="Overwrite the cached training and evaluation sets")
    parser.add_argument('--seed', type=int, default=42,
                        help="random seed for initialization")

    parser.add_argument('--fp16', action='store_true',
                        help="Whether to use 16-bit (mixed) precision (through NVIDIA apex) instead of 32-bit")
    parser.add_argument('--fp16_opt_level', type=str, default='O1',
                        help="For fp16: Apex AMP optimization level selected in ['O0', 'O1', 'O2', and 'O3']."
                             "See details at https://nvidia.github.io/apex/amp.html")
    parser.add_argument("--local_rank", type=int, default=-1,
                        help="For distributed training: local_rank")

    args = parser.parse_args()
    args.task_name = "factcc_annotated"
    args.do_lower_case = True
    args.max_seq_length = 512
    args.per_gpu_eval_batch_size = 8
    args.model_type = "pbert"
    args.model_name_or_path = "bert-base-uncased"

    # Setup CUDA, GPU & distributed training
    device = torch.device("cuda" if torch.cuda.is_available() and not args.no_cuda else "cpu")
    args.n_gpu = torch.cuda.device_count()
    args.device = device

    # Setup logging
    logging.basicConfig(format='%(asctime)s - %(levelname)s - %(name)s -   %(message)s',
                        datefmt='%m/%d/%Y %H:%M:%S',
                        level=logging.INFO if args.local_rank in [-1, 0] else logging.WARN)
    logger.warning("Process rank: %s, device: %s, n_gpu: %s, distributed training: %s, 16-bits training: %s",
                    args.local_rank, device, args.n_gpu, bool(args.local_rank != -1), args.fp16)

    # Set seed
    set_seed(args)

    # Prepare GLUE task
    args.task_name = args.task_name.lower()
    if args.task_name not in processors:
        raise ValueError("Task not found: %s" % (args.task_name))
    processor = processors[args.task_name]()
    args.output_mode = output_modes[args.task_name]
    label_list = processor.get_labels()
    num_labels = len(label_list)

    # Load config
    args.model_type = args.model_type.lower()
    config_class, model_class, tokenizer_class = MODEL_CLASSES[args.model_type]
    config = config_class.from_pretrained(args.config_name if args.config_name else args.model_name_or_path, num_labels=num_labels, finetuning_task=args.task_name)
    model = model_class.from_pretrained(args.model_name_or_path, from_tf=bool('.ckpt' in args.model_name_or_path), config=config)
    model.to(args.device)

    # Load tokenizer
    tokenizer = tokenizer_class.from_pretrained(args.tokenizer_name if args.tokenizer_name else args.model_name_or_path, do_lower_case=args.do_lower_case)

    # Load model
    logger.info("Loading model from checkpoint.")
    checkpoint = os.environ.get('CHECKPOINT_DIR', default=directory / "factccx-checkpoint")
    model = model_class.from_pretrained(checkpoint)
    model.to(args.device)


def example():
    # json input
    json_inputs = [
        {
            "claim": "trey made the prom-posal (yes, that's what they are calling invites to prom.",
            "label": "CORRECT",
            "filepath": "cnndm/cnn/stories/1b2cc634e2bfc6f2595260e7ed9b42f77ecbb0ce.story",
            "id": "cnn-test-1b2cc634e2bfc6f2595260e7ed9b42f77ecbb0ce",
            "text": "(CNN)He's a blue chip college basketball recruit. She's a high school freshman with Down syndrome. At first glance Trey Moses and Ellie Meredith couldn't be more different. But all that changed Thursday when Trey asked Ellie to be his prom date. Trey -- a star on Eastern High School's basketball team in Louisville, Kentucky, who's headed to play college ball next year at Ball State -- was originally going to take his girlfriend to Eastern's prom. So why is he taking Ellie instead? \"She's great... she listens and she's easy to talk to\" he said. Trey made the prom-posal (yes, that's what they are calling invites to prom these days) in the gym during Ellie's P.E. class. Trina Helson, a teacher at Eastern, alerted the school's newspaper staff to the prom-posal and posted photos of Trey and Ellie on Twitter that have gone viral. She wasn't surpristed by Trey's actions. \"That's the kind of person Trey is,\" she said. To help make sure she said yes, Trey entered the gym armed with flowers and a poster that read \"Let's Party Like it's 1989,\" a reference to the latest album by Taylor Swift, Ellie's favorite singer. Trey also got the OK from Ellie's parents the night before via text. They were thrilled. \"You just feel numb to those moments raising a special needs child,\"  said Darla Meredith, Ellie's mom. \"You first feel the need to protect and then to overprotect.\" Darla Meredith said Ellie has struggled with friendships since elementary school, but a special program at Eastern called Best Buddies had made things easier for her. She said Best Buddies cultivates friendships between students with and without developmental disabilities and prevents students like Ellie from feeling isolated and left out of social functions. \"I guess around middle school is when kids started to care about what others thought,\" she said, but \"this school, this year has been a relief.\" Trey's future coach at Ball State, James Whitford, said he felt great about the prom-posal, noting that Trey, whom he's known for a long time, often works with other kids Trey's mother, Shelly Moses, was also proud of her son. \"It's exciting to bring awareness to a good cause,\" she said. \"Trey has worked pretty hard, and he's a good son.\" Both Trey and Ellie have a lot of planning to do. Trey is looking to take up special education as a college major, in addition to playing basketball in the fall. As for Ellie, she can't stop thinking about prom. \"Ellie can't wait to go dress shopping\" her mother said. \"Because I've only told about a million people!\" Ellie interjected."
        }
        ,
        {
            "claim": "trey did not make the prom-posal (yes, that's what they are calling invites to prom.",
            "label": "CORRECT",
            "filepath": "cnndm/cnn/stories/1b2cc634e2bfc6f2595260e7ed9b42f77ecbb0ce.story",
            "id": "cnn-test-1b2cc634e2bfc6f2595260e7ed9b42f77ecbb0ce",
            "text": "(CNN)He's a blue chip college basketball recruit. She's a high school freshman with Down syndrome. At first glance Trey Moses and Ellie Meredith couldn't be more different. But all that changed Thursday when Trey asked Ellie to be his prom date. Trey -- a star on Eastern High School's basketball team in Louisville, Kentucky, who's headed to play college ball next year at Ball State -- was originally going to take his girlfriend to Eastern's prom. So why is he taking Ellie instead? \"She's great... she listens and she's easy to talk to\" he said. Trey made the prom-posal (yes, that's what they are calling invites to prom these days) in the gym during Ellie's P.E. class. Trina Helson, a teacher at Eastern, alerted the school's newspaper staff to the prom-posal and posted photos of Trey and Ellie on Twitter that have gone viral. She wasn't surpristed by Trey's actions. \"That's the kind of person Trey is,\" she said. To help make sure she said yes, Trey entered the gym armed with flowers and a poster that read \"Let's Party Like it's 1989,\" a reference to the latest album by Taylor Swift, Ellie's favorite singer. Trey also got the OK from Ellie's parents the night before via text. They were thrilled. \"You just feel numb to those moments raising a special needs child,\"  said Darla Meredith, Ellie's mom. \"You first feel the need to protect and then to overprotect.\" Darla Meredith said Ellie has struggled with friendships since elementary school, but a special program at Eastern called Best Buddies had made things easier for her. She said Best Buddies cultivates friendships between students with and without developmental disabilities and prevents students like Ellie from feeling isolated and left out of social functions. \"I guess around middle school is when kids started to care about what others thought,\" she said, but \"this school, this year has been a relief.\" Trey's future coach at Ball State, James Whitford, said he felt great about the prom-posal, noting that Trey, whom he's known for a long time, often works with other kids Trey's mother, Shelly Moses, was also proud of her son. \"It's exciting to bring awareness to a good cause,\" she said. \"Trey has worked pretty hard, and he's a good son.\" Both Trey and Ellie have a lot of planning to do. Trey is looking to take up special education as a college major, in addition to playing basketball in the fall. As for Ellie, she can't stop thinking about prom. \"Ellie can't wait to go dress shopping\" her mother said. \"Because I've only told about a million people!\" Ellie interjected."
        }
    ]

    # Evaluation
    result = evaluate(json_inputs, prefix="test")

    # labels: ["CORRECT", "INCORRECT"]
    logger.info(result)


init()

# example()
