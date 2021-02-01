import {Triple, TripleRaw} from "./triple";
import {Span} from "./annotations";

export type Sentence = {
    id: number,
    text: string,
    ents: Span[],
    embedding: string,
    triples_raw: TripleRaw,
    triples: Triple[],
}