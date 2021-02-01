import {Verb} from "./verb";

export type Triple = {
    id: number,
    text: string,
    embedding: string,
    arguments: any
}

export type TripleRaw = {
    verbs: Verb[],
    words: string[],
}