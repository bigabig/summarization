import React, {useLayoutEffect, useState} from "react";
import AnnotatedSentence from "./AnnotatedSentence";
import TripleSentence from "./TripleSentence";
import {colormap, heatmap} from "../../helper/colorscales";
import {MyDocument} from "../../types/document";


type ProvenanceViewerProps = {
    visualizeSummary: boolean
    inputDocument: MyDocument | null | undefined
    summaryDocument: MyDocument | null | undefined
    sentenceID: number,
    setSentenceID: React.Dispatch<React.SetStateAction<number>>,
    isSummarySentence: boolean
    setIsSummarySentence: React.Dispatch<React.SetStateAction<boolean>>,
    showNER: boolean,
    showTriples: boolean,
    showFaithfulness: boolean,
}


function ProvenanceViewer({visualizeSummary, inputDocument, summaryDocument, sentenceID, showNER, showTriples, showFaithfulness, setSentenceID, isSummarySentence, setIsSummarySentence}: ProvenanceViewerProps) {
    const document = visualizeSummary ? summaryDocument : inputDocument;
    const alignmentData = isSummarySentence ? summaryDocument?.sentence_alignment : inputDocument?.sentence_alignment;
    const sentence_id_prefix = visualizeSummary ? 'summary-sentence-' : 'document-sentence-';
    const className = visualizeSummary ? 'summary-sentence' : 'document-sentence';

    // local state
    const [isHidden, setIsHidden] = useState(true);
    const [selectedTripleSentence, setSelectedTripleSentence] = useState(-1);

    // reset local state whenever the file changes
    useLayoutEffect(() => {
        setIsHidden(true);
        setSelectedTripleSentence(-1);
    }, [document, summaryDocument])

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
        setIsSummarySentence(visualizeSummary);
    }

    // view
    const calcBackgroundColor = (index: number) => {
        if(alignmentData && sentenceID >= 0) {
            if(isSummarySentence === visualizeSummary && sentenceID === index) {
                return heatmap(1)
            } else if (isSummarySentence === visualizeSummary ) {
                return ""
            } else {
                return heatmap(4 * (alignmentData[sentenceID][index] - 0.75));
            }
        } else {
            return "";
        }
    }
    const calcColor = (faithfulness: number, index: number) => {
        if(alignmentData && sentenceID >= 0) {
            if (isSummarySentence === visualizeSummary && sentenceID === index) {
                return "white"
            }
        }
        if(faithfulness === -1) {
            return "black";
        } else {
            return colormap(faithfulness);
        }
    }

    let content: JSX.Element[] = []
    let lastFile = -1
    let currentFile = -1

    // case zero: no data is available
    if(!(document && summaryDocument && alignmentData && sentenceID < alignmentData.length)) {
        content.push(<p>No data is available for this document. Please summarize the document to generate data automatically.</p>)

    // case one: visualize alignments
    } else if(!showNER && !showTriples && !showFaithfulness) {
        document.sentences.forEach((sentence, index) => {
            if(document.sentence2document) {
                currentFile = document.sentence2document[sentence.id];
                if(currentFile !== lastFile) {
                    content.push(<h1 key={currentFile}>FILE {currentFile}</h1>)
                    lastFile = currentFile
                }
            }
            content.push(
                <p key={index} id={sentence_id_prefix + index}
                   className={className}
                   onClick={() => handleClick(index)}
                   style={{backgroundColor: calcBackgroundColor(index)}}>
                    {sentence.text}
                </p>
            )
        })

    // case two: visualize named entities + alignments
    } else if (showNER) {
        document.sentences.forEach((sentence, index) => {
            if(document.sentence2document) {
                currentFile = document.sentence2document[sentence.id];
                if(currentFile !== lastFile) {
                    content.push(<h1 key={currentFile}>FILE {currentFile}</h1>)
                    lastFile = currentFile
                }
            }
            content.push(
                <p key={index} id={sentence_id_prefix + index}
                   className={className}
                   onClick={() => handleClick(index)}
                   style={{backgroundColor: calcBackgroundColor(index)}}>
                    <AnnotatedSentence key={index} sentence={sentence}/>
                </p>
            )
        })

    // case three: visualize triples + alignments
    } else if (showTriples) {
        document.sentences.forEach((sentence, index) => {
            if(document.sentence2document) {
                currentFile = document.sentence2document[sentence.id];
                if(currentFile !== lastFile) {
                    content.push(<h1 key={currentFile}>FILE {currentFile}</h1>)
                    lastFile = currentFile
                }
            }
            content.push(
                <p key={index} id={sentence_id_prefix + index}
                   onClick={() => handleClick(index)}
                   className={className}
                   style={{
                       backgroundColor: calcBackgroundColor(index),
                       opacity: selectedTripleSentence >= 0 && index !== selectedTripleSentence ? '0.3333' : '1',
                       pointerEvents: selectedTripleSentence >= 0 && index !== selectedTripleSentence ? "none" : 'all'
                   }}>
                    <TripleSentence triple={sentence.triples_raw} onSelect={(selected) => handleSelectTriple(index, selected)}/>
                </p>
            )
        })

    // case four: visualize faithfulness + alignments
    } else if (showFaithfulness) {
        document.sentences.forEach((sentence, index) => {
            if(document.sentence2document) {
                currentFile = document.sentence2document[sentence.id];
                if(currentFile !== lastFile) {
                    content.push(<h1 key={currentFile}>FILE {currentFile}</h1>)
                    lastFile = currentFile
                }
            }
            content.push(
                <p key={index} id={sentence_id_prefix + index}
                   className={className}
                   onClick={() => handleClick(index)}
                   style={{
                       backgroundColor: calcBackgroundColor(index),
                       color: calcColor(sentence.faithfulness, index)
                   }}>
                    {sentence.text}
                </p>
            )
        })

    // some error
    } else {
        content.push(<p>An unexpected error occurred. Please save and/or summarize the document to try again.</p>)
    }

    return (
        <div className="textContainer text-left">
            <div className="annotationContainer">
                {content}
            </div>
        </div>
    )
}

export default ProvenanceViewer;
