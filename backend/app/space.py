import spacy

print("Loading spacy model...")
nlp = spacy.load("en_core_web_md")


def apply_spacy(document):
    sents = [sent.text.strip() for sent in nlp(document['text']).sents]
    document['sentences'] = [
        {
            'id': index,
            'text': sent,
            'ents': [{"start": ent.start_char, "end": ent.end_char, "tag": ent.label_} for ent in nlp(sent).ents]
        } for index, sent in enumerate(sents)
    ]
