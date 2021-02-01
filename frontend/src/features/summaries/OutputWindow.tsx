import Navbar from "react-bootstrap/Navbar";
import Dropdown from "react-bootstrap/Dropdown";
import Button from "react-bootstrap/Button";
import {FontAwesomeIcon} from "@fortawesome/react-fontawesome";
import {faPlay} from "@fortawesome/free-solid-svg-icons";
import React, {CSSProperties, useState} from "react";
import ButtonGroup from "react-bootstrap/ButtonGroup";
import Form from "react-bootstrap/Form";
import AceEditor from "react-ace";
import "ace-builds/src-noconflict/mode-jsx";
import "ace-builds/src-noconflict/mode-java";
import "ace-builds/src-noconflict/theme-github";
import "ace-builds/src-min-noconflict/ext-searchbox";
import "ace-builds/src-min-noconflict/ext-language_tools";
import {useGetFileById, useUpdateSummaryById} from "../../graphql/files";
import Spinner from "react-bootstrap/esm/Spinner";
import "./styles/OutputWindow.css";
import {Mode} from "../editor/Editor";
import SummaryProvenanceViewer from "../provenance/SummaryProvenanceViewer";
import axios, {AxiosResponse} from "axios";
import {useRouteMatch} from "react-router-dom";
import {ProjectAndFileMatch} from "../../graphql/types/ProjectMatch";
import {NewSummarizationResult} from "../../graphql/types/results";

type OutputWindowProps = {
    height: number,
    mode: Mode
    sentenceID: number,
    setSentenceID: React.Dispatch<React.SetStateAction<number>>,
}


function OutputWindow({height, mode, sentenceID, setSentenceID}: OutputWindowProps) {
    let match = useRouteMatch<ProjectAndFileMatch>();
    const fileId: number = Number(match.params.fileId);
    const projectId: number = Number(match.params.projectId);

    // remote state
    const {data: fileData, loading: fileLoading, error: fileError } = useGetFileById(fileId, projectId);
    const {mutate: updateSummary} = useUpdateSummaryById();

    // local state
    const [isSummaryLoading, setIsSummaryLoading] = useState(false);
    const [showNER, setShowNER] = useState(false);
    const [showTriples, setShowTriples] = useState<boolean>(false);
    const [showFaithfulness, setShowFaithfulness] = useState(false);

    // actions
    const handleNerChange = () => {
        setShowNER(!showNER)
        if(!showNER) {
            setShowTriples(false);
        }
    }
    const handleTriplesChange = () => {
        setShowTriples(!showTriples);
        if(!showTriples) {
            setShowNER(false);
        }
    }
    const handleFaithfulnessChange = () => {
        setShowFaithfulness(!showFaithfulness);
    }

    const handleSummarize = async () => {
        // set a loading indicator
        setIsSummaryLoading(true);

        // validate that the data we want to post exists
        if (!fileData?.files_by_pk?.content) {
            alert("Error: The post data (file content) is undefined!")
            setIsSummaryLoading(false)
            return
        }

        try {
            // do the post request
            let result = await axios.post<any, AxiosResponse<NewSummarizationResult>>("http://localhost:3333/summarize", {
                text: fileData.files_by_pk.content,
                length: 140,
                method: "sshleifer/distilbart-cnn-12-6"
            })

            // check if result contains the data we need
            if(result?.data?.input_document && result?.data?.summary_document) {

                // perform some logic with the result data
                await updateSummary({
                    variables: {
                        id: fileId,
                        projectId: projectId,
                        document: result.data.input_document,
                        summaryDocument: result.data.summary_document
                    }
                });

            // throw an error if the result does not contain the data we expect
            } else {
                throw new Error("Error while parsing the result from http://localhost:3333/summarize.");
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
            setIsSummaryLoading(false);
        }
    }

    // view
    const ContentStyle: CSSProperties = {
        height: height,
        maxHeight: height,
        position: "relative",
    }
    return (
        <div>
            <Navbar id="output-navigation"  bg="light" expand="lg">
                <Dropdown as={ButtonGroup}>
                    <Button variant="success" disabled={fileLoading || isSummaryLoading} onClick={handleSummarize}><FontAwesomeIcon icon={faPlay} /> Summarize </Button>

                    <Dropdown.Toggle split variant="success" id="dropdown-split-basic" disabled={fileLoading || isSummaryLoading} />

                    <Dropdown.Menu>
                        <Dropdown.Item eventKey="1" active>Summarization Method 1</Dropdown.Item>
                        <Dropdown.Item eventKey="2">Summarization Method 2</Dropdown.Item>
                        <Dropdown.Divider />
                        <Dropdown.Item eventKey="3">Something else</Dropdown.Item>
                    </Dropdown.Menu>
                </Dropdown>
            </Navbar>
            <div style={ContentStyle}>
            {(isSummaryLoading || fileLoading) && (
                <Spinner animation="border" variant="primary" role="status" style={{
                    width: "10rem",
                    height: "10rem",
                    position: "absolute",
                    left: 0,
                    right: 0,
                    top: 0,
                    bottom: 0,
                    margin: "auto",
                }}>
                    <span className="sr-only">Loading...</span>
                </Spinner>
            )}
            {!(isSummaryLoading || fileLoading) && (
                <>
                {(mode === Mode.Edit || mode === Mode.Annotation) && (
                    <>
                        {fileError && (
                            <pre style={{width: "100%", height: "100%"}}>
                                {JSON.stringify(fileError, null, 2)}
                    </pre>
                        )}
                        {!fileError && !isSummaryLoading && fileData?.files_by_pk?.summary_document?.text && (
                            <AceEditor
                                readOnly={true}
                                mode="text"
                                theme="github"
                                fontSize="20px"
                                name="summary-editor"
                                width="100%"
                                height="100%"
                                value={fileData.files_by_pk.summary_document.sentences.map(s => s.text).join("\n")}
                                editorProps={{ $blockScrolling: true}}
                            />
                        )}
                        {!fileError && !isSummaryLoading && !fileData?.files_by_pk?.documents_up_to_date && (
                            <div className="uptodateContainer">
                                <div> ⚠️Summary is not up-to-date! ⚠️</div>
                            </div>
                        )}
                    </>
                )}
                {mode === Mode.Provenance && (
                    <SummaryProvenanceViewer
                                      summaryDocument={fileData?.files_by_pk?.summary_document}
                                      sentenceID={sentenceID}
                                      setSentenceID={setSentenceID}
                                      showNER={showNER}
                                      showTriples={showTriples}
                    />
                )}
                </>
            )}
            </div>
            <Navbar id="output-footer-navigation" expand="lg" variant="light" bg="secondary">
                <Navbar.Brand>
                    <Form inline>
                        <Form.Check
                            type="switch"
                            id="switch-summary-ner"
                            label="Named Entities"
                            className="mr-4"
                            checked={showNER}
                            onChange={handleNerChange}
                        />
                        <Form.Check
                            type="switch"
                            id="switch-summary-triples"
                            label="Triples"
                            className="mr-4"
                            onChange={handleTriplesChange}
                            checked={showTriples}
                        />
                        <Form.Check
                            type="switch"
                            id="switch-faithfulness"
                            label="Faithfulness"
                            checked={showFaithfulness}
                            onChange={handleFaithfulnessChange}
                        />
                    </Form>
                </Navbar.Brand>
            </Navbar>
        </div>
    );
}

export default OutputWindow;