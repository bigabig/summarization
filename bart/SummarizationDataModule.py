from typing import Optional
from torch.utils.data import DataLoader
import pytorch_lightning as pl
from SummarizationDataset import SummarizationDataset


class SummarizationDataModule(pl.LightningDataModule):

    def __init__(self, hparams, tokenizer, prefix):
        super().__init__()

        self.tokenizer = tokenizer
        self.prefix = prefix

        # load parameters from hparams:
        self.data_dir = hparams.data_dir

        self.train_batch_size = hparams.train_batch_size
        self.eval_batch_size = hparams.eval_batch_size

        self.num_workers = hparams.num_workers

        self.max_source_length = hparams.max_source_length
        self.target_lens = {
            "train": hparams.train_max_target_length,
            "val": hparams.val_max_target_length,
            "test": hparams.test_max_target_length,
        }

        # State
        self.dataset_size = 0

    # this is called only on 1 GPU not on every GPU in distributed mode
    def prepare_data(self):
        # e.g. download the data
        print('preparing...')

    # this is called for every GPU (assigning state is OK)
    def setup(self, stage: Optional[str] = None):
        if stage == 'fit':
            self.dataset_size = len(self.train_dataloader().dataset)
        if stage == 'test':
            self.dataset_size = len(self.test_dataloader().dataset)

    def get_dataset_size(self):
        return self.dataset_size

    def get_dataset(self, type_path) -> SummarizationDataset:
        max_target_length = self.target_lens[type_path]
        dataset = SummarizationDataset(
            tokenizer=self.tokenizer,
            data_dir=self.data_dir,
            max_source_length=self.max_source_length,
            max_target_length=max_target_length,
            type_path=type_path,
            prefix=self.prefix or ""
        )
        return dataset

    def get_dataloader(self, type_path: str, batch_size: int, shuffle: bool = False) -> DataLoader:
        dataset = self.get_dataset(type_path)
        return DataLoader(
            dataset,
            batch_size=batch_size,
            collate_fn=dataset.collate_fn,
            shuffle=shuffle,
            num_workers=self.num_workers,
        )

    def train_dataloader(self) -> DataLoader:
        return self.get_dataloader("train", batch_size=self.train_batch_size, shuffle=True)

    def val_dataloader(self) -> DataLoader:
        return self.get_dataloader("val", batch_size=self.eval_batch_size)

    def test_dataloader(self) -> DataLoader:
        return self.get_dataloader("test", batch_size=self.eval_batch_size)

    # ------------------------------------------------------------------------------------------------------------------
    # Arguments
    # ------------------------------------------------------------------------------------------------------------------

    @staticmethod
    def add_arguments(parser):
        parser.add_argument(
            "--data_dir",
            default=None,
            type=str,
            required=True,
            help="The input data dir. Should contain the training files for the CoNLL-2003 NER task.",
        )

        parser.add_argument("--train_batch_size", default=32, type=int)
        parser.add_argument("--eval_batch_size", default=32, type=int)

        parser.add_argument("--num_workers", default=4, type=int, help="kwarg passed to DataLoader")

        parser.add_argument(
            "--max_source_length",
            default=1024,
            type=int,
            help="The maximum total input sequence length after tokenization. Sequences longer "
            "than this will be truncated, sequences shorter will be padded.",
        )
        parser.add_argument(
            "--train_max_target_length",
            default=56,
            type=int,
            help="The maximum total input sequence length after tokenization. Sequences longer "
            "than this will be truncated, sequences shorter will be padded.",
        )
        parser.add_argument(
            "--val_max_target_length",
            default=142,  # these defaults are optimized for CNNDM. For xsum, see README.md.
            type=int,
            help="The maximum total input sequence length after tokenization. Sequences longer "
            "than this will be truncated, sequences shorter will be padded.",
        )
        parser.add_argument(
            "--test_max_target_length",
            default=142,
            type=int,
            help="The maximum total input sequence length after tokenization. Sequences longer "
            "than this will be truncated, sequences shorter will be padded.",
        )

        return parser