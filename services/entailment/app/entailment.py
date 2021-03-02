import torch
import torch.nn.functional as F
from transformers import AutoTokenizer, AutoModelForSequenceClassification

print("Loading roberta model...")
tokenizer = AutoTokenizer.from_pretrained("roberta-large-mnli")
model = AutoModelForSequenceClassification.from_pretrained("roberta-large-mnli")


def calculate_entailment_scores_sentencewise(source_document, entailed_document):
    results = []  # results stores 'entailment' and 'entailed_by' for each sentence

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
        results.append({

            'entailment': {label: value for label, value in
                           zip(['contradiction', 'neutral', 'entailment'], best_entailment_scores[index])},

            # save which source sentences were used to calculate the entailment
            'entailed_by': [best_entailment_sentence_ids[index]]
        })

    # calculate entailment score for the whole entailed document
    score = max_entailments.values.mean().item()

    # return results
    return results, score


def calculate_entailment_scores_documentwise(source_document, entailed_document):
    results = []  # results stores 'entailment' and 'entailed_by' for each sentence

    # construct pairs
    sentence_pairs = []
    for summary_sentence in entailed_document['sentences']:
        sentence_pairs.append(f"{source_document['text']}</s>{summary_sentence['text']}")

    inputs = tokenizer(sentence_pairs, return_tensors="pt", padding=True)
    outputs = model(**inputs)  # [contradiction_score, neutral_score, entailment_score]

    all_scores = F.softmax(outputs['logits'].detach())

    # save results
    for index, entailed_sentence in enumerate(entailed_document['sentences']):
        results.append({

            'entailment': {label: value.item() for label, value in
                           zip(['contradiction', 'neutral', 'entailment'], all_scores[index])},

            # save which source sentences were used to calculate the entailment
            'entailed_by': []
        })

    # calculate entailment score for the whole entailed document
    score = all_scores[:, 2].mean().item()

    # return results
    return results, score


def calculate_entailment_scores_similarsentences(source_document, entailed_document):
    results = []  # results stores 'entailment' and 'entailed_by' for each sentence

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
        results.append({
            'entailed_by': indices.detach().tolist()
        })

    inputs = tokenizer(sentence_pairs, return_tensors="pt", padding=True)
    outputs = model(**inputs)  # [contradiction_score, neutral_score, entailment_score]

    all_scores = F.softmax(outputs['logits'].detach())

    # save results
    for index, entailed_sentence in enumerate(entailed_document['sentences']):
        results[index]['entailment'] = {label: value.item() for label, value in
                                        zip(['contradiction', 'neutral', 'entailment'], all_scores[index])}

    # calculate entailment score for the whole entailed document
    score = all_scores[:, 2].mean().item()

    # return results
    return results, score


def calculate_entailment(source_document, entailed_document, method=1):
    if method == 0:
        sentence_results, document_score = calculate_entailment_scores_sentencewise(source_document, entailed_document)
    elif method == 1:
        sentence_results, document_score = calculate_entailment_scores_similarsentences(source_document, entailed_document)
    elif method == 2:
        sentence_results, document_score = calculate_entailment_scores_documentwise(source_document, entailed_document)
    else:
        print("INVALID ENTAILMENT METHOD!!!")
        sentence_results, document_score = [], -1

    return {
        'sentence_results': sentence_results,
        'score': document_score
    }
