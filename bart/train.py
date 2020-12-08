import argparse
import os
from pytorch_lightning.callbacks import ModelCheckpoint
from pytorch_lightning.loggers import TensorBoardLogger
import pytorch_lightning as pl
from SummarizationDataModule import SummarizationDataModule
from SummarizationModule import SummarizationModule
from SummarizationLoggingCallback import SummarizationLoggingCallback


def main(hparams):
    # apply seed
    pl.seed_everything(hparams.seed)

    # init model
    model = SummarizationModule(hparams)

    # init data
    datamodule = SummarizationDataModule(
        hparams,
        tokenizer=model.tokenizer,
        prefix=model.config.prefix
    )
    model.get_dataset_size_fcn = datamodule.get_dataset_size  # the model needs access to dataset size

    # init trainer
    # there is also an EarlyStoppingCallback that automatically stops training
    # if a certain metric has not improved for a certain number of steps!
    logger = TensorBoardLogger(
        save_dir=os.getcwd(),
        version=hparams.experiment_version,
        name='experiments',
    )

    # saves a file like: my/path/sample-mnist-epoch=02-val_loss=0.32.ckpt
    logging_callback = SummarizationLoggingCallback()
    checkpoint_callback = ModelCheckpoint(
        monitor='val_loss',
        dirpath=logger.log_dir + '/checkpoints/',
        filename='summarization-{epoch:02d}-{val_loss:.4f}',
        save_top_k=hparams.max_epochs,  # save all models
        mode='min',
    )
    accelerator = 'ddo' if hparams.gpus > 1 else None
    trainer = pl.Trainer(
        default_root_dir=hparams.root_dir,  # a checkpoint is created automatically after each epoch
        resume_from_checkpoint=hparams.resume_from_checkpoint,  # loads model from checkpoint if not None
        max_epochs=hparams.max_epochs,  # trains the model for n epochs (there is also max_steps)
        gpus=hparams.gpus,  # all gpus: -1, train on 5 gpus: 5, train on specific gpus: [1, 3]
        check_val_every_n_epoch=hparams.val_every_n_epoch,  # validation is executed every nth epoch
        callbacks=[checkpoint_callback, logging_callback],
        logger=logger,
        limit_train_batches=10,
        limit_test_batches=2,
        limit_val_batches=2,
        precision=16 if hparams.fp16 else 32,
        auto_select_gpus=True,
        accelerator=accelerator
    )

    # train the model
    trainer.fit(model, datamodule=datamodule)

    # test the (best) model
    trainer.test(model, datamodule=datamodule)

    # load a model from checkpoint
    # cn = 'mnist-epoch=00-val_loss=0.41.chkpt'
    # final_model = LightningEncoderDecoder.load_from_checkpoint(checkpoint_path=checkpoint_callback.dirpath + '/' + cn)


# ------------------------------------------------------------------------------------------------------------------
# Arguments
# ------------------------------------------------------------------------------------------------------------------

def add_arguments(parser):
    # Seed
    parser.add_argument("--seed", type=int, default=42, help="random seed for initialization")

    # Tensorboard logger (for training)
    parser.add_argument('--experiment_version', default=1, type=int)

    # Trainer
    parser.add_argument('--root_dir', default=os.getcwd())
    parser.add_argument('--resume_from_checkpoint', default=None)
    parser.add_argument("--num_train_epochs", dest="max_epochs", default=3, type=int)
    parser.add_argument('--gpus', default=1, type=int)
    parser.add_argument('--val_every_n_epoch', default=1, type=int)
    parser.add_argument(
        "--fp16",
        action="store_true",
        help="Whether to use 16-bit (mixed) precision (through NVIDIA apex) instead of 32-bit",
    )

    return parser


# TODO: was ist hp_metric im tensorboard?
if __name__ == '__main__':
    argument_parser = argparse.ArgumentParser()
    argument_parser = add_arguments(argument_parser)
    argument_parser = SummarizationModule.add_arguments(argument_parser)
    argument_parser = SummarizationDataModule.add_arguments(argument_parser)

    my_args = ['--experiment_version', '1',
               '--gpus', '1',
               '--train_batch_size', '8',
               '--eval_batch_size', '16',
               '--fp16',
               '--epochs', '4',
               '--num_workers', '8']

    # main(argument_parser.parse_args(my_args))
    main(argument_parser.parse_args())
