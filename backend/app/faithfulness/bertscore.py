import requests
import json
import os

BERTSCORE_API = os.environ.get('BERTSCORE_API', default="http://localhost:4444/bertscore")


def calculate_bertscore(source_document, summary_document):

    # first encode object so it contains no non JSON serializable data
    obj = json.dumps({
                    'source_document': source_document,
                    'summary_document': summary_document,
                }, default=lambda o: '<not serializable>')
    obj = json.loads(obj)

    # make request
    response = requests.post(BERTSCORE_API, json=obj)

    json_result = response.json()
    # returns
    # {
    #     'summary_bertscores': [][],
    #     'source_bertscores': [][],
    #     'pbert': -1,
    #     'rbert': -1,
    #     'fbert': -1,
    # }

    if response.status_code == 200:

        # write the results into the corresponding documents
        summary_document['bertscores'] = json_result['summary_bertscores']
        source_document['bertscores'] = json_result['source_bertscores']

        summary_document['pbert'] = json_result['pbert']
        summary_document['rbert'] = json_result['rbert']
        summary_document['fbert'] = json_result['fbert']
        source_document['pbert'] = json_result['pbert']
        source_document['rbert'] = json_result['rbert']
        source_document['fbert'] = json_result['fbert']

    else:
        print(json_result['message'])

        # write some error results
        summary_document['bertscores'] = []
        source_document['bertscores'] = []

        summary_document['pbert'] = -1
        summary_document['rbert'] = -1
        summary_document['fbert'] = -1
        source_document['pbert'] = -1
        source_document['rbert'] = -1
        source_document['fbert'] = -1


def example():
    import spacy
    print("Loading spacy model...")
    nlp = spacy.load("en_core_web_md")

    source = "The tower is 324 metres (1,063 ft) tall, about the same height as an 81-storey building, and the tallest structure in Paris. " \
             "Its base is square, measuring 125 metres (410 ft) on each side. " \
             "During its construction, the Eiffel Tower surpassed the Washington Monument to become the tallest man-made structure in the world, " \
             "a title it held for 41 years until the Chrysler Building in New York City was finished in 1930. It was the first structure to reach a height of 300 metres. " \
             "Due to the addition of a broadcasting aerial at the top of the tower in 1957, it is now taller than the Chrysle Building by 5.2 metres (17 ft). " \
             "Excluding transmitters, the Eiffel Tower is the second tallest free-standing structure in France after the Millau Viaduct."

    summary = "The tower is 324 metres (1,063 ft) tall, about the same height as an 81-storey building. " \
              "It was the first structure to reach a height of 300 metres. " \
              "It is now taller than the Chrysler Building in New York City by 5.2 metres (17 ft) Excluding transmitters, the Eiffel Tower is the second tallest free-standing structure in France."

    source = "Albert Einstein was born in 2000."
    summary = "Albert Einstein was born in 1900."

    # both inputs are converted to docume bnts
    source_document = {
        'text': source
    }
    summary_document = {
        'text': summary
    }

    # both documents sentences are splitted
    sents = [sent.text.strip() for sent in nlp(source_document['text']).sents]
    source_document['sentences'] = [
        {
            'id': index,
            'text': sent,
        } for index, sent in enumerate(sents)
    ]
    sents = [sent.text.strip() for sent in nlp(summary_document['text']).sents]
    summary_document['sentences'] = [
        {
            'id': index,
            'text': sent,
        } for index, sent in enumerate(sents)
    ]

    calculate_bertscore(source_document, summary_document)
    print("LOL")


# example()