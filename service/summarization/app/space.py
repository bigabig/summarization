import spacy

nlp = spacy.load("en_core_web_md")


def split_sentences(document):
    doc = nlp(document)
    return [sent.text.strip() for sent in doc.sents]
