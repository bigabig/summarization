import {Sentence} from "./sentence";
import {QA} from "./qa";

export type MyDocument = {
    text: string,
    sentences: Sentence[],
    globalTripleID2sentenceID: number[],
    globalTripleID2localTripleID: number[],
    sentence_alignment: number[][],
    triple_alignment: number[][],
    sentence2document: number[] | undefined,
    bertscores: any[][],
    pbert: number,
    rbert: number,
    fbert: number,
    entailment: number,
    qa: QA[],
    qa_score: number,
    factcc_labels: number[]
    factcc_scores: number[][]
}