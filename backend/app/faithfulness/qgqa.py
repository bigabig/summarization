import requests


def calculate_qa_score(summary_document, source_document):
    summary = summary_document['text']
    source = source_document['text']

    # make request
    # this api generates questions based on text1 and answers them using text1 (this answer) and using text2 (other_answer)
    response = requests.post(f"http://localhost:6666/qgqa", json={
        "text1": summary,
        "text2": source
    })

    json_result = response.json()
    if response.status_code == 200:

        # init
        for result in json_result['qa']:
            result['this_answer_sentences'] = []
            result['other_answer_sentences'] = []

        # find out in which sentences the answer occurs
        for sentence_id, sentence in enumerate(summary_document['sentences']):
            text = sentence['text']
            for result in json_result['qa']:
                answer = result['this_answer']  # answer by the summary
                if text.find(answer) != -1:
                    result['this_answer_sentences'].append(sentence_id)

        for sentence_id, sentence in enumerate(source_document['sentences']):
            text = sentence['text']
            for result in json_result['qa']:
                answer = result['other_answer']  # answer by the source
                if text.find(answer) != -1:
                    result['other_answer_sentences'].append(sentence_id)

        summary_document['qa'] = json_result['qa']
        summary_document['qa_score'] = json_result['score']
        # {'qa': [{'summary_answer': '300 metres', 'source_answer': '300 metres', 'question': 'The Eiffel Tower was the first structure to reach a height of what?'}, ... ], 'score': 0.8}

    else:
        print(json_result['message'])
        summary_document['qa'] = []
        summary_document['qa_score'] = -1


def calculate_qa(source_document, summary_document):
    calculate_qa_score(summary_document, source_document)
    calculate_qa_score(source_document, summary_document)


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

    calculate_qa(summary_document, source_document)
    print("LOL")


# example()
