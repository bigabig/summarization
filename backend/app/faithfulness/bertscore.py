import requests
import json


def calculate_bertscore(source_document, summary_document):

    # first encode object so it contains no non JSON serializable data
    obj = json.dumps({
                    'source_document': source_document,
                    'summary_document': summary_document,
                }, default=lambda o: '<not serializable>')
    obj = json.loads(obj)

    # make request
    response = requests.post(f"http://localhost:4444/bertscore", json=obj)

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
