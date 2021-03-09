import React, {useContext, useLayoutEffect, useState} from "react";
import {MyDocument} from "../../types/document";
import {colormap} from "../../helper/colorscales";
import {FaithfulnesSettingsContext} from "../editor/DocumentEditor";
import parse from "html-react-parser";

type FactCCViewerProps = {
    visualizeSummary: boolean,
    inputDocument: MyDocument | null | undefined,
    summaryDocument: MyDocument | null | undefined,
    sentenceID: number,
    setSentenceID: React.Dispatch<React.SetStateAction<number>>,
    faithfulnessMode: boolean,
}


function FactCCViewer({visualizeSummary, inputDocument, summaryDocument, sentenceID, setSentenceID, faithfulnessMode}: FactCCViewerProps) {
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
    }, [inputDocument, summaryDocument])

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
    }

    // view
    let content: JSX.Element[] = []

    // case zero: no data is available
    if(!(document && otherDocument)) {
        content.push(<p key={prefix + "factcc-error"}>No data is available for this document. Please summarize the document to generate data automatically.</p>)

    // case one: visualize alignments
    } else {

        // visualize sentences
        if(visualizeSummary === faithfulnessMode) {

            document.factcc_claims.forEach((claim, index) => {
                let html = claim.text
                // only apply background color if NO sentence is selected
                let backgroundColor = sentenceID === -1 && claim.score_faithful <= settings.FactCCThreshold / 100.0 ? colormap(claim.score_faithful) : "";
                let borderColor = sentenceID >= 0 ? colormap(claim.score_faithful) : "";
                // only highlight if the sentence is selected
                let highlightFaithfulnessScore = null;

                // visualize span only for selected sentence
                if(sentenceID === index) {
                    let start = claim.claim_start
                    let end = claim.claim_end
                    highlightFaithfulnessScore = claim.score_faithful.toFixed(2)
                    html = "" +
                        html.substr(0, start) +
                        `<span style="backgroundColor: ${colormap(claim.score_faithful)}">` +
                        html.substr(start, end - start) +
                        `</span>` +
                        html.substr(end, html.length - end)
                }

                content.push(
                    <p key={prefix + 'claim-' + index} id={prefix + 'claim-' + index}
                       className={className}
                       onClick={() => handleClick(index)}
                       data-factcc={highlightFaithfulnessScore}
                       data-factcc-color={borderColor}
                       style={{
                           margin: "0.25em 0",
                           backgroundColor: backgroundColor,
                           borderColor: borderColor
                       }}
                    >
                        {parse(html)}
                    </p>
                )
            })

        // visualize document
        } else {
            let html = otherDocument.factcc_source

            // visualize span
            if(sentenceID >= 0 && sentenceID < otherDocument.factcc_claims.length) {
                let start = otherDocument.factcc_claims[sentenceID].source_start
                let end = otherDocument.factcc_claims[sentenceID].source_end
                html = "" +
                    html.substr(0, start) +
                    `<span style="backgroundColor: ${colormap(otherDocument.factcc_claims[sentenceID].score_faithful)}">` +
                    html.substr(start, end - start) +
                    `</span>` +
                    html.substr(end, html.length - end)
            }

            const regex = /(\.)(\s+)(\S+)/gm;
            const subst = `$1<br><br>$3`;
            html = html.replace(regex, subst)

            content.push(<p key={"factcc-document"}>{parse(html)}</p>)
        }


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
