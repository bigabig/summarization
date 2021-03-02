export type Span = {
    tag: string,
    start: number,
    end: number
}

export type Annotation = {
    text: string,
    ents: Span[],
}
