import React, {useContext, useLayoutEffect, useState} from "react";
import {MyDocument} from "../../types/document";
import {OverlayTrigger} from "react-bootstrap";
import Tooltip from "react-bootstrap/Tooltip";
import {colormap, highlightColorMap} from "../../helper/colorscales";
import {FaithfulnesSettingsContext} from "../editor/DocumentEditor";

type FactCCViewerProps = {
    visualizeSummary: boolean,
    inputDocument: MyDocument | null | undefined,
    summaryDocument: MyDocument | null | undefined,
    sentenceID: number,
    setSentenceID: React.Dispatch<React.SetStateAction<number>>,
    isSummarySentence: boolean
    setIsSummarySentence: React.Dispatch<React.SetStateAction<boolean>>,
    faithfulnessMode: boolean,
}


function FactCCViewer({visualizeSummary, inputDocument, summaryDocument, sentenceID, setSentenceID, isSummarySentence, setIsSummarySentence, faithfulnessMode}: FactCCViewerProps) {
    const document = visualizeSummary ? summaryDocument : inputDocument;
    const otherDocument = visualizeSummary ? inputDocument : summaryDocument;
    const prefix = visualizeSummary ? 'summary-' : 'document-';
    const className = visualizeSummary ? 'summary-sentence' : 'document-sentence';

    // context
    const {settings} = useContext(FaithfulnesSettingsContext)

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
        // let color = ""
        //
        // if (document && faithfulnessMode === visualizeSummary && document.sentences[index].entailment.entailment < settings.EntailmentThreshold / 100.0) {
        //     color = colormap(document.sentences[index].entailment.entailment)
        // }
        //
        // if(document && otherDocument && sentenceID >= 0) {
        //     // hovered word
        //     if(isSummarySentence === visualizeSummary && sentenceID === index) {
        //         return colormap(document.sentences[index].entailment.entailment)
        //
        //         // corresponding word
        //     } else if (isSummarySentence !== visualizeSummary && otherDocument.sentences[sentenceID].entailed_by.indexOf(index) !== -1) {
        //         return colormap(otherDocument.sentences[sentenceID].entailment.entailment)
        //     }
        // }

        if(document && visualizeSummary === faithfulnessMode) {
            return colormap(1 - document.factcc_labels[index]);
        }
        return ""
    }

    const calcHighlight = (index: number) => {
        if(document && visualizeSummary === faithfulnessMode) {
            return document.factcc_scores[index][0].toFixed(2)
        }
        return null
    }

    let content: JSX.Element[] = []

    // case zero: no data is available
    if(!(document && summaryDocument)) {
        content.push(<p key={prefix + "factcc-error"}>No data is available for this document. Please summarize the document to generate data automatically.</p>)

        // case one: visualize alignments
    } else {
        document.sentences.forEach((sentence, index) => {
            content.push(
                <p key={index} id={prefix + 'sentence-' + index}
                   className={className}
                   onClick={() => handleClick(sentence.id)}
                   data-factcc={calcHighlight(sentence.id)}
                   style={{
                       margin: "0.25em 0",
                       backgroundColor: calcBackgroundColor(sentence.id),
                   }}
                >
                    {sentence.text}
                </p>
            )
        })
        content.push(
            <p key={prefix + "factcc-score"}>
                FactCC: 1%
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

export default FactCCViewer;
