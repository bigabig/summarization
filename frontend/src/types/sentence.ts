import {Triple, TripleRaw} from "./triple";
import {Span} from "./annotations";
import {Word} from "./word";
import {Entailments} from "./entailments";

export type Sentence = {
    id: number,
    text: string,
    words: Word[],
    ents: Span[],
    embedding: string,
    triples_raw: TripleRaw,
    triples: Triple[],
    faithfulness: -1,
    entailment: Entailments,
    entailed_by: number[]
}