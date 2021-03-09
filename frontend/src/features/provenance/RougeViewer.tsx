import React from "react";
import {MyDocument} from "../../types/document";
import {Rouge} from "../../types/rouge";

type RougeScoreVisualizerProps = {
    scores: number[]
}

function RougeScoreVisualizer({scores}: RougeScoreVisualizerProps) {
    return <p>P: {scores[0].toFixed(2)} R: {scores[1].toFixed(2)} F: {scores[2].toFixed(2)}</p>
}

type RougeVisualizerProps = {
    rouge: Rouge
}

function RougeVisualizer({rouge}: RougeVisualizerProps) {
    return (
        <div>
            <h4>Rouge 1:</h4>
            <RougeScoreVisualizer scores={rouge.rouge1} />
            <h4>Rouge 2:</h4>
            <RougeScoreVisualizer scores={rouge.rouge2} />
            <h4>Rouge L:</h4>
            <RougeScoreVisualizer scores={rouge.rougeL} />
        </div>
    )
}

type RougeViewerProps = {
    visualizeSummary: boolean,
    inputDocument: MyDocument | null | undefined,
    summaryDocument: MyDocument | null | undefined,
    faithfulnessMode: boolean,
}

function RougeViewer({visualizeSummary, inputDocument, summaryDocument, faithfulnessMode}: RougeViewerProps) {
    const document = visualizeSummary ? summaryDocument : inputDocument;
    const otherDocument = visualizeSummary ? inputDocument : summaryDocument;
    const prefix = visualizeSummary ? 'summary-' : 'document-';


    // view
    let content: JSX.Element[] = []

    // case zero: no data is available
    if(!(document && otherDocument)) {
        content.push(<p key={prefix + "rouge-error"}>No data is available for this document. Please summarize the document to generate data automatically.</p>)

    // case one: visualize rouge score
    } else {
        content.push(
            <RougeVisualizer key={prefix + "rouge-scores"} rouge={document.rouge} />
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

export default RougeViewer;
