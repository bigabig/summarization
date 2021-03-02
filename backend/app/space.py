import spacy

print("Loading spacy model...")
nlp = spacy.load("en_core_web_md")


def split_sentences(text):
    return [sent.text.strip() for sent in nlp(text).sents]


def apply_spacy(document):
    document['sentences'] = []

    counter = 0
    sents = [sent.text.strip() for sent in nlp(document['text']).sents]
    for index, sent in enumerate(sents):
        document['sentences'].append({
            'id': index,
            'text': sent,
            'words': [{'id': counter + word_id, 'text': word} for word_id, word in enumerate(sent.split())],
            'ents': [{"start": ent.start_char, "end": ent.end_char, "tag": ent.label_} for ent in nlp(sent).ents]
        })
        counter += len(sent.split())


def apply_spacy_all(document, data):
    document['sentences'] = []
    document['sentence2document'] = []

    sents = [(sent.text.strip(), datum['id']) for datum in data for sent in nlp(datum['text']).sents]
    for index, sent in enumerate(sents):
        document['sentences'].append({
            'id': index,
            'text': sent[0],
            'ents': [{"start": ent.start_char, "end": ent.end_char, "tag": ent.label_} for ent in nlp(sent[0]).ents]
        })
        document['sentence2document'].append(sent[1])


def example():
    document = {}
    data = [{'text': "Tim is a great person. Everybody likes Tim.", 'id': 2}, {'text': "Tom is a great person. Everybody likes Tom.", 'id': 5}]
    apply_spacy_all(document, data)


# example()
