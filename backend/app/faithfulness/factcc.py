import requests
import os

FACTCC_API = os.environ.get('FACTCC_API', default="http://localhost:7777/factcc")


def calculate_factcc_scores(source_document, summary_document):

    # make request
    request_obj = {
        "claims": [sentence['text'] for sentence in summary_document['sentences']],
        "source": source_document['text']
    }
    response = requests.post(FACTCC_API, json=request_obj)

    # parse response
    json_result = response.json()
    # returns
    # {
    #     'source': source,
    #     'claims': [{
    #         'text': claim,
    #         'faithful': labels[idx], # 0 = faithful, 1 = unfaithful!
    #         'score_faithful': scores[idx][0],
    #         'score_unfaithful': scores[idx][1],
    #         'claim_start': claim_start,
    #         'claim_end': claim_end,
    #         'source_start': source_start,
    #         'source_end': source_end,
    #     }]
    # }

    if response.status_code == 200:
        # write the results into the corresponding documents
        summary_document['factcc_source'] = json_result['source']
        summary_document['factcc_claims'] = json_result['claims']

    else:
        print(json_result['message'])

        # write some error results
        summary_document['factcc_source'] = ""
        summary_document['factcc_claims'] = []


def calculate_factcc(source_document, summary_document):
    calculate_factcc_scores(source_document, summary_document)
    calculate_factcc_scores(summary_document, source_document)


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
              "It is now taller than the Chrysler Building in New York City by 5.2 metres (17 ft). " \
              "Excluding transmitters, the Eiffel Tower is the second tallest free-standing structure in France."

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

    calculate_factcc(source_document, summary_document)
    print("LOL")


# example()
