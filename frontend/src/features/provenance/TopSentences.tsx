import {MyAlignmentData} from "../../graphql/types/alignments";

export type TopSentencesProps = {
    sentenceID: number,
    alignmentData: MyAlignmentData,
    sentences: string[]
}

function TopSentences({alignmentData, sentences, sentenceID}: TopSentencesProps) {

    // treshold
    const threshold = 0.75

    // calculate the top sentences
    let scoreSentenceIDPairs = alignmentData[sentenceID].map((value, index) => {return {id: index, score: value}});
    scoreSentenceIDPairs = scoreSentenceIDPairs.filter((pair) => pair.score >= threshold);
    let topPairs = scoreSentenceIDPairs.sort((a,b) => b.score - a.score).slice(0, scoreSentenceIDPairs.length >= 3 ? 3 : scoreSentenceIDPairs.length)

    // view
    let content: JSX.Element[]
    content = topPairs.map((pair) => (
        <li key={pair.id}><a key={pair.id} href={"#document-sentence-"+pair.id}>{pair.score.toFixed(2)}: {sentences[pair.id]}</a></li>
    ))

    return (
        <ul>
            {content}
        </ul>
    )
}

export default TopSentences;