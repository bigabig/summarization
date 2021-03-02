from utils import f1_score
from pipelines import pipeline
import numpy as np

print("Loading multitask-qaqg-qg model...")
nlp = pipeline("multitask-qaqg-qg", model="valhalla/t5-base-qaqg-qg-hl")


def calculate(text1, text2):
    # generate questions from text1
    print("Generating questions...")
    answer_question_pairs = nlp(text1)
    # => [{'answer': '42', 'question': 'What is the answer to life, the universe and everything?'}]

    # remove duplicates from the questions
    questions = [x['question'] for x in answer_question_pairs]
    questions = list(set(questions))

    print("Answering questions...")
    result = []
    for question in questions:
        # answer questions
        text2_answer = nlp({
            "question": question,
            "context": text2
        })
        # => 'the answer to life, the universe and everything'

        # answer questions
        text1_answer = nlp({
            "question": question,
            "context": text1
        })
        # => 'the answer to life, the universe and everything'

        # construct result object
        result.append({
            'this_answer': text1_answer,
            'other_answer': text2_answer,
            'question': question,
        })

    # calculate score (F1)
    # and assign an id to each (question, answer, answer, simlarity) pair
    score = []
    for idx, r in enumerate(result):
        f1 = f1_score(r['other_answer'], r['this_answer'])
        r['similarity'] = f1
        r['id'] = idx
        score.append(f1)

    return result, np.array(score).mean()


def example():
    source = "The tower is 324 metres (1,063 ft) tall, about the same height as an 81-storey building, and the tallest structure in Paris. " \
             "Its base is square, measuring 125 metres (410 ft) on each side. " \
             "During its construction, the Eiffel Tower surpassed the Washington Monument to become the tallest man-made structure in the world, " \
             "a title it held for 41 years until the Chrysler Building in New York City was finished in 1930. It was the first structure to reach a height of 300 metres. " \
             "Due to the addition of a broadcasting aerial at the top of the tower in 1957, it is now taller than the Chrysle Building by 5.2 metres (17 ft). " \
             "Excluding transmitters, the Eiffel Tower is the second tallest free-standing structure in France after the Millau Viaduct."

    summary = "The tower is 324 metres (1,063 ft) tall, about the same height as an 81-storey building. " \
              "It was the first structure to reach a height of 300 metres. " \
              "It is now taller than the Chrysler Building in New York City by 5.2 metres (17 ft) Excluding transmitters, the Eiffel Tower is the second tallest free-standing structure in France."

    answers_and_questions, score = calculate(source, summary)


# example()
