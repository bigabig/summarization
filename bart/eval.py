from datetime import time
from SummarizationModule import SummarizationModule
from evaluation_utils import calculate_rouge, chunks
from file_utils import save_json
import argparse
import time
from pathlib import Path
import torch
from tqdm import tqdm


device = "cuda" if torch.cuda.is_available() else "cpu"


def generate_summaries(hparams, examples, batch_size):
    # init model
    model = None
    if hparams.model_checkpoint is not None:
        model = SummarizationModule.load_from_checkpoint(checkpoint_path=hparams.model_checkpoint)
    elif hparams.model is not None:
        model = SummarizationModule(hparams)
    else:
        print("No model...")
        exit()
    model = model.to(device)

    # half precision
    if hparams.fp16:
        model.half_precision()

    start_time = time.time()

    # generate & write summaries
    fout = Path(hparams.save_path).open("w", encoding="utf-8")
    prefix = model.config.prefix
    for examples_chunk in tqdm(list(chunks(examples, batch_size))):
        examples_chunk = [prefix + text for text in examples_chunk]
        batch = model.tokenizer(examples_chunk,
                                return_tensors="pt",
                                truncation=True,
                                padding="longest",
                                max_length=hparams.max_length).to(device)
        summaries = model(batch)
        for hypothesis in summaries:
            fout.write(hypothesis + "\n")
            fout.flush()
    fout.close()

    runtime = int(time.time() - start_time)  # seconds
    return dict(runtime=runtime, seconds_per_sample=round(runtime / len(examples), 4))


def main(args):
    # make sure that the save path exists
    Path(args.save_path).parent.mkdir(exist_ok=True)

    # read input data
    examples = [x.rstrip() for x in open(args.input_path).readlines()]
    if args.n_obs > 0:
        examples = examples[: args.n_obs]

    # generate & write summaries
    runtime_metrics = generate_summaries(args, examples, args.batch_size)

    # compute rouge scores
    # TODO: why is calculation not deterministic?!
    output_lns = [x.rstrip() for x in open(args.save_path).readlines()]
    reference_lns = [x.rstrip() for x in open(args.reference_path).readlines()][: len(output_lns)]
    scores: dict = calculate_rouge(output_lns, reference_lns)

    # add runtime metrics / scores
    scores.update(runtime_metrics)

    # write scores
    print(scores)
    save_json(scores, args.score_path)


def add_arguments(parser):
    parser.add_argument("--model_checkpoint", type=str, help="path to the model checkpoint")
    parser.add_argument("--input_path", type=str, help="like cnn_dm/test.source")
    parser.add_argument("--save_path", type=str, help="where to save summaries")
    parser.add_argument("--reference_path", type=str, required=False, help="like cnn_dm/test.target")
    parser.add_argument("--score_path", type=str, required=False, default="metrics.json", help="where to save metrics")
    parser.add_argument(
        "--fp16",
        action="store_true",
        help="Whether to use 16-bit (mixed) precision (through NVIDIA apex) instead of 32-bit",
    )
    parser.add_argument("--batch_size", default=32, type=int)
    parser.add_argument("--max_length", default=1024, type=int)
    parser.add_argument(
        "--n_obs", type=int, default=-1, required=False, help="How many observations. Defaults to all."
    )

    return parser


if __name__ == "__main__":
    argument_parser = argparse.ArgumentParser()
    argument_parser = add_arguments(argument_parser)
    argument_parser = SummarizationModule.add_arguments(argument_parser)

    main(argument_parser.parse_args())
