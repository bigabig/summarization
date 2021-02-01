import {MyAlignmentData} from "./alignments";

export type MySpan = {
    tag: string,
    start: number,
    end: number
}

export type MyAnnotation = {
    text: string,
    ents: MySpan[],
}

export type MyAnnotationData = MyAnnotation[]

export type MyVerb = {
    description: string,
    tags: string[],
    verb: string
}

export type MyTriple = {
    verbs: MyVerb[],
    words: string[],
}

export type MyTriplesData = MyTriple[]

export type MyAnnotationDataResult = {
    annotations: MyAnnotationData
    triples: MyTriplesData
}

export type MySummarizationDataResult = {
    summary: string[],
    annotations: MyAnnotationData,
    alignment: MyAlignmentData,
    triples: MyTriplesData
}