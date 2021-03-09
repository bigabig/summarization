from app.faithfulness.rouge import calculate_rouge
from app.space import apply_spacy
from app.embeddings import embed_document
from app.align import align_sentences
from app.faithfulness.bertscore import calculate_bertscore
from app.faithfulness.entailment import calculate_entailment
from app.faithfulness.qgqa import calculate_qa
from app.faithfulness.factcc import calculate_factcc
import json
import os


def annotate(text):
    document = {
        'text': text
    }
    apply_spacy(document)
    return document


def faithfulness_pipeline(data):
    source_text = data['input']
    summary_text = data['summary']
    method = data['method']

    # if os.path.isfile("temp.txt"):
    #     with open('temp.txt') as json_file:
    #         data = json.load(json_file)
    #
    #     return data['input_document'], data['summary_document']

    # annotate documents
    print("sentence splitting, ner ...")
    source_document = annotate(source_text)
    summary_document = annotate(summary_text)

    # embedd document (every sentence)
    print("embedding documents...")
    embed_document(source_document)
    embed_document(summary_document)

    # align sentences (calculate similarity matrices)
    align_sentences(summary_document, source_document)

    # step 6: compute bertscore
    print("calculating bertscore...")
    # calculate_bertscore(summary_document, source_document)

    # step 7: compute entailment
    print("calculating entailment...")
    # calculate_entailment(source_document, summary_document, method=method)

    # step 8: compute qgqa
    print("calculating qgqa...")
    # calculate_qa(summary_document, source_document)

    # step 9: compute factcc
    print("calculating factcc...")
    calculate_factcc(summary_document, source_document)

    # step 10: compute rouge
    print("calculating rouge...")
    calculate_rouge(summary_document, source_document)

    with open("temp.txt", mode="w", encoding="UTF-8") as file:
        json.dump({
            'summary_document': summary_document,
            'input_document': source_document
        }, file, default=lambda o: '<not serializable>', indent=4)

    return source_document, summary_document
