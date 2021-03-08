from __future__ import absolute_import, division, print_function

import argparse
import csv
import json
import logging
import os
import random
import sys

import numpy as np
import torch

from model import BertPointer

from torch.utils.data import (DataLoader, SequentialSampler, TensorDataset)
from torch.utils.data.distributed import DistributedSampler
from tqdm import tqdm
from pytorch_transformers import (BertConfig, BertForSequenceClassification, BertTokenizer)

class DataProcessor(object):
    """Base class for data converters for sequence classification data sets."""

    def get_train_examples(self, data_dir):
        """Gets a collection of `InputExample`s for the train set."""
        raise NotImplementedError()

    def get_dev_examples(self, data_dir):
        """Gets a collection of `InputExample`s for the dev set."""
        raise NotImplementedError()

    def get_labels(self):
        """Gets the list of labels for this data set."""
        raise NotImplementedError()

    @classmethod
    def _read_tsv(cls, input_file, quotechar=None):
        """Reads a tab separated value file."""
        with open(input_file, "r", encoding="utf-8-sig") as f:
            reader = csv.reader(f, delimiter="\t", quotechar=quotechar)
            lines = []
            for line in reader:
                if sys.version_info[0] == 2:
                    line = list(unicode(cell, 'utf-8') for cell in line)
                lines.append(line)
            return lines

    @classmethod
    def _read_json(cls, input_file):
        """Reads a jsonl file."""
        with open(input_file, "r", encoding="utf-8") as f:
            lines = []
            for line in f:
                lines.append(json.loads(line))
        return lines


class FactCCGeneratedProcessor(DataProcessor):
    """Processor for the generated FactCC data set."""

    def get_train_examples(self, data_dir):
        """See base class."""
        return self._create_examples(
            self._read_json(os.path.join(data_dir, "data-train.jsonl")), "train")

    def get_dev_examples(self, data_dir):
        """See base class."""
        return self._create_examples(
            self._read_json(os.path.join(data_dir, "data-dev.jsonl")), "dev")

    def get_labels(self):
        """See base class."""
        return ["CORRECT", "INCORRECT"]

    def _create_examples(self, lines, set_type):
        """Creates examples for the training and dev sets."""
        examples = []
        for example in lines:
            guid = example["id"]
            text_a = example["text"]
            text_b = example["claim"]
            label = example["label"]
            extraction_span = example["extraction_span"]
            augmentation_span = example["augmentation_span"]

            examples.append(
                InputExample(guid=guid, text_a=text_a, text_b=text_b, label=label,
                             extraction_span=extraction_span, augmentation_span=augmentation_span))
        return examples


class FactCCManualProcessor(DataProcessor):
    """Processor for the WNLI data set (GLUE version)."""

    def get_train_examples(self, data_dir):
        """See base class."""
        return self._create_examples(
            self._read_json(os.path.join(data_dir, "data-train.jsonl")), "train")

    def get_dev_examples(self, data_dir):
        """See base class."""
        return self._create_examples(
            self._read_json(os.path.join(data_dir, "data-dev.jsonl")), "dev")

    def get_labels(self):
        """See base class."""
        return ["CORRECT", "INCORRECT"]

    def _create_examples(self, lines, set_type):
        """Creates examples for the training and dev sets."""
        examples = []
        for (i, example) in enumerate(lines):
            guid = str(i)
            text_a = example["text"]
            text_b = example["claim"]
            label = example["label"]
            examples.append(InputExample(guid=guid, text_a=text_a, text_b=text_b, label=label))
        return examples


processors = {
    "factcc_generated": FactCCGeneratedProcessor,
    "factcc_annotated": FactCCManualProcessor,
}

output_modes = {
    "factcc_generated": "classification",
    "factcc_annotated": "classification",
}