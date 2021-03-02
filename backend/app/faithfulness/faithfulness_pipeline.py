from app.space import apply_spacy


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
    from app.embeddings import embed_document
    embed_document(source_document)
    embed_document(summary_document)

    # align sentences (calculate similarity matrices)
    from app.align import align_sentences
    align_sentences(summary_document, source_document)

    # step 6: compute bertscore
    from app.faithfulness.bertscore import calculate_bertscore
    calculate_bertscore(summary_document, source_document)

    # step 7: compute entailment
    from app.faithfulness.entailment import calculate_entailment
    calculate_entailment(summary_document, source_document, method=1)

    # step 8: compute qgqa
    from app.faithfulness.qgqa import calculate_qa
    calculate_qa(summary_document, source_document)

    return source_document, summary_document
