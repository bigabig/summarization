from app.space import apply_spacy
from app.embeddings import embed_document
from app.align import align_sentences
from app.faithfulness.bertscore import calculate_bertscore
from app.faithfulness.entailment import calculate_entailment
from app.faithfulness.qgqa import calculate_qa
from app.faithfulness.factcc import calculate_factcc


def annotate(text):
    document = {
        'text': text
    }
    apply_spacy(document)
    return document


def faithfulness_pipeline(data):
    source_text = data['input']
    summary_text = data['summary']

    # annotate documents
    source_document = annotate(source_text)
    summary_document = annotate(summary_text)

    # embedd document (every sentence)
    embed_document(source_document)
    embed_document(summary_document)

    # align sentences (calculate similarity matrices)
    align_sentences(summary_document, source_document)

    # step 6: compute bertscore
    # print("calculating bertscore...")
    # calculate_bertscore(summary_document, source_document)

    # step 7: compute entailment
    # print("calculating entailment...")
    # calculate_entailment(summary_document, source_document, method=1)

    # step 8: compute qgqa
    # print("calculating qgqa...")
    # calculate_qa(summary_document, source_document)

    # step 8: compute qgqa
    print("calculating factcc...")
    calculate_factcc(summary_document, source_document)

    return source_document, summary_document
