import React, {useLayoutEffect, useState} from "react";
import TopSentences from "./TopSentences";
import AnnotatedSentence from "./AnnotatedSentence";
import TripleSentence from "./TripleSentence";
import {heatmap} from "../../helper/colorscales";
import {MyDocument} from "../../types/document";

type DocumentProvenanceViewerProps = {
    document: MyDocument | null | undefined
    summaryDocument: MyDocument | null | undefined
    sentenceID: number,
    showNER: boolean,
    showTriples: boolean,
}

function DocumentProvenanceViewer({document, summaryDocument, sentenceID, showNER, showTriples}: DocumentProvenanceViewerProps) {
    // local state
    const [selectedTripleSentence, setSelectedTripleSentence] = useState(-1);

    // reset local state whenever the file changes
    useLayoutEffect(() => {
        setSelectedTripleSentence(-1);
    }, [document])

    // actions
    const handleSelectTriple = (tripleID: number, selected: boolean) => {
        if(selected) {
            setSelectedTripleSentence(tripleID);
        } else {
            setSelectedTripleSentence(-1);
        }
    }

    // view
    let content: JSX.Element | JSX.Element[] = []

    // case zero: no alignment data is available
    if(!(summaryDocument && document && sentenceID < summaryDocument.sentence_alignment.length)) {
        content = <p>No alignment data is available for this document. Please save and/or summarize the document to generate alignments automatically.</p>

    // case one: visualize alignments
    } else if(!showNER && ! showTriples) {
        content = document.sentences.map((sentence, index) => (
            <p key={index} id={'document-sentence-' + index} className="document-sentence"
               style={sentenceID >= 0 ? {backgroundColor: heatmap(4 * (summaryDocument.sentence_alignment[sentenceID][index] - 0.75))} : {}}>
                {sentence.text}
            </p>
        ))

    // case two: visualize named entities + alignments
    } else if (showNER) {
        content = document.sentences
            .map((sentence, index) => (
                <p key={index} id={'document-sentence-' + index} className="document-sentence"
                   style={sentenceID >= 0 ? {backgroundColor: heatmap(4 * (summaryDocument.sentence_alignment[sentenceID][index] - 0.75))} : {}}>
                    <AnnotatedSentence key={index} sentence={sentence}/>
                </p>
            ))

    // case three: visualize triples + alignments
    } else if (showTriples) {
        content = document.sentences.map((sentence, index) => (
            <p key={index} id={'document-sentence-' + index} className="document-sentence"
               style={{
                   backgroundColor: sentenceID >= 0 ? heatmap(4 * (summaryDocument.sentence_alignment[sentenceID][index] - 0.75)) : "",
                   opacity: selectedTripleSentence >= 0 && index !== selectedTripleSentence ? '0.3333' : '1',
                   pointerEvents: selectedTripleSentence >= 0 && index !== selectedTripleSentence ? "none" : 'all'
               }}>
                <TripleSentence triple={sentence.triples_raw} onSelect={(selected) => handleSelectTriple(index, selected)}/>
            </p>
        ))

    // some error
    } else {
        content = <p>An unexpected error occurred. Please save and/or summarize the document to try again.</p>
    }

    return (
        <div className="textContainer text-left">
            {summaryDocument && sentenceID < summaryDocument.sentence_alignment.length && document && sentenceID >= 0 && (
                <div /*className="sticky-top"*/ style={{backgroundColor: "white"}}>
                    <h3>Top sentences:</h3>
                    <TopSentences sentenceID={sentenceID} alignmentData={summaryDocument.sentence_alignment} sentences={document.sentences.map(s => s.text)} />
                    <hr />
                </div>
            )}
            <div className="annotationContainer">
                {content}
            </div>
        </div>
    )
}

export default DocumentProvenanceViewer;