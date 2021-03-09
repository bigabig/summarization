from rouge_score import rouge_scorer

scorer = rouge_scorer.RougeScorer(['rouge1', 'rouge2', 'rougeL'], use_stemmer=True)


def calculate_rouge_scores(summary_document, source_document):
    scores = scorer.score(source_document['text'], summary_document['text'])
    summary_document['rouge'] = scores


def calculate_rouge(summary_document, source_document):
    calculate_rouge_scores(summary_document, source_document)
    calculate_rouge_scores(source_document, summary_document)


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

    source = "Albert Einstein was born in 2000."
    summary = "Albert Einstein was born in 1900."

    # both inputs are converted to docume bnts
    source_document = {
        'text': source
    }
    summary_document = {
        'text': summary
    }

    calculate_rouge_scores(source_document, summary_document)
    print("LOL")


# example()