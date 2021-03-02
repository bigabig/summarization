import React, {useContext, useLayoutEffect, useState} from "react";
import {MyDocument} from "../../types/document";
import {Sentence} from "../../types/sentence";
import {colormap, heatmap} from "../../helper/colorscales";
import {FaithfulnesSettingsContext} from "../editor/DocumentEditor";

type BertScoreSentenceProps = {
    sentence: Sentence,
    className: string,
    handleClick: (wordId: number) => void,
    wordId: number,
    bertscores: any[][] | undefined,
    selfBertscores: any[][] | undefined,
    otherBertscores: any[][] | undefined,
    isSummaryWord: boolean,
    visualizeSummary: boolean,
    prefix: string,
    precisionMode: boolean,
    threshold: number
}

function BertScoreSentence({sentence, className, handleClick, selfBertscores, otherBertscores, bertscores, wordId, isSummaryWord, visualizeSummary, prefix, precisionMode, threshold}: BertScoreSentenceProps) {

    const calcBackgroundColor = (index: number) => {
        let color = ""

        if (precisionMode === visualizeSummary && selfBertscores && selfBertscores[index] && selfBertscores[index][4] < threshold) {
            color = colormap(0)
        }

        if(bertscores && wordId >= 0) {
            // hovered word
            if(isSummaryWord === visualizeSummary && wordId === index) {
                return colormap(bertscores[index][4])

            // corresponding word
            } else if (isSummaryWord !== visualizeSummary && index === bertscores[wordId][3]) {
                return colormap(bertscores[wordId][4])
            }

        }

        return color;
    }

    const calcHighlight = (index: number) => {
        if(bertscores && wordId >= 0) {
            // hovered word
            if(isSummaryWord === visualizeSummary && wordId === index) {
                return bertscores[index][4].toFixed(2)

            // corresponding word
            } else if (isSummaryWord !== visualizeSummary && index === bertscores[wordId][3]) {
                return bertscores[wordId][4].toFixed(2)
            }

        }
        return null;
    }

    let content: JSX.Element[] = []
    sentence.words.forEach((word) => {
        content.push(
            <React.Fragment key={prefix + "word-" + word.id}>
                <span
                    onClick={() => handleClick(word.id)}
                      style={{
                          padding: "0.25rem",
                          backgroundColor: calcBackgroundColor(word.id),
                          display: "inline-block",
                      }}
                      data-similarity={calcHighlight(word.id)}
                >
                    {word.text}
                </span>
            </React.Fragment>
        )
    })

    return (
        <p className={className}>
            {content}
        </p>
    )
}

type BertScoreVisualizerProps = {
    sourceDocument: MyDocument | null | undefined
    summaryDocument: MyDocument | null | undefined
    visualizeSummary: boolean
    wordId: number,
    setWordId: React.Dispatch<React.SetStateAction<number>>,
    isSummaryWord: boolean
    setIsSummaryWord: React.Dispatch<React.SetStateAction<boolean>>,
}

function BertScoreVisualizer({sourceDocument, summaryDocument, visualizeSummary, wordId, setWordId, isSummaryWord, setIsSummaryWord}: BertScoreVisualizerProps) {
    const document = visualizeSummary ? summaryDocument : sourceDocument;
    const prefix = visualizeSummary ? 'bertscore-summary-' : 'bertscore-document-';
    const className = visualizeSummary ? 'summary-sentence' : 'document-sentence';
    const selfBertscores = visualizeSummary ? summaryDocument?.bertscores : sourceDocument?.bertscores;
    const otherBertscores = visualizeSummary ? sourceDocument?.bertscores : summaryDocument?.bertscores;
    const bertscores = isSummaryWord ? summaryDocument?.bertscores : sourceDocument?.bertscores;
    const precisionMode = true;
    const threshold = 0.96;

    // context
    const { settings } = useContext(FaithfulnesSettingsContext)

    // local state
    const [isHidden, setIsHidden] = useState(true);

    // reset local state whenever the file changes
    useLayoutEffect(() => {
        setIsHidden(true);
    }, [sourceDocument, summaryDocument])

    // actions
    const handleClick = (id: number) => {
        if (id === wordId) {
            if(isHidden) {
                setIsHidden(false);
                setWordId(id);
            } else {
                setIsHidden(true);
                setWordId(-1);
            }
        } else {
            setIsHidden(false);
            setWordId(id);
        }
        setIsSummaryWord(visualizeSummary);
    }

    let content: JSX.Element[] = []

    // case zero: no data is available
    if(!(document)) {
        content.push(<p key={prefix + 'error'}>No data is available for this document. Please summarize the document to generate data automatically.</p>)
    } else {
        document.sentences.forEach((sentence, index) => {
            content.push(
                <BertScoreSentence sentence={sentence}
                                   key={prefix + 'sentence-' + sentence.id}
                                   prefix={prefix}
                                   handleClick={handleClick}
                                   className={className}
                                   wordId={wordId}
                                   bertscores={bertscores}
                                   selfBertscores={selfBertscores}
                                   otherBertscores={otherBertscores}
                                   visualizeSummary={visualizeSummary}
                                   isSummaryWord={isSummaryWord}
                                   precisionMode={precisionMode}
                                   threshold={settings.BERTScoreThreshold / 100.0}
                />
            )
        })
        if(visualizeSummary) {
            content.push(
                <p key={"bertscores"}>
                    P-BERT: {document.pbert.toFixed(4)}<br/>
                    R-BERT: {document.rbert.toFixed(4)}<br/>
                    F-BERT: {document.fbert.toFixed(4)}
                </p>
            )
        }
    }

    return (
        <div className="textContainer text-left">
            <div className="annotationContainer">
                {content}
            </div>
        </div>
    )
}

export default BertScoreVisualizer;