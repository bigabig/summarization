import {MyAnnotationData, MyTriplesData} from "../../graphql/types/annotations";
import React, {useEffect, useState} from "react";
import AnnotatedSentence from "./AnnotatedSentence";
import TripleSentence from "./TripleSentence";


type SummaryProvenanceViewerProps = {
    annotationData: MyAnnotationData | null | undefined
    triplesData: MyTriplesData | null | undefined
    sentences: string[] | null | undefined
    sentenceID: number,
    setSentenceID: React.Dispatch<React.SetStateAction<number>>,
    showNER: boolean,
    showTriples: boolean,
}

function SummaryProvenanceViewer({annotationData, triplesData, sentences, sentenceID, setSentenceID, showNER, showTriples}: SummaryProvenanceViewerProps) {
    // local state
    const [isHidden, setIsHidden] = useState(true);
    const [selectedTripleSentence, setSelectedTripleSentence] = useState(-1);

    // reset local state whenever the file changes
    useEffect(() => {
        setIsHidden(true);
        setSelectedTripleSentence(-1);
    }, [annotationData, triplesData])

    // actions
    const handleSelectTriple = (tripleID: number, selected: boolean) => {
        if(selected) {
            setSelectedTripleSentence(tripleID);
        } else {
            setSelectedTripleSentence(-1);
        }
    }
    const handleClick = (id: number) => {
        if (id === sentenceID) {
            if(isHidden) {
                setIsHidden(false);
                setSentenceID(id);
            } else {
                setIsHidden(true);
                setSentenceID(-1);
            }
        } else {
            setIsHidden(false);
            setSentenceID(id);
        }
    }

    // view
    let content: JSX.Element | JSX.Element[] = []

    // case zero: no sentence data is available
    if(!sentences) {
        content = <p>No alignment data is available for this document. Please save and/or summarize the document to generate alignments automatically.</p>

    // case one: visualize alignments
    } else if(!showNER && !showTriples) {
        content = sentences.map((sentence, index) => (
            <p key={index} id={'summary-sentence-'+index} onClick={() => handleClick(index)} className="summary-sentence" style={index === sentenceID ? {backgroundColor: "rgba(0, 255, 255, 1)"} : {}}>
                {sentence}
            </p>
        ))

    // case two: visualize named entities + alignments
    } else if (showNER) {

        if(annotationData) {
            content = annotationData
                .map((annotation, index) => (
                    <p key={index} id={'summary-sentence-'+index} onClick={() => handleClick(index)} className="summary-sentence" style={index === sentenceID ? {backgroundColor: "rgba(0, 255, 255, 1)"} : {}}>
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
                <p key={index} id={'summary-sentence-'+index} onClick={() => handleClick(index)} className="summary-sentence"
                   style={{
                       backgroundColor: index === sentenceID ? "rgba(0, 255, 255, 1)": "",
                       opacity: selectedTripleSentence >= 0 && index !== selectedTripleSentence ? '0.3333' : '1',
                       pointerEvents: selectedTripleSentence >= 0 && index !== selectedTripleSentence ? "none" : 'all'
                   }}>
                    <TripleSentence key={index} triple={triple} onSelect={(selected) => handleSelectTriple(index, selected)}/>
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
            <div className="annotationContainer">
                {content}
            </div>
        </div>
    )
}

export default SummaryProvenanceViewer;