from allennlp.predictors.predictor import Predictor
from embeddings import embed_sentence

# init open ie model
print("Loading open ie model...")
predictor = Predictor.from_path("./models/openie-model.2020.03.26.tar.gz")


def compute_and_embed_triple_arguments(document, debug=False):
    global predictor
    triple_id = 0
    global_triple_id2sentence_id = []
    global_triple_id2local_triple_id = []

    for sentence in document['sentences']:
        sentence_result = []

        prediction = predictor.predict(sentence['text'])

        if debug:
            print(sentence['text'].strip())

        # parse prediction
        for verb in prediction['verbs']:
            local_triple_id = 0
            parse = {}
            last_value = ''
            for tag, word in zip(verb['tags'], prediction['words']):
                if tag == 'O':
                    iob, value = 'O', 'O'
                elif len(tag.split('-')) == 2:  # TODO: also allow other tags than I-ARG0, B-ARG1 etc. like B-ARGM-TMP
                    iob, value = tag.split('-')
                else:
                    continue

                if iob == 'B':
                    parse[value] = word
                elif iob == 'I' and value == last_value:
                    parse[value] += ' ' + word

                last_value = value

            if debug:
                print(parse)

            # only keep triples with more than 2 arguments and 1 verb
            if len(parse.keys()) >= 3 and 'V' in parse.keys():
                # use triple to create a sentence
                text = " ".join(parse.values())

                if debug:
                    print(parse)

                sentence_result.append({
                    'id': triple_id,
                    'text': text,
                    'embedding': embed_sentence(text),
                    'arguments': dict(sorted(parse.items()))
                })

                global_triple_id2sentence_id.append(sentence['id'])
                global_triple_id2local_triple_id.append(local_triple_id)

                local_triple_id += 1
                triple_id += 1

        sentence['triples_raw'] = prediction
        sentence['triples'] = sentence_result

        if debug:
            print("")

    document['global_triple_id2sentence_id'] = global_triple_id2sentence_id
    document['global_triple_id2local_triple_id'] = global_triple_id2local_triple_id


def example():
    document = {
        "sentences": [
            {
                "id": 0,
                "text": "\" I would have a very hard time justifying spending $ 20,000 on a wedding when I could go to Europe , \" one student says."
            }
        ]
    }
    compute_and_embed_triple_arguments(document)
    print(document)

# example()
