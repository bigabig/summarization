import json
from allennlp.predictors.predictor import Predictor

# init open ie model
predictor = Predictor.from_path("./models/openie-model.2020.03.26.tar.gz")


def compute_triples(input_sentences):
    result = []
    for sentence in input_sentences:
        prediction = predictor.predict(sentence)
        result.append(prediction)
        print(json.dumps(prediction, indent=4, sort_keys=True))

    return result


sentences = ["Tim is going to be a great person.", "He went to school in Lübeck.", "Today he was working at the University of Hamburg.", "He specialises in NLP technology.", "He currently works for the LT Group in Hamburg."]
compute_triples(sentences)
