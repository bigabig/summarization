import Navbar from "react-bootstrap/Navbar";
import Dropdown from "react-bootstrap/Dropdown";
import Button from "react-bootstrap/Button";
import {FontAwesomeIcon} from "@fortawesome/react-fontawesome";
import {faPlay} from "@fortawesome/free-solid-svg-icons";
import React, {CSSProperties} from "react";
import ButtonGroup from "react-bootstrap/ButtonGroup";
import Form from "react-bootstrap/Form";
import AceEditor from "react-ace";
import "ace-builds/src-noconflict/mode-jsx";
import "ace-builds/src-noconflict/mode-java";
import "ace-builds/src-noconflict/theme-github";
import "ace-builds/src-min-noconflict/ext-searchbox";
import "ace-builds/src-min-noconflict/ext-language_tools";

function OutputWindow(props: {height: number}) {
    const ContentStyle: CSSProperties = {
        height: props.height,
        maxHeight: props.height
    }
    return (
        <div>
            <Navbar id="output-navigation"  bg="light" expand="lg">
                <Dropdown as={ButtonGroup}>
                    <Button variant="success"><FontAwesomeIcon icon={faPlay} /> Summarize </Button>

                    <Dropdown.Toggle split variant="success" id="dropdown-split-basic" />

                    <Dropdown.Menu>
                        <Dropdown.Item eventKey="1" active>Summarization Method 1</Dropdown.Item>
                        <Dropdown.Item eventKey="2">Summarization Method 2</Dropdown.Item>
                        <Dropdown.Divider />
                        <Dropdown.Item eventKey="3">Something else</Dropdown.Item>
                    </Dropdown.Menu>
                </Dropdown>
            </Navbar>
            <div style={ContentStyle}>
                <AceEditor
                    readOnly={true}
                    mode="java"
                    theme="github"
                    fontSize="20px"
                    name="summary-editor"
                    width="100%"
                    height="100%"
                    value={"Summary Sentence 1\nSummary Sentence 2\nSummary Sentence 3"}
                    editorProps={{ $blockScrolling: true}}
                />
            </div>
            <Navbar id="output-footer-navigation" expand="lg" variant="light" bg="secondary">
                <Navbar.Brand>
                    <Form inline>
                        <Form.Check
                            type="switch"
                            id="switch-summary-ner"
                            label="Named Entities"
                            className="mr-4"
                        />
                        <Form.Check
                            type="switch"
                            id="switch-faithfulness"
                            label="Faithfulness"
                        />
                    </Form>
                </Navbar.Brand>
            </Navbar>
        </div>
    );
}

export default OutputWindow;