import {TripleRaw} from "./triple";
import {Annotation} from "./annotations";
import {MyDocument} from "./document";

export type AnnotationResult = {
    annotations: Annotation[]
    triples: TripleRaw[]
}

export type SummarizationResult = {
    summary: string[],
    annotations: Annotation[],
    alignment: number[][],
    triples: TripleRaw[]
}

export type NewAnnotationResult = {
    document: MyDocument
}


export type NewSummarizationResult = {
    summary_document: MyDocument,
    input_document: MyDocument
}