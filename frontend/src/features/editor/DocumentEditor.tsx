import React, {SetStateAction, useEffect, useLayoutEffect, useState} from "react";
import axios, {AxiosResponse} from "axios";
import {NewSummarizationResult} from "../../types/results";
import {FontAwesomeIcon} from "@fortawesome/react-fontawesome";
import {faPlay} from "@fortawesome/free-solid-svg-icons";
import ProvenanceViewer from "../provenance/ProvenanceViewer";
import TripleViewer from "../provenance/TripleViewer";
import EditorWrapper from "../basic_editor/EditorWrapper";
import EditorPane from "../basic_editor/EditorPane";
import EditorContent from "../basic_editor/EditorContent";
// @ts-ignore
import Split from 'react-split';
import AceEditor from "react-ace";
import {MyDocument} from "../../types/document";
import {Ace} from "ace-builds";
import BertScoreVisualizer from "../provenance/BertScoreVisualizer";
import EntailmentVisualizer from "../provenance/EntailmentVisualizer";
import QAVisualizer from "../provenance/QAVisualizer";
import {FaithfulnessSettings} from "../settings/FaithfulnessSettingsVisualizer";
import {EntailmentMethod} from "../../types/entailmentmethod";
import {QASimilarityMethod} from "../../types/qasimilaritymethod";
import FactCCViewer from "../provenance/FactCCViewer";
import useElementSizes from "../../helper/ElementSizes";
import Spinner from "react-bootstrap/Spinner";
import RougeViewer from "../provenance/RougeViewer";

type FaithfulnesSettingsContextType = {
    settings: FaithfulnessSettings,
    setSettings: React.Dispatch<SetStateAction<FaithfulnessSettings>>
}

export const FaithfulnesSettingsContext = React.createContext<FaithfulnesSettingsContextType>(
    {
        settings: {
            BERTScoreThreshold: 95,
            EntailmentMethod: EntailmentMethod.TopSentencesSentence,
            EntailmentThreshold: 97,
            QAThreshold: 90,
            QASimilarityMethod: QASimilarityMethod.F1,
            FactCCThreshold: 95,
        },
        setSettings: () => {}
    }
);

function DocumentEditor() {
    // context
    const [settings, setSettings] = useState({
        BERTScoreThreshold: 95,
        EntailmentMethod: EntailmentMethod.TopSentencesSentence,
        EntailmentThreshold: 97,
        QAThreshold: 90,
        QASimilarityMethod: QASimilarityMethod.F1,
        FactCCThreshold: 95,
    });
    const settingsContextValue = { settings: settings, setSettings: setSettings };

    // local state
    const [height, mainNav, fileNav, inputNav, inputFooterNav, outputNav, outputFooterNav] = useElementSizes();
    const [showNER, setShowNER] = useState(false);
    const [showTriples, setShowTriples] = useState<boolean>(false);
    const [showFaithfulness, setShowFaithfulness] = useState(false);
    const [isLoading, setIsLoading] = useState<boolean>(false)
    const [sentenceID, setSentenceID] = useState(-1);
    const [isSummarySentence, setIsSummarySentence] = useState(true);
    const [tripleID, setTripleID] = useState(-1);
    const [isSummaryTriple, setIsSummaryTriple] = useState(true);
    const [sizes, setSizes] = useState([50, 50])
    const [factccId, setFactccId] = useState(-1);
    const [wordID, setWordId] = useState(-1);
    const [isSummaryWord, setIsSummaryWord] = useState(true);
    const [questionID, setQuestionID] = useState(-1);
    const [isSummaryQuestion, setIsSummaryQuestion] = useState(true);
    const [faithfulnessMode, setFaithfulnessMode] = useState(true)
    const [inputContent, setInputContent] = useState("The tower is 324 metres (1,063 ft) tall, about the same height as an 81-storey building, and the tallest structure in Paris.\n" +
        "Its base is square, measuring 125 metres (410 ft) on each side.\n" +
        "During its construction, the Eiffel Tower surpassed the Washington Monument to become the tallest man-made structure in the world, a title it held for 41 years until the Chrysler Building in New York City was finished in 1930.\n" +
        "It was the first structure to reach a height of 300 metres.\n" +
        "Due to the addition of a broadcasting aerial at the top of the tower in 1957, it is now taller than the Chrysler Building by 5.2 metres (17 ft).\n" +
        "Excluding transmitters, the Eiffel Tower is the second tallest free-standing structure in France after the Millau Viaduct.")
    const [summaryContent, setSummaryContent] = useState("The tower is 324 metres (1,063 ft) tall, about the same height as an 81-storey building.\n" +
        "It was the first structure to reach a height of 300 metres.\n" +
        "It is now taller than the Chrysler Building in New York City by 5.2 metres (17 ft).\n" +
        "Excluding transmitters, the Eiffel Tower is the second tallest free-standing structure in France.")
    const [inputDocument, setInputDocument] = useState<MyDocument | undefined>(undefined)
    const [summaryDocument, setSummaryDocument] = useState<MyDocument | undefined>(undefined)
    const [inputEditorInstance, setInputEditorInstance] = useState<Ace.Editor | undefined>(undefined)
    const [documentEditorInstance, setDocumentEditorInstance] = useState<Ace.Editor | undefined>(undefined)

    // effects
    // reset selected sentence / word / phrase / question / triple, whenever the faithfulness mode changes
    useLayoutEffect(() => {
        // setSentenceID(-1)
        // setWordId(-1)
        setQuestionID(-1)
        setTripleID(-1)
        setFactccId(-1)
    }, [faithfulnessMode])

    // actions
    const handleInputChange = (newValue: string) => {
        setInputContent(newValue);
    }
    const handleSummaryChange = (newValue: string) => {
        setSummaryContent(newValue);
    }
    const handleNerChange = () => {
        setShowNER(!showNER)
        if(!showNER) {
            setShowTriples(false);
            setShowFaithfulness(false);
        }
    }
    const handleTriplesChange = () => {
        setShowTriples(!showTriples);
        if(!showTriples) {
            setShowNER(false);
            setShowFaithfulness(false);
        }
    }
    const handleFaithfulnessChange = () => {
        setShowFaithfulness(!showFaithfulness);
        if(!showFaithfulness) {
            setShowNER(false);
            setShowTriples(false);
        }
    }

    const mode2text = (mode: number) => {
        switch (mode) {
            case 0:
                return "Edit"
            case 1:
                return "BERTScore"
            case 2:
                return "Entailment"
            case 3:
                return "QA"
            case 4:
                return "FactCC"
            case 5:
                return "ROUGE"
            default:
                return "Unkown"
        }
    }

    const mode2info = (mode: number) => {
        switch (mode) {
            case 0:
                return "Edit the source & summary document."
            case 1:
                return "Evaluate documents by comparing the most similar words.\n For every word of one document, this method finds the most similar word of the other document. Words with a similarity less than the defined threshold are highlighted."
            case 2:
                return "Evaluate documents by checking whether the statements of a sentence can be derived from the other document. Sentences with an entailment probability less than the defined threshold are highlighted."
            case 3:
                return "Evaluate documents by comparing answers to automatically generated questions. This method generates questions based on one document, and answers them using both documents independently. Answers with a similarity less than the defined threshold are highlighted."
            case 4:
                return "Evaluate documents with the FactCC model. This method utilizes BERT to classify whether a sentence is faithful or not."
            case 5:
                return "View the ROUGE (1, 2, L) Scores."
            default:
                return "Unkown"
        }
    }

    const pills2text = (pill: number) => {
        switch (pill) {
            case 0:
                return "Text"
            case 1:
                return "Graph"
            default:
                return "Unkown"
        }
    }

    const isButtonDisabled = () => {
        return isLoading;
    }

    const handleButtonClick = async () => {
        // set a loading indicator
        setIsLoading(true);

        // validate that the data we want to post exists
        if (inputContent.length === 0 || inputContent === "" || summaryContent.length === 0 || summaryContent === "") {
            alert("Error: The post data (inputContent & summaryContent) is empty!")
            setIsLoading(false)
            return
        }

        try {
            // do the post request
            let result = await axios.post<any, AxiosResponse<NewSummarizationResult>>("http://localhost:3333/align", {
                data: {input: inputContent, summary: summaryContent, method: settings.EntailmentMethod},
            })

            // check if result contains the data we need
            if(result?.data?.input_document && result?.data?.summary_document) {

                console.log(result)
                setInputDocument(result.data.input_document)
                setSummaryDocument(result.data.summary_document)

                // throw an error if the result does not contain the data we expect
            } else {
                throw new Error("Error while parsing the result from http://localhost:3333/align.");
            }

            // display errors that occur during the process as alerts
        } catch (error) {
            if(error?.response?.status && error?.response?.message) {
                alert(error.response.status + ": " + error.response.data.message)
            } else {
                alert(error)
            }

            // finally set the loading indicator
        } finally {
            setIsLoading(false);
        }
    }

    const onDragEnd = (sizes: number[]) => {
        setSizes(sizes)
    }

    useEffect(() => {
        if(inputEditorInstance) {
            inputEditorInstance.resize()
        }
        if(documentEditorInstance) {
            documentEditorInstance.resize()
        }
    }, [inputEditorInstance, documentEditorInstance, sizes])


    return (
        <FaithfulnesSettingsContext.Provider value={settingsContextValue}>
            <EditorWrapper numModes={6}
                           mode2text={mode2text}
                           mode2info={mode2info}
                           numPills={0}
                           pill2text={pills2text}
                           toolbarLabels={["NER", "Triples", "Faithfulness"]}
                           toolbarOnChangeFunctions={[handleNerChange, handleTriplesChange, handleFaithfulnessChange]}
                           toolbarChecked={[showNER, showTriples, showFaithfulness]}
                           isButtonDisabled={isButtonDisabled}
                           handleButtonClick={handleButtonClick}
                           buttonContent={<><FontAwesomeIcon icon={faPlay} />&nbsp;Evaluate</>}
                           height={(height - mainNav - inputNav - inputFooterNav)+ "px"}
                           faithfulnessMode={faithfulnessMode}
                           setFaithfulnessMode={setFaithfulnessMode}
            >
                <EditorPane pill={0}>

                    {isLoading && (
                        <div style={{
                            inset: 0,
                            position: "absolute",
                            backgroundColor: "white",
                            zIndex: 500,
                        }}>
                            <Spinner animation="border" variant="primary" role="status" style={{
                                width: "10rem",
                                height: "10rem",
                                margin: "auto",
                                inset: 0,
                                position: "absolute"
                            }}>
                                <span className="sr-only">Loading...</span>
                            </Spinner>
                        </div>
                    )}

                    <EditorContent mode={0}>
                        <Split className="wrap w-100 h-100" sizes={sizes} collapsed={0} minSize={0} onDragEnd={onDragEnd}>

                            <div className="comp">
                                <AceEditor
                                    readOnly={isLoading}
                                    mode="text"
                                    theme="github"
                                    fontSize="20px"
                                    onChange={handleInputChange}
                                    name="input_editor"
                                    width="100%"
                                    height="100%"
                                    value={inputContent}
                                    wrapEnabled={true}
                                    showPrintMargin={false}
                                    setOptions={{indentedSoftWrap: false}}
                                    onLoad={editorInstance => {
                                        setInputEditorInstance(editorInstance)
                                    }}
                                />
                            </div>
                            <div className="comp">
                                <AceEditor
                                    readOnly={isLoading}
                                    mode="text"
                                    theme="github"
                                    fontSize="20px"
                                    onChange={handleSummaryChange}
                                    name="summary_editor"
                                    width="100%"
                                    height="100%"
                                    value={summaryContent}
                                    wrapEnabled={true}
                                    showPrintMargin={false}
                                    setOptions={{indentedSoftWrap: false}}
                                    onLoad={editorInstance => {
                                        setDocumentEditorInstance(editorInstance)
                                    }}
                                />
                            </div>
                        </Split>
                    </EditorContent>

                    <EditorContent mode={-1}>
                        <Split className="wrap w-100 h-100" sizes={sizes} collapsed={0} minSize={0} onDragEnd={onDragEnd}>

                            <div className="comp">
                                <ProvenanceViewer visualizeSummary={false}
                                                  inputDocument={inputDocument}
                                                  summaryDocument={summaryDocument}
                                                  sentenceID={sentenceID}
                                                  setSentenceID={setSentenceID}
                                                  isSummarySentence={isSummarySentence}
                                                  setIsSummarySentence={setIsSummarySentence}
                                                  showNER={showNER}
                                                  showTriples={showTriples}
                                                  showFaithfulness={false}
                                />
                            </div>
                            <div className="comp">
                                <ProvenanceViewer visualizeSummary={true}
                                                  inputDocument={inputDocument}
                                                  summaryDocument={summaryDocument}
                                                  sentenceID={sentenceID}
                                                  setSentenceID={setSentenceID}
                                                  isSummarySentence={isSummarySentence}
                                                  setIsSummarySentence={setIsSummarySentence}
                                                  showNER={showNER}
                                                  showTriples={showTriples}
                                                  showFaithfulness={showFaithfulness}
                                />
                            </div>
                        </Split>
                    </EditorContent>

                    <EditorContent mode={-1}>
                        <Split className="wrap w-100 h-100" sizes={sizes} collapsed={0} minSize={0} onDragEnd={onDragEnd}>
                            <div className="comp">
                                <TripleViewer
                                    summaryDocument={summaryDocument}
                                    inputDocument={inputDocument}
                                    visualizeSummary={false}
                                    isSummaryTriple={isSummaryTriple}
                                    setIsSummaryTriple={setIsSummaryTriple}
                                    tripleID={tripleID}
                                    setTripleID={setTripleID}
                                />
                            </div>
                            <div className="comp">
                                <TripleViewer
                                    summaryDocument={summaryDocument}
                                    inputDocument={inputDocument}
                                    visualizeSummary={true}
                                    isSummaryTriple={isSummaryTriple}
                                    setIsSummaryTriple={setIsSummaryTriple}
                                    tripleID={tripleID}
                                    setTripleID={setTripleID}
                                />
                            </div>
                        </Split>
                    </EditorContent>

                    <EditorContent mode={1}>
                        <Split className="wrap w-100 h-100" sizes={sizes} collapsed={0} minSize={0} onDragEnd={onDragEnd}>

                            <div className="comp">
                                <BertScoreVisualizer sourceDocument={inputDocument}
                                                     summaryDocument={summaryDocument}
                                                     visualizeSummary={false}
                                                     isSummaryWord={isSummaryWord}
                                                     setIsSummaryWord={setIsSummaryWord}
                                                     wordId={wordID}
                                                     setWordId={setWordId}
                                                     faithfulnessMode={faithfulnessMode}
                                />
                            </div>
                            <div className="comp">
                                <BertScoreVisualizer sourceDocument={inputDocument}
                                                     summaryDocument={summaryDocument}
                                                     visualizeSummary={true}
                                                     isSummaryWord={isSummaryWord}
                                                     setIsSummaryWord={setIsSummaryWord}
                                                     wordId={wordID}
                                                     setWordId={setWordId}
                                                     faithfulnessMode={faithfulnessMode}
                                />
                            </div>
                        </Split>
                    </EditorContent>

                    <EditorContent mode={2}>
                        <Split className="wrap w-100 h-100" sizes={sizes} collapsed={0} minSize={0} onDragEnd={onDragEnd}>

                            <div className="comp">
                                <EntailmentVisualizer visualizeSummary={false}
                                                      inputDocument={inputDocument}
                                                      summaryDocument={summaryDocument}
                                                      sentenceID={sentenceID}
                                                      setSentenceID={setSentenceID}
                                                      isSummarySentence={isSummarySentence}
                                                      setIsSummarySentence={setIsSummarySentence}
                                                      faithfulnessMode={faithfulnessMode}
                                />
                            </div>
                            <div className="comp">
                                <EntailmentVisualizer visualizeSummary={true}
                                                      inputDocument={inputDocument}
                                                      summaryDocument={summaryDocument}
                                                      sentenceID={sentenceID}
                                                      setSentenceID={setSentenceID}
                                                      isSummarySentence={isSummarySentence}
                                                      setIsSummarySentence={setIsSummarySentence}
                                                      faithfulnessMode={faithfulnessMode}
                                />
                            </div>
                        </Split>
                    </EditorContent>

                    <EditorContent mode={3}>
                        <Split className="wrap w-100 h-100" sizes={sizes} collapsed={0} minSize={0} onDragEnd={onDragEnd}>

                            <div className="comp">
                                <QAVisualizer visualizeSummary={false}
                                              sourceDocument={inputDocument}
                                              summaryDocument={summaryDocument}
                                              questionId={questionID}
                                              setQuestionId={setQuestionID}
                                              isSummaryQuestion={isSummaryQuestion}
                                              setIsSummaryQuestion={setIsSummaryQuestion}
                                              faithfulnessMode={faithfulnessMode}
                                />
                            </div>
                            <div className="comp">
                                <QAVisualizer visualizeSummary={true}
                                              sourceDocument={inputDocument}
                                              summaryDocument={summaryDocument}
                                              questionId={questionID}
                                              setQuestionId={setQuestionID}
                                              isSummaryQuestion={isSummaryQuestion}
                                              setIsSummaryQuestion={setIsSummaryQuestion}
                                              faithfulnessMode={faithfulnessMode}
                                />
                            </div>
                        </Split>
                    </EditorContent>

                    <EditorContent mode={4}>
                        <Split className="wrap w-100 h-100" sizes={sizes} collapsed={0} minSize={0} onDragEnd={onDragEnd}>

                            <div className="comp">
                                <FactCCViewer visualizeSummary={false}
                                              inputDocument={inputDocument}
                                              summaryDocument={summaryDocument}
                                              sentenceID={factccId}
                                              setSentenceID={setFactccId}
                                              faithfulnessMode={faithfulnessMode}
                                />
                            </div>
                            <div className="comp">
                                <FactCCViewer visualizeSummary={true}
                                              inputDocument={inputDocument}
                                              summaryDocument={summaryDocument}
                                              sentenceID={factccId}
                                              setSentenceID={setFactccId}
                                              faithfulnessMode={faithfulnessMode}
                                />
                            </div>
                        </Split>
                    </EditorContent>

                    <EditorContent mode={5}>
                        <Split className="wrap w-100 h-100" sizes={sizes} collapsed={0} minSize={0} onDragEnd={onDragEnd}>

                            <div className="comp">
                                <RougeViewer visualizeSummary={false}
                                             inputDocument={inputDocument}
                                             summaryDocument={summaryDocument}
                                             faithfulnessMode={faithfulnessMode}
                                />
                            </div>
                            <div className="comp">
                                <RougeViewer visualizeSummary={true}
                                             inputDocument={inputDocument}
                                             summaryDocument={summaryDocument}
                                             faithfulnessMode={faithfulnessMode}
                                />
                            </div>
                        </Split>
                    </EditorContent>

                </EditorPane>

                {/*<EditorPane pill={1}>*/}
                {/*    <EditorContent mode={0}>*/}
                {/*        <Split className="wrap w-100 h-100" sizes={sizes} collapsed={0} minSize={0} onDragEnd={onDragEnd}>*/}
                {/*            <div className="comp">*/}
                {/*                <p>Graph Provenance</p>*/}
                {/*            </div>*/}
                {/*            <div className="comp">*/}
                {/*                <p>Graph Provenance</p>*/}
                {/*            </div>*/}
                {/*        </Split>*/}
                {/*    </EditorContent>*/}

                {/*    <EditorContent mode={1}>*/}
                {/*        <Split className="wrap w-100 h-100" sizes={sizes} collapsed={0} minSize={0} onDragEnd={onDragEnd}>*/}
                {/*            <div className="comp">*/}
                {/*                <p>Graph Triples</p>*/}
                {/*            </div>*/}
                {/*            <div className="comp">*/}
                {/*                <p>Graph Triples</p>*/}
                {/*            </div>*/}
                {/*        </Split>*/}
                {/*    </EditorContent>*/}
                {/*</EditorPane>*/}

            </EditorWrapper>
        </FaithfulnesSettingsContext.Provider>
    )
}

export default DocumentEditor;