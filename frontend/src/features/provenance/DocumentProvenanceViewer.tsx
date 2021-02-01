import {MyAnnotationData, MyTriplesData} from "../../graphql/types/annotations";
import React, {useLayoutEffect, useState} from "react";
import {MyAlignmentData} from "../../graphql/types/alignments";
import TopSentences from "./TopSentences";
import AnnotatedSentence from "./AnnotatedSentence";
import TripleSentence from "./TripleSentence";


type DocumentProvenanceViewerProps = {
    sentences: string[] | null | undefined
    annotationData: MyAnnotationData | null | undefined
    alignmentData: MyAlignmentData | null | undefined
    triplesData: MyTriplesData | null | undefined
    sentenceID: number,
    showNER: boolean,
    showTriples: boolean,
}

function DocumentProvenanceViewer({sentences, annotationData, alignmentData, triplesData, sentenceID, showNER, showTriples}: DocumentProvenanceViewerProps) {
    // local state
    const [selectedTripleSentence, setSelectedTripleSentence] = useState(-1);

    // reset local state whenever the file changes
    useLayoutEffect(() => {
        setSelectedTripleSentence(-1);
    }, [annotationData, alignmentData])

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
    if(!(alignmentData && sentences && sentenceID < alignmentData.length)) {
        content = <p>No alignment data is available for this document. Please save and/or summarize the document to generate alignments automatically.</p>

    // case one: visualize alignments
    } else if(!showNER && ! showTriples) {
        content = sentences.map((sentence, index) => (
            <p key={index} id={'document-sentence-' + index} className="document-sentence"
               style={sentenceID >= 0 && alignmentData[sentenceID][index] >= 0.75 ? {backgroundColor: "rgba(0, 255, 255," + 4 * (alignmentData[sentenceID][index] - 0.75) + ")"} : {}}>
                {sentence}
            </p>
        ))

    // case two: visualize named entities + alignments
    } else if (showNER) {

        if(annotationData) {
            content = annotationData
                .map((annotation, index) => (
                    <p key={index} id={'document-sentence-' + index} className="document-sentence"
                       style={sentenceID >= 0 && alignmentData[sentenceID][index] >= 0.75 ? {backgroundColor: "rgba(0, 255, 255," + 4 * (alignmentData[sentenceID][index] - 0.75) + ")"} : {}}>
                        <AnnotatedSentence key={index} annotation={annotation} showNER={showNER}/>
                    </p>
                ))
        } else {
            content = <p>No annotations available for this document. Please save and/or summarize the document to generate annotations automatically.</p>
        }

    // case three: visualize triples + alignments
    } else if (showTriples) {

        if (triplesData) {
            content = triplesData.map((triple, index) => (
                <p key={index} id={'document-sentence-' + index} className="document-sentence"
                   style={{
                       backgroundColor: sentenceID >= 0 && alignmentData[sentenceID][index] >= 0.75 ? "rgba(0, 255, 255," + 4 * (alignmentData[sentenceID][index] - 0.75) : "",
                       opacity: selectedTripleSentence >= 0 && index !== selectedTripleSentence ? '0.3333' : '1',
                       pointerEvents: selectedTripleSentence >= 0 && index !== selectedTripleSentence ? "none" : 'all'
                   }}>
                    <TripleSentence triple={triple} onSelect={(selected) => handleSelectTriple(index, selected)}/>
                </p>
            ))
        } else {
            content = <p>No triples available for this document. Please save and/or summarize the document to generate triples automatically.</p>
        }

    // some error
    } else {
        content = <p>An unexpected error occurred. Please save and/or summarize the document to try again.</p>
    }

    return (
        <div className="textContainer text-left">
            {alignmentData && sentenceID < alignmentData.length && sentences && sentenceID >= 0 && (
                <div /*className="sticky-top"*/ style={{backgroundColor: "white"}}>
                    <h3>Top sentences:</h3>
                    <TopSentences sentenceID={sentenceID} alignmentData={alignmentData} sentences={sentences} />
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