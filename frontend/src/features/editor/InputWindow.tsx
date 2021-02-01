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
import {EditFileVariables, GetFileById} from "../../graphql/types/files-generated-types";
import {useEditFileById, useGetFileById} from "../../graphql/files";
import TokenAnnotator from "react-text-annotate/lib/TokenAnnotator";
import axios, {AxiosResponse} from "axios";
import {MyAnnotationDataResult} from "../../graphql/types/annotations";
import {Mode, mode2Text} from "./Editor";
import DocumentProvenanceViewer from "../provenance/DocumentProvenanceViewer";
import {useRouteMatch} from "react-router-dom";
import {ProjectAndFileMatch, ProjectMatch} from "../../graphql/types/ProjectMatch";

type InputWindowProps = {
    height: number,
    mode: Mode,
    setMode: React.Dispatch<React.SetStateAction<Mode>>
    sentenceID: number,
}

function InputWindow({height, mode, setMode, sentenceID}: InputWindowProps) {
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
            // do the post request
            let result = await axios.post<any, AxiosResponse<MyAnnotationDataResult>>("http://localhost:3333/annotate", {
                text: fileContent
            });

            // check if result contains the data we need
            if(result?.data?.annotations && result?.data?.triples) {

                // perform some logic with the result data
                let variables: EditFileVariables = {
                    id: fileId,
                    projectId: projectId,
                    content: fileContent,
                    sentences: result.data.annotations.map(annotation => annotation.text),
                    annotationData: result.data.annotations,
                    tripleData: result.data.triples
                }
                await update({variables});

            // throw an error if the result does not contain the data we expect
            } else {
                throw new Error("Failed parsing the result from http://localhost:3333/annotate.");
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
                            <DocumentProvenanceViewer
                                              sentences={data?.files_by_pk?.sentences}
                                              annotationData={data?.files_by_pk?.annotation_data}
                                              alignmentData={data?.files_by_pk?.summary_alignment_data}
                                              triplesData={data?.files_by_pk?.triple_data}
                                              sentenceID={sentenceID}
                                              showNER={showNER}
                                              showTriples={showTriples}
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