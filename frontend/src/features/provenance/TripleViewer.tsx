import React, {useLayoutEffect, useState} from "react";
import {heatmap} from "../../helper/colorscales";
import {MyDocument} from "../../types/document";


type TripleViewerProps = {
    visualizeSummary: boolean
    inputDocument: MyDocument | null | undefined
    summaryDocument: MyDocument | null | undefined
    tripleID: number,
    setTripleID: React.Dispatch<React.SetStateAction<number>>,
    isSummaryTriple: boolean
    setIsSummaryTriple: React.Dispatch<React.SetStateAction<boolean>>,
}


function TripleViewer({visualizeSummary, inputDocument, summaryDocument, tripleID, setTripleID, isSummaryTriple, setIsSummaryTriple}: TripleViewerProps) {
    const document = visualizeSummary ? summaryDocument : inputDocument;
    const alignmentData = isSummaryTriple ? summaryDocument?.triple_alignment : inputDocument?.triple_alignment;
    const triple_id_prefix = visualizeSummary ? 'summary-triple-' : 'document-triple-';
    const className = visualizeSummary ? 'summary-triple' : 'document-triple';

    // local state
    const [isHidden, setIsHidden] = useState(true);

    // reset local state whenever the file changes
    useLayoutEffect(() => {
        setIsHidden(true);
    }, [document, summaryDocument])

    // actions
    const handleClick = (id: number) => {
        if (id === tripleID) {
            if(isHidden) {
                setIsHidden(false);
                setTripleID(id);
            } else {
                setIsHidden(true);
                setTripleID(-1);
            }
        } else {
            setIsHidden(false);
            setTripleID(id);
        }
        setIsSummaryTriple(visualizeSummary);
    }

    // view
    const calcBackgroundColor = (index: number) => {
        if(alignmentData && tripleID >= 0) {
            if(isSummaryTriple === visualizeSummary && tripleID === index) {
                return heatmap(1)
            } else if (isSummaryTriple === visualizeSummary) {
                return ""
            } else {
                return heatmap(4 * (alignmentData[tripleID][index] - 0.75));
            }
        } else {
            return "";
        }
    }

    let content: JSX.Element[] = []
    let lastFile = -1
    let currentFile = -1

    // case zero: no data is available
    if(!(document && summaryDocument && alignmentData && tripleID < alignmentData.length)) {
        content.push(<p>No data is available for this document. Please summarize the document to generate data automatically.</p>)

    // case one: visualize alignments
    } else {
        document.sentences.forEach((sentence) => {
            if(document.sentence2document) {
                currentFile = document.sentence2document[sentence.id];
                if(currentFile !== lastFile) {
                    content.push(<h1 key={currentFile}>FILE {currentFile}</h1>)
                    lastFile = currentFile
                }
            }
            content = content.concat(sentence.triples.map((triple) => (
                <p key={triple.id} id={triple_id_prefix + triple.id}
                   className={className}
                   onClick={() => handleClick(triple.id)}
                   style={{backgroundColor: calcBackgroundColor(triple.id)}}>
                    {triple.text}<br/>
                    {JSON.stringify(triple.arguments, Object.keys(triple.arguments).sort(), 2)}
                </p>
            )))
        })
    }

    return (
        <div className="textContainer text-left">
            <div className="annotationContainer">
                {content}
            </div>
        </div>
    )
}

export default TripleViewer;
