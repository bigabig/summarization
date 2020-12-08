from allennlp.predictors.predictor import Predictor
from allennlp.data.tokenizers.sentence_splitter import SpacySentenceSplitter


def main():
    # init open ie model
    predictor = Predictor.from_path("./models/openie-model.2020.03.26.tar.gz")

    # init tokenizer / sentence splitter
    splitter = SpacySentenceSplitter()

    # init data
    data = "We introduce S2ORC, a large corpus of 81.1M English-language academic papers spanning many academic " \
           "disciplines. The corpus consists of rich metadata, paper abstracts, resolved bibliographic references, " \
           "as well as structured full text for 8.1M open access papers."

    # split input data into sentences
    sentences = splitter.split_sentences(data)

    # apply model on every sentence
    for sentence in sentences:
        prediction = predictor.predict(sentence)
        print(prediction)


if __name__ == '__main__':
    main()
