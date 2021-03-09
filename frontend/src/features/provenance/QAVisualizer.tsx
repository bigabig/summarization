import React, {useContext, useLayoutEffect, useState} from "react";
import {MyDocument} from "../../types/document";
import parse from 'html-react-parser';
import {OverlayTrigger} from "react-bootstrap";
import Tooltip from "react-bootstrap/Tooltip";
import {colormap, highlightColorMap} from "../../helper/colorscales";
import {FaithfulnesSettingsContext} from "../editor/DocumentEditor";
import {QA} from "../../types/qa";
import {QASimilarityMethod} from "../../types/qasimilaritymethod";


type QAVisualizerProps = {
    visualizeSummary: boolean
    sourceDocument: MyDocument | null | undefined
    summaryDocument: MyDocument | null | undefined
    questionId: number,
    setQuestionId: React.Dispatch<React.SetStateAction<number>>,
    isSummaryQuestion: boolean,
    setIsSummaryQuestion: React.Dispatch<React.SetStateAction<boolean>>,
    faithfulnessMode: boolean,
}


function QAVisualizer({visualizeSummary, sourceDocument, summaryDocument, questionId, setQuestionId, faithfulnessMode}: QAVisualizerProps) {
    const document = visualizeSummary ? summaryDocument : sourceDocument;
    const prefix = visualizeSummary ? "summary-" : "source-"
    const docWithQuestions = faithfulnessMode ? summaryDocument : sourceDocument;

    // context
    const {settings} = useContext(FaithfulnesSettingsContext)

    // local state
    const [isHidden, setIsHidden] = useState(true);

    // reset local state whenever the file changes
    useLayoutEffect(() => {
        setIsHidden(true);
    }, [sourceDocument, summaryDocument])

    // actions
    const handleClick = (id: number) => {
        if (id === questionId) {
            if(isHidden) {
                setIsHidden(false);
                setQuestionId(id);
            } else {
                setIsHidden(true);
                setQuestionId(-1);
            }
        } else {
            setIsHidden(false);
            setQuestionId(id);
        }
    }

    // view
    const getSimilarity = (qa: QA) => {
        switch (settings.QASimilarityMethod) {
            case QASimilarityMethod.F1:
                return qa.similarity
            case QASimilarityMethod.BERT:
                return qa.similarity_bert
            default:
                return qa.similarity
        }
    }

    const calcQuestionBackgroundColor = (qa: QA) => {
        // we selected the question
        if(questionId === qa.id) {
            return highlightColorMap(getSimilarity(qa))

        // in every other case
        } else {
            return ""
        }
    }

    const calcAnswerBackgroundColor = (qa: QA) => {
        // we selected the question
        if(questionId === qa.id) {
            return highlightColorMap(getSimilarity(qa))

        // we have no question selected and the similarity is below threshold
        } else if(questionId < 0 && getSimilarity(qa) < settings.QAThreshold / 100.0)  {
            return colormap(getSimilarity(qa))

            // in every other case
        } else {
            return ""
        }
    }


    let content: JSX.Element[] = []
    let questions: JSX.Element[] = []

    // case zero: no data is available
    if(!(sourceDocument && summaryDocument && docWithQuestions && document)) {
        content.push(<p key={prefix + "qaerrormsg"}>No data is available for this document. Please summarize the document to generate data automatically.</p>)

    // case one: visualize alignments
    } else {

        // draw questions
        docWithQuestions.qa.forEach(qa => {
            let answer = visualizeSummary === faithfulnessMode ? qa.this_answer : qa.other_answer
            questions.push(
                <li key={prefix + "question-" + qa.id}
                    onClick={() => handleClick(qa.id)}
                    style={{backgroundColor: calcQuestionBackgroundColor(qa), lineHeight: "35px"}}
                >
                    {qa.question}&nbsp;
                    {(qa.id === questionId || (getSimilarity(qa) < settings.QAThreshold / 100.0 && questionId < 0)) && (
                        <mark data-similarity={getSimilarity(qa).toFixed(2)} style={{backgroundColor: calcAnswerBackgroundColor(qa)}}>{answer}</mark>
                    )}
                    {!(qa.id === questionId || (getSimilarity(qa) < settings.QAThreshold / 100.0 && questionId < 0)) && (
                        <>{answer}</>
                    )}
                </li>
            )
        })

        let html = ""

        // draw sentences with highlights
        if(questionId >= 0 && questionId < docWithQuestions.qa.length) {
            let output: string[] = []

            let important_sentences = visualizeSummary === faithfulnessMode ? docWithQuestions.qa[questionId].this_answer_sentences : docWithQuestions.qa[questionId].other_answer_sentences
            let answer = visualizeSummary === faithfulnessMode ? docWithQuestions.qa[questionId].this_answer : docWithQuestions.qa[questionId].other_answer
            let question = docWithQuestions.qa[questionId]
            document.sentences.forEach(sentence => {
                if (questionId >= 0 && important_sentences.indexOf(sentence.id) !== -1) {
                    output.push(
                        sentence.text.replaceAll(answer, `<mark data-text="${answer}" data-id=${question.id} data-similarity=${getSimilarity(question).toFixed(2)} data-question="${question.question}">${answer}</mark>`)
                    )
                } else {
                    output.push(sentence.text)
                }
            })

            html = "<p>"
            html += output.join("</p><p>")
            html += "</p>"

            content.push(
                <React.Fragment key={prefix + "highlightedsentences"}>
                    {parse(html, {
                        replace: domNode => {
                            if (domNode.name === 'mark') {
                                return (
                                    <OverlayTrigger
                                        placement={"top"}
                                        overlay={
                                            <Tooltip id={`tooltip-top`}>
                                                {domNode.attribs["data-question"]}
                                            </Tooltip>
                                        }
                                    >
                                <span
                                    {...domNode.attribs}
                                    className={domNode.attribs["data-match"] ? 'matching-question' : 'non-matching-question'}
                                    style={{
                                        backgroundColor: parseInt(domNode.attribs["data-id"]) === questionId ? highlightColorMap(parseFloat(domNode.attribs["data-similarity"])): colormap(parseFloat(domNode.attribs["data-similarity"])),
                                        whiteSpace: "nowrap"
                                    }}
                                >
                                    {domNode.attribs["data-text"]}
                                </span>
                                    </OverlayTrigger>
                                );
                            }
                        }
                    })}
                </React.Fragment>
            )

        // draw sentences without highlights
        } else {
            document.sentences.forEach(sentence => {
                content.push(<p key={prefix + "simplesentence-" + sentence.id}>{sentence.text}</p>)
            })
        }

        // draw score
        if(faithfulnessMode === visualizeSummary) {
            content.push(
                <p key={prefix + "qa-scores"}>
                    QA Score: {document.qa_score.toFixed(2)}
                </p>
            )
        }
    }

    return (
        <div className="textContainer text-left">
            <div className="qaContainer">
                <h3>Questions:</h3>
                <ul>
                    {questions}
                </ul>

                {content}
            </div>
        </div>
    )
}

export default QAVisualizer;
