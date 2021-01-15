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
import {GetFileById} from "../files/types/files-generated-types";
import {useEditFileById, useGetFileById, useRenameFileById} from "../files/graphql/filesGraphQL";

type InputWindowProps = {
    height: number,
    fileId: number,
}

function InputWindow({height, fileId}: InputWindowProps) {
    const NavStyle: CSSProperties = {
        fontSize: '1rem',
        textAlign: "center",
    }
    const ContentStyle: CSSProperties = {
        height: height,
        maxHeight: height
    }

    // local state
    const [fileContent, setFileContent] = useState("");

    // initialize the file content as soon as the query completes
    const onGetFileCompleted = (data: GetFileById) => {
        console.log(data.files_by_pk?.content)
        if(data.files_by_pk) {
            setFileContent(data.files_by_pk.content)
        } else {
            alert("Error while retrieving the content of file with id " + fileId + "!")
        }
    }

    // remote state
    const { loading, error } = useGetFileById(fileId, onGetFileCompleted);

    // remote actions
    const {mutate: update, error: updateError, loading: updateLoading} = useEditFileById()

    // ui actions
    const handleSaveFile = () => {
        update({
            variables: {
                id: fileId,
                content: fileContent,
            }
        }).catch(error => {
            alert(error);
            alert(updateError);
        })
    }
    const handleChange = (newValue: string) => {
        setFileContent(newValue);
    }

    // view
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
                    <DropdownButton variant="outline-secondary" id="dropdown-basic-button" title="Edit Mode" className="mr-auto">
                        <Dropdown.Item active eventKey="inputText">Edit Mode</Dropdown.Item>
                        <Dropdown.Item eventKey="inputText">Annotation Mode</Dropdown.Item>
                        <Dropdown.Item eventKey="inputText">Provenance Mode</Dropdown.Item>
                    </DropdownButton>
                    <Button variant="success"
                            onClick={handleSaveFile}
                            disabled={updateLoading}
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
                        {!error && (
                            <AceEditor
                                readOnly={loading}
                                mode="java"
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
                        />
                        <Form.Check
                            type="switch"
                            id="switch-triples"
                            label="Triples"
                        />
                    </Form>
                </Navbar.Brand>
            </Navbar>
        </>
    );
}

export default InputWindow;