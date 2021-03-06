import {Sentence} from "./sentence";
import {QA} from "./qa";
import {Claim} from "./claim";
import {Rouge} from "./rouge";

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
    factcc_source: string,
    factcc_claims: Claim[],
    rouge: Rouge
}