import React, {ChangeEvent, CSSProperties, useState} from "react";
import OverlayTrigger from "react-bootstrap/OverlayTrigger";
import Tooltip from "react-bootstrap/Tooltip";
import Button from "react-bootstrap/Button";
import {FontAwesomeIcon} from "@fortawesome/react-fontawesome";
import {faFile, faGlobe, faPlus, faUpload} from "@fortawesome/free-solid-svg-icons";
import Modal from "react-bootstrap/Modal";
import Tab from "react-bootstrap/Tab";
import Row from "react-bootstrap/Row";
import Col from "react-bootstrap/Col";
import Nav from "react-bootstrap/Nav";
import Form from "react-bootstrap/Form";
import {useAddFile} from "./graphql/filesGraphQL";
import {GlobalEditorState} from "../editor/Editor";

type AddFileFormProps = {
    editorState: GlobalEditorState
}

function AddFileForm({ editorState }: AddFileFormProps) {
    const ModalBodyStyle: CSSProperties = {
        fontSize: '1rem',
    }

    // local state
    const [fileName, setFileName] = useState("");
    const [show, setShow] = useState(false);

    // remote actions
    const {mutate: addFile, loading: addLoading, error: addError } = useAddFile(editorState.state.projectId)

    // actions
    const handleAddFile = () => {
        addFile({
            variables: {
                name: fileName,
                content: '',
                project_id: editorState.state.projectId
            }
        }).then(_ => {
            setFileName('');
            setShow(false);
        });
    };

    // ui actions
    const handleClose = () => setShow(false);
    const handleShow = () => setShow(true);
    const handleFileNameChange = (event: ChangeEvent<HTMLInputElement>) => {
        setFileName(event.target.value)
    }

    // view
    return (
        <>
            <OverlayTrigger transition={false} placement="right" overlay={<Tooltip id="tooltip-add-file">Add a new file</Tooltip>}>
                {({ ref, ...triggerHandler }) => (
                    <Button {...triggerHandler} ref={ref} variant="light" className="mr-auto" onClick={handleShow}><FontAwesomeIcon icon={faPlus} /></Button>
                )}
            </OverlayTrigger>

            <Modal show={show} onHide={handleClose} backdrop="static" size="lg">
                <Modal.Header closeButton>
                    <Modal.Title>Add file</Modal.Title>
                </Modal.Header>
                <Tab.Container id="left-tabs-example" defaultActiveKey="new">
                    <Modal.Body style={ModalBodyStyle}>
                        <Row>
                            <Col sm={3}>
                                <Nav variant="pills" className="flex-column text-left">
                                    <Nav.Item>
                                        <Nav.Link eventKey="new" className="p-2"><FontAwesomeIcon icon={faFile} /> New file</Nav.Link>
                                    </Nav.Item>
                                    <Nav.Item>
                                        <Nav.Link eventKey="upload" className="p-2"><FontAwesomeIcon icon={faUpload} /> Upload file</Nav.Link>
                                    </Nav.Item>
                                    <Nav.Item>
                                        <Nav.Link eventKey="website" className="p-2"><FontAwesomeIcon icon={faGlobe} /> From website</Nav.Link>
                                    </Nav.Item>
                                </Nav>
                            </Col>
                            <Col sm={9}>
                                <Tab.Content>
                                    <Tab.Pane eventKey="new">
                                        <Form>
                                            <Form.Group controlId="formFileName">
                                                <Form.Label>File Name (*.txt)</Form.Label>
                                                <Form.Control type="text" placeholder="Enter file name" value={fileName} onChange={handleFileNameChange}/>
                                                {addError && (
                                                    <Form.Text className="text-danger">
                                                        {addError.message}
                                                    </Form.Text>
                                                )}
                                            </Form.Group>
                                        </Form>
                                    </Tab.Pane>
                                    <Tab.Pane eventKey="upload">
                                        <Form>
                                            <Form.File id="formcheck-api-regular" className="mb-4">
                                                <Form.File.Label>Upload File (*.txt or *.pdf)</Form.File.Label>
                                                <Form.File.Input />
                                            </Form.File>
                                            <Form.Group controlId="formUploadFileId">
                                                <Form.Label>File Name in this project (*.txt)</Form.Label>
                                                <Form.Control type="text" placeholder="Enter file name" />
                                                <Form.Text className="text-danger">
                                                    File already exists! Please choose another file name.
                                                </Form.Text>
                                            </Form.Group>
                                        </Form>
                                    </Tab.Pane>
                                    <Tab.Pane eventKey="website">
                                        <Form.Group controlId="formUrlId" className="mb-4">
                                            <Form.Label>URL to extract content from (https://...)</Form.Label>
                                            <Form.Control type="text" placeholder="https://www.example.com/" />
                                        </Form.Group>
                                        <Form.Group controlId="formUrlFileName">
                                            <Form.Label>File Name in this project (*.txt)</Form.Label>
                                            <Form.Control type="text" placeholder="example.txt" />
                                            <Form.Text className="text-danger">
                                                File already exists! Please choose another file name.
                                            </Form.Text>
                                        </Form.Group>
                                    </Tab.Pane>
                                </Tab.Content>
                            </Col>
                        </Row>
                    </Modal.Body>
                    <Modal.Footer>
                        <Button variant="secondary" onClick={handleClose}>
                            Close
                        </Button>
                        <Tab.Content>
                            <Tab.Pane eventKey="new">
                                <Button variant="success" onClick={handleAddFile} disabled={addLoading || fileName.length === 0}>
                                    Create
                                </Button>
                            </Tab.Pane>
                            <Tab.Pane eventKey="upload">
                                <Button variant="success" onClick={handleClose}>
                                    Upload & Create
                                </Button>
                            </Tab.Pane>
                            <Tab.Pane eventKey="website">
                                <Button variant="success" onClick={handleClose}>
                                    Extract & Create
                                </Button>
                            </Tab.Pane>
                        </Tab.Content>
                    </Modal.Footer>
                </Tab.Container>
            </Modal>
        </>
    );
}

export default AddFileForm;