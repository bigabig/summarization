import torch

from transformers import AutoTokenizer, AutoModelForSequenceClassification
import torch.nn.functional as F

print("Loading roberta model...")
tokenizer = AutoTokenizer.from_pretrained("roberta-large-mnli")
model = AutoModelForSequenceClassification.from_pretrained("roberta-large-mnli")


def calculate_entailment_scores_sentencewise(source_document, entailed_document):
    num_source_sentences = len(source_document['sentences'])
    num_entailed_sentences = len(entailed_document['sentences'])

    # construct pairs
    sentence_pairs = []
    for source_sentence in source_document['sentences']:
        for summary_sentence in entailed_document['sentences']:
            sentence_pairs.append(f"{source_sentence['text']}</s>{summary_sentence['text']}")

    inputs = tokenizer(sentence_pairs, return_tensors="pt", padding=True)
    outputs = model(**inputs)  # [contradiction_score, neutral_score, entailment_score]

    all_scores = F.softmax(outputs['logits'].detach())
    all_scores = all_scores.reshape([num_source_sentences, num_entailed_sentences, 3])

    # for every summary sentence find source sentences that have the highest entailment score
    entailment_scores = all_scores[:, :, 2]
    max_entailments = entailment_scores.max(dim=0)
    best_entailment_scores = all_scores[max_entailments.indices, [i for i in range(num_entailed_sentences)]].tolist()
    best_entailment_sentence_ids = max_entailments.indices.tolist()

    # save results
    for index, entailed_sentence in enumerate(entailed_document['sentences']):
        entailed_sentence['entailment'] = {label: value for label, value in
                                           zip(['contradiction', 'neutral', 'entailment'],
                                               best_entailment_scores[index])}
        entailed_sentence['entailed_by'] = [best_entailment_sentence_ids[index]]

    # calculate entailment score for the whole entailed document
    entailed_document['entailment'] = max_entailments.values.mean().item()


def calculate_entailment_scores_documentwise(source_document, entailed_document):
    # construct pairs
    sentence_pairs = []
    for summary_sentence in entailed_document['sentences']:
        sentence_pairs.append(f"{source_document['text']}</s>{summary_sentence['text']}")

    inputs = tokenizer(sentence_pairs, return_tensors="pt", padding=True)
    outputs = model(**inputs)  # [contradiction_score, neutral_score, entailment_score]

    all_scores = F.softmax(outputs['logits'].detach())

    # save results
    for index, entailed_sentence in enumerate(entailed_document['sentences']):
        entailed_sentence['entailment'] = {label: value.item() for label, value in
                                           zip(['contradiction', 'neutral', 'entailment'], all_scores[index])}
        entailed_sentence['entailed_by'] = []

    # calculate entailment score for the whole entailed document
    entailments = all_scores[:, 2]
    entailed_document['entailment'] = entailments.mean().item()


def calculate_entailment_scores_similarsentences(source_document, entailed_document):
    # construct pairs consisting of a summary sentence and the k most similar source sentences
    similar_sentences = torch.tensor(entailed_document['sentence_alignment'])
    sentence_pairs = []
    for idx, entailed_sentence in enumerate(entailed_document['sentences']):
        # get the k most similar source sentences
        indices = torch.topk(similar_sentences[idx], k=3, largest=True).indices

        # append the most similar sentences
        text = " ".join([source_document['sentences'][i]['text'] for i in indices])

        # construct the similar sentences => summary sentence pairs
        sentence_pairs.append(f"{text}</s>{entailed_sentence['text']}")

        # save which source sentences were used to calculate the entailment
        entailed_sentence['entailed_by'] = indices.detach().tolist()

    inputs = tokenizer(sentence_pairs, return_tensors="pt", padding=True)
    outputs = model(**inputs)  # [contradiction_score, neutral_score, entailment_score]

    all_scores = F.softmax(outputs['logits'].detach())

    # save results
    for index, entailed_sentence in enumerate(entailed_document['sentences']):
        entailed_sentence['entailment'] = {label: value.item() for label, value in
                                           zip(['contradiction', 'neutral', 'entailment'], all_scores[index])}

    # calculate entailment score for the whole entailed document
    entailments = all_scores[:, 2]
    entailed_document['entailment'] = entailments.mean().item()


def calculate_entailment(source_document, summary_document, method=1):
    if method == 0:
        calculate_entailment_scores_sentencewise(source_document, summary_document)
        calculate_entailment_scores_sentencewise(summary_document, source_document)
    elif method == 1:
        calculate_entailment_scores_similarsentences(source_document, summary_document)
        calculate_entailment_scores_similarsentences(summary_document, source_document)
    elif method == 2:
        calculate_entailment_scores_documentwise(source_document, summary_document)
        calculate_entailment_scores_documentwise(summary_document, source_document)
    else:
        print("INVALID ENTAILMENT METHOD!!!")


def example():
    import spacy
    print("Loading spacy model...")
    nlp = spacy.load("en_core_web_md")

    # A user uploads source document and summary
    source = "The tower is 324 metres (1,063 ft) tall, about the same height as an 81-storey building, and the tallest structure in Paris. " \
             "Its base is square, measuring 125 metres (410 ft) on each side. " \
             "During its construction, the Eiffel Tower surpassed the Washington Monument to become the tallest man-made structure in the world, " \
             "a title it held for 41 years until the Chrysler Building in New York City was finished in 1930. " \
             "It was the first structure to reach a height of 300 metres. " \
             "Due to the addition of a broadcasting aerial at the top of the tower in 1957, it is now taller than the Chrysler Building by 5.2 metres (17 ft). " \
             "Excluding transmitters, the Eiffel Tower is the second tallest free-standing structure in France after the Millau Viaduct."
    summary = "The tower is 324 metres (1,063 ft) tall, about the same height as an 81-storey building. " \
              "It was the first structure to reach a height of 300 metres. " \
              "It is now taller than the Chrysler Building in New York City by 5.2 metres (17 ft). " \
              "Excluding transmitters, the Eiffel Tower is the second tallest free-standing structure in France."

    # both inputs are converted to documents
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

    # embedd sentences with bert
    # init bert model
    from transformers import BertModel, BertTokenizer
    print("Loading bert model...")
    modelname = 'bert-base-uncased'
    bert_tokenizer = BertTokenizer.from_pretrained(modelname)
    bert_model = BertModel.from_pretrained(modelname)

    def embed_document(document):
        # tokenize sentence
        sentences = [sent['text'] for sent in document['sentences']]
        input_tokens = bert_tokenizer(sentences, max_length=bert_tokenizer.model_max_length, return_tensors='pt',
                                      padding=True)

        # embed sentence
        with torch.no_grad():
            outputs = bert_model(**input_tokens)
        last_hidden_states = outputs[0]  # The last hidden-state is the first element of the output

        # calculate sentence embeddings by averaging the token embeddings
        sentence_embeddings = last_hidden_states.mean(dim=1)

        # save the result
        for idx, sent in enumerate(document['sentences']):
            sent['embedding'] = sentence_embeddings[idx]

    def calculate_similarities(embeddings1, embeddings2):
        if len(embeddings1) == 0 or len(embeddings2) == 0:
            return [], []

        # normalize the embeddings & construct a matrix
        matrix1 = torch.stack([x / x.norm() for x in embeddings1])
        matrix2 = torch.stack([x / x.norm() for x in embeddings2])

        # calculate similarity matrix with dot product of normalized vectors
        similarities12 = matrix1.mm(matrix2.T)
        similarities21 = matrix2.mm(matrix1.T)
        return similarities12.tolist(), similarities21.tolist()

    def align_sentences(summary_document, input_document):
        # get the sentence embeddings
        summary_embeddings = [sentence['embedding'] for sentence in summary_document['sentences']]
        document_embeddings = [sentence['embedding'] for sentence in input_document['sentences']]

        summary_document_similarities, document_summary_similarities = calculate_similarities(summary_embeddings,
                                                                                              document_embeddings)
        summary_document['sentence_alignment'] = summary_document_similarities
        input_document['sentence_alignment'] = document_summary_similarities

    embed_document(summary_document)
    embed_document(source_document)

    align_sentences(summary_document, source_document)

    calculate_entailment(source_document, summary_document)
    print("finished")


# example()
