import {Sentence} from "./sentence";

export type MyDocument = {
    text: string,
    sentences: Sentence[],
    globalTripleID2sentenceID: number[],
    globalTripleID2localTripleID: number[],
    sentence_alignment: number[][],
    triple_alignment: number[][],
}