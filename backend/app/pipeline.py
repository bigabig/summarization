from align import align_sentences, align_triples
from triples import compute_and_embed_triple_arguments
from embeddings import embed_sentence
from space import apply_spacy
from summarization import summarize
import numpy as np


def annotation_pipeline(text):
    """
    - splits sentences
    - extracts named entities
    - calculates sentence embeddings
    - extracts triples
    - calculates triple embeddings
    """
    document = {
        'text': text
    }

    # step 1: apply spacy to split sentences and extract named entities
    apply_spacy(document)

    # step 2: apply bert to calculate embeddings for each sentence
    for sentence in document['sentences']:
        sentence['embedding'] = embed_sentence(sentence['text'])

    # step 3: apply allennlp to extract triples and embed the triples (with bert)
    compute_and_embed_triple_arguments(document)

    return document


def full_pipeline(input_text, length):
    """
    - applies annotation_pipeline
    - computes sentence similarities
    - computes triple similarities
    """
    # step 1: generate summary
    summary = summarize(input_text, length)

    # step 2: annotate documents
    input_document = annotation_pipeline(input_text)
    summary_document = annotation_pipeline(summary)

    # step 3: consume annotated documents to compute sentence alignment
    align_sentences(summary_document, input_document)

    # step 4: consume annotated documents to compute triple alignment
    align_triples(summary_document, input_document)

    return input_document, summary_document


def example():
    # parse input
    a = "Tim is a great person. He went to school in Lübeck. Today he works at the University of Hamburg. He specialises in NLP technology. He currently works for the LT Group in Hamburg."
    b = 150

    input_document, summary_document = full_pipeline(input_text=a, length=b)

    # use annotations
    triple_similarities = summary_document['triple_alignment']

    print("INPUT:")
    print(input_document['text'])
    print()

    print("SUMMARY:")
    print(summary_document['text'])
    print()

    print("Most similar triples:")
    for sentence in summary_document['sentences']:
        faithfulness = -1

        for triple in sentence['triples']:

            if 'id' in triple:
                # find the most similar triple
                similarities = np.array(triple_similarities[triple['id']])
                most_similar_triple_score = np.max(similarities)
                most_similar_triple_id = np.argmax(similarities)

                sentence_id = input_document['globalTripleID2sentenceID'][most_similar_triple_id]
                local_triple_id = input_document['globalTripleID2localTripleID'][most_similar_triple_id]

                triple_text = triple['text']
                most_similar_triple_text = input_document['sentences'][sentence_id]['triples'][local_triple_id]['text']

                print(triple_text)
                print(most_similar_triple_text)
                print("-----------------------")

# example()
