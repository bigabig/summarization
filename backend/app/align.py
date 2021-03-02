import torch


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

    summary_document_similarities, document_summary_similarities = calculate_similarities(summary_embeddings, document_embeddings)
    summary_document['sentence_alignment'] = summary_document_similarities
    input_document['sentence_alignment'] = document_summary_similarities


def align_triples(summary_document, input_document):
    # get the triple embeddings
    summary_embeddings = [triple['embedding'] for sentence in summary_document['sentences'] for triple in sentence['triples'] if 'embedding' in triple]
    document_embeddings = [triple['embedding'] for sentence in input_document['sentences'] for triple in sentence['triples'] if 'embedding' in triple]

    summary_document_similarities, document_summary_similarities = calculate_similarities(summary_embeddings, document_embeddings)
    summary_document['triple_alignment'] = summary_document_similarities
    input_document['triple_alignment'] = document_summary_similarities
