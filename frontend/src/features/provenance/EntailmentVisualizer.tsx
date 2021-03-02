import React, {useLayoutEffect, useState} from "react";
import {MyDocument} from "../../types/document";
import {Entailments} from "../../types/entailments";
import {OverlayTrigger} from "react-bootstrap";
import Tooltip from "react-bootstrap/Tooltip";
import {colormap, highlightColorMap} from "../../helper/colorscales";

type EntailmentScoresProps = {
    scores: Entailments
    by: number[]
}

function EntailmentScores({scores, by}: EntailmentScoresProps) {
    return (
        <>
            <span className="text-success">Entailment:</span> {Math.round(100 * scores.entailment)}%<br />
            <span className="text-danger">Contradiction:</span> {Math.round(100 * scores.contradiction)}%<br />
            <span className="text-primary">Neutral:</span> {Math.round(100 * scores.neutral)}%<br />
            <span className="text-info">By:</span> {by}
        </>
    )
}


type EntailmentVisualizer = {
    visualizeSummary: boolean,
    inputDocument: MyDocument | null | undefined,
    summaryDocument: MyDocument | null | undefined,
    sentenceID: number,
    setSentenceID: React.Dispatch<React.SetStateAction<number>>,
    isSummarySentence: boolean
    setIsSummarySentence: React.Dispatch<React.SetStateAction<boolean>>,
}


function EntailmentVisualizer({visualizeSummary, inputDocument, summaryDocument, sentenceID, setSentenceID, isSummarySentence, setIsSummarySentence}: EntailmentVisualizer) {
    const document = visualizeSummary ? summaryDocument : inputDocument;
    const otherDocument = visualizeSummary ? inputDocument : summaryDocument;
    const prefix = visualizeSummary ? 'summary-' : 'document-';
    const className = visualizeSummary ? 'summary-sentence' : 'document-sentence';
    const faithfulnessMode = true;
    const threshold = 0.98;

    // local state
    const [isHidden, setIsHidden] = useState(true);

    // reset local state whenever the file changes
    useLayoutEffect(() => {
        setIsHidden(true);
    }, [document, summaryDocument])

    // actions
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
        setIsSummarySentence(visualizeSummary);
    }

    // view
    const calcBackgroundColor = (index: number) => {
        let color = ""

        if (document && faithfulnessMode === visualizeSummary && document.sentences[index].entailment.entailment < threshold) {
            color = colormap(document.sentences[index].entailment.entailment)
        }

        if(document && otherDocument && sentenceID >= 0) {
            // hovered word
            if(isSummarySentence === visualizeSummary && sentenceID === index) {
                return colormap(document.sentences[index].entailment.entailment)

                // corresponding word
            } else if (isSummarySentence !== visualizeSummary && otherDocument.sentences[sentenceID].entailed_by.indexOf(index) !== -1) {
                return colormap(otherDocument.sentences[sentenceID].entailment.entailment)
            }
        }

        return color;
    }

    const calcHighlight = (index: number) => {
        if(document && otherDocument && sentenceID >= 0) {
            // hovered word
            if(isSummarySentence === visualizeSummary && sentenceID === index) {
                return document.sentences[index].entailment.entailment.toFixed(2)

            // corresponding word
            } else if (isSummarySentence !== visualizeSummary && otherDocument.sentences[sentenceID].entailed_by.indexOf(index) !== -1) {
                return otherDocument.sentences[sentenceID].entailment.entailment.toFixed(2)
            }

        }
        return null;
    }

    let content: JSX.Element[] = []

    // case zero: no data is available
    if(!(document && summaryDocument)) {
        content.push(<p key={prefix + "entailment-error"}>No data is available for this document. Please summarize the document to generate data automatically.</p>)

    // case one: visualize alignments
    } else {
        document.sentences.forEach((sentence, index) => {
            content.push(
                <OverlayTrigger
                    placement={visualizeSummary ? "left" : "right"}
                    overlay={
                        <Tooltip id={`tooltip-top`}>
                            <EntailmentScores scores={sentence.entailment} by={sentence.entailed_by} />
                        </Tooltip>
                    }
                >
                    <p key={index} id={prefix + 'sentence-' + index}
                       className={className}
                       onClick={() => handleClick(sentence.id)}
                       data-entailment={calcHighlight(sentence.id)}
                       style={{
                           margin: "0.25em 0",
                           backgroundColor: calcBackgroundColor(sentence.id),
                       }}
                    >
                        {sentence.text}
                    </p>
                </OverlayTrigger>
            )
        })
        content.push(
            <p key={prefix + "entailment-score"}>
                Entailment: {Math.round(document.entailment * 100)}%
            </p>
        )
    }

    return (
        <div className="textContainer text-left">
            <div className="annotationContainer">
                {content}
            </div>
        </div>
    )
}

export default EntailmentVisualizer;
