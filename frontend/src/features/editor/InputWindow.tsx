import React, {CSSProperties, useState} from "react";

import {FontAwesomeIcon} from "@fortawesome/react-fontawesome";
import {faSync} from "@fortawesome/free-solid-svg-icons";

import Navbar from "react-bootstrap/Navbar";
import Button from "react-bootstrap/Button";
import Dropdown from 'react-bootstrap/Dropdown';
import DropdownButton from 'react-bootstrap/DropdownButton';
import Form from 'react-bootstrap/Form';


import AceEditor from "react-ace";
import "ace-builds/src-noconflict/mode-jsx";
import "ace-builds/src-noconflict/mode-java";
import "ace-builds/src-noconflict/theme-github";
import "ace-builds/src-min-noconflict/ext-searchbox";
import "ace-builds/src-min-noconflict/ext-language_tools";
import Nav from "react-bootstrap/Nav";
import Tab from "react-bootstrap/Tab";
import Graph from "../graph/Graph.js";
import {EditFileVariables, GetFileById} from "../../types/files-generated-types";
import {useEditFileById, useGetFileById} from "../../graphql/files";
import TokenAnnotator from "react-text-annotate/lib/TokenAnnotator";
import {Mode, mode2Text} from "./Editor";
import {useRouteMatch} from "react-router-dom";
import {ProjectAndFileMatch} from "../../types/ProjectMatch";
import ProvenanceViewer from "../provenance/ProvenanceViewer";
import TripleViewer from "../provenance/TripleViewer";

type InputWindowProps = {
    height: number,
    mode: Mode,
    setMode: React.Dispatch<React.SetStateAction<Mode>>
    sentenceID: number,
    setSentenceID: React.Dispatch<React.SetStateAction<number>>,
    isSummarySentence: boolean,
    setIsSummarySentence: React.Dispatch<React.SetStateAction<boolean>>,
}

function InputWindow({height, mode, setMode, sentenceID, setSentenceID, isSummarySentence, setIsSummarySentence}: InputWindowProps) {
    // url
    let match = useRouteMatch<ProjectAndFileMatch>();
    const fileId: number = Number(match.params.fileId);
    const projectId: number = Number(match.params.projectId);

    // local state
    const [fileContent, setFileContent] = useState<string>("");
    const [showNER, setShowNER] = useState<boolean>(false);
    const [showTriples, setShowTriples] = useState<boolean>(false);
    const [isSaving, setIsSaving] = useState<boolean>(false);

    // initialize the file content as soon as the query completes
    const onGetFileCompleted = (data: GetFileById) => {
        if(data.files_by_pk) {
            setFileContent(data.files_by_pk.content)
        } else {
            alert("Error while retrieving the content of file with id " + fileId + "!")
        }
    }

    // remote state
    const { data, loading, error } = useGetFileById(fileId, projectId, onGetFileCompleted);

    // remote actions
    const {mutate: update} = useEditFileById()

    // ui actions
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
    const handleSaveFile = async () => {
        // set a loading indicator
        setIsSaving(true);

        // validate that the data we want to post exists
        if (!fileContent) {
            alert("Error: The post data (file content) is undefined!");
            setIsSaving(false);
            return;
        }

        try {
            // update file
            let variables: EditFileVariables = {
                id: fileId,
                projectId: projectId,
                content: fileContent,
            }
            await update({variables});

        // display errors that occur during the process as alerts
        } catch (error) {
            if(error?.response?.status && error?.response?.message) {
                alert(error.response.status + ": " + error.response.data.message)
            } else {
                alert(error)
            }

        // finally set the loading indicator
        } finally {
            setIsSaving(false);
        }
    }
    const handleChange = (newValue: string) => {
        setFileContent(newValue);
    }

    // view
    const NavStyle: CSSProperties = {
        fontSize: '1rem',
        textAlign: "center",
    }
    const ContentStyle: CSSProperties = {
        height: height,
        maxHeight: height
    }
    return (
        <>
            <Tab.Container id="input-tabs" defaultActiveKey="inputText">
                <nav id="input-navigation" className="navbar navbar-expand-lg navbar-light bg-light">
                    <Nav variant="pills" className="mr-auto" style={NavStyle}>
                        <Nav.Item>
                            <Nav.Link eventKey="inputText">Text</Nav.Link>
                        </Nav.Item>
                        <Nav.Item>
                            <Nav.Link eventKey="inputGraph">Graph</Nav.Link>
                        </Nav.Item>
                    </Nav>
                    <DropdownButton variant="outline-secondary" id="dropdown-basic-button" title={mode2Text(mode)} className="mr-auto">
                        <Dropdown.Item active={mode === Mode.Edit} onClick={() => setMode(Mode.Edit)} eventKey="inputText">Edit Mode</Dropdown.Item>
                        <Dropdown.Item active={mode === Mode.Annotation} onClick={() => setMode(Mode.Annotation)} eventKey="inputText">Annotation Mode</Dropdown.Item>
                        <Dropdown.Item active={mode === Mode.Provenance} onClick={() => setMode(Mode.Provenance)} eventKey="inputText">Provenance Mode</Dropdown.Item>
                        <Dropdown.Item active={mode === Mode.Triple} onClick={() => setMode(Mode.Triple)} eventKey="inputText">Triple Mode</Dropdown.Item>
                    </DropdownButton>
                    <Button variant="success"
                            onClick={handleSaveFile}
                            disabled={isSaving}
                    >
                        Save File <FontAwesomeIcon icon={faSync} />
                    </Button>
                </nav>
                <Tab.Content id="input-content" style={ContentStyle}>
                    <Tab.Pane eventKey="inputText" className="w-100 h-100">
                        {error && (
                            <pre style={{width: "100%", height: "100%"}}>
                                {JSON.stringify(error, null, 2)}
                            </pre>
                        )}
                        {!error && mode === Mode.Edit && (
                            <AceEditor
                                readOnly={loading || isSaving}
                                mode="text"
                                theme="github"
                                fontSize="20px"
                                onChange={handleChange}
                                name="UNIQUE_ID_OF_DIV"
                                width="100%"
                                height="100%"
                                value={fileContent}
                                // wrapEnabled={true}
                                editorProps={{ $blockScrolling: false}}
                            />
                        )}
                        {!error && mode === Mode.Annotation && (
                            <TokenAnnotator
                                tokens={['My', 'text', 'needs', 'annotating', 'for', 'NLP', 'training']}
                                value={[{start: 5, end: 6, tag: 'TOPIC', color: '#EEE'}]}
                                onChange={() => ""}
                                onMouseOver={() => console.log("MOUSE OVER :)")}
                            />
                        )}
                        {!error && mode === Mode.Provenance && (
                            <ProvenanceViewer
                                summaryDocument={data?.files_by_pk?.summary_document}
                                inputDocument={data?.files_by_pk?.document}
                                visualizeSummary={false}
                                isSummarySentence={isSummarySentence}
                                setIsSummarySentence={setIsSummarySentence}
                                sentenceID={sentenceID}
                                setSentenceID={setSentenceID}
                                showNER={showNER}
                                showTriples={showTriples}
                                showFaithfulness={false}
                            />
                        )}
                        {!error && mode === Mode.Triple && (
                            <TripleViewer
                                summaryDocument={data?.files_by_pk?.summary_document}
                                inputDocument={data?.files_by_pk?.document}
                                visualizeSummary={false}
                                isSummaryTriple={isSummarySentence}
                                setIsSummaryTriple={setIsSummarySentence}
                                tripleID={sentenceID}
                                setTripleID={setSentenceID}
                            />
                        )}
                    </Tab.Pane>
                    <Tab.Pane eventKey="inputGraph" className="w-100 h-100">
                        <Graph />
                    </Tab.Pane>
                </Tab.Content>
            </Tab.Container>
            <Navbar id="input-footer-navigation" expand="lg" variant="light" bg="secondary">
                <Navbar.Brand>
                    <Form inline>
                        <Form.Check
                            type="switch"
                            id="switch-ner"
                            label="Named Entities"
                            className="mr-4"
                            onChange={handleNerChange}
                            checked={showNER}
                        />
                        <Form.Check
                            type="switch"
                            id="switch-triples"
                            label="Triples"
                            onChange={handleTriplesChange}
                            checked={showTriples}
                        />
                    </Form>
                </Navbar.Brand>
            </Navbar>
        </>
    );
}

export default InputWindow;