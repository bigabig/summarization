import requests
import json


def calculate_entailment_score(source_document, entailed_document, method):

    # first encode object so it contains no non JSON serializable data
    obj = json.dumps({
                    'source_document': source_document,
                    'entailed_document': entailed_document,
                    'method': 1
                }, default=lambda o: '<not serializable>')
    obj = json.loads(obj)

    # make request
    response = requests.post(f"http://localhost:4444/entailment", json=obj)

    json_result = response.json()
    # returns
    # {
    #     'sentence_results': [
    #       {
    #           'entailment': {
    #               'contradiction': 1,
    #               'neutral': 1,
    #               'entailment: 1
    #           },
    #           'entailed_by': [0, 1, 2]
    #        }
    #        ...
    #      ],
    #     'score': 1
    # }

    if response.status_code == 200:

        # write the results into the corresponding documents
        for idx, sentence_result in enumerate(json_result['sentence_results']):
            entailed_document['sentences'][idx]['entailment'] = sentence_result['entailment']
            entailed_document['sentences'][idx]['entailed_by'] = sentence_result['entailed_by']
        entailed_document['entailment'] = json_result['score']

    else:
        print(json_result['message'])

        # write some error results
        for sentence in entailed_document['sentences']:
            sentence['entailment'] = {
                'contradiction': -1,
                'neutral': -1,
                'entailment': -1,
            }
            sentence['entailed_by']: []
        entailed_document['entailment']: -1


def calculate_entailment(source_document, summary_document, method):
    calculate_entailment_score(source_document, summary_document, method)
    calculate_entailment_score(summary_document, source_document, method)
