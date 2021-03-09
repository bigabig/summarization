export type Claim = {
    text: string,
    faithful: boolean,
    score_faithful: number,
    score_unfaithful: number,
    claim_start: number,
    claim_end: number,
    source_start: number,
    source_end: number,
}