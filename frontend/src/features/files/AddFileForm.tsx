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
import {useAddFile} from "../../graphql/files";
import axios from 'axios';
import Spinner from "react-bootstrap/esm/Spinner";
import {useRouteMatch} from "react-router-dom";
import {ProjectMatch} from "../../types/ProjectMatch";

function isValidHttpUrl(string: string) {
    let url;
    try {
        url = new URL(string);
    } catch (_) {
        return false;
    }
    return url.protocol === "http:" || url.protocol === "https:";
}

function AddFileForm() {
    const match = useRouteMatch<ProjectMatch>();
    const projectId: number = Number(match.params.projectId);

    const ModalBodyStyle: CSSProperties = {
        fontSize: '1rem',
    }

    // local state
    const [show, setShow] = useState(false);

    const [fileName, setFileName] = useState("");

    const [uploadFileName, setUploadFileName] = useState("");
    const [uploadFile, setUploadFile] = useState<File | undefined>(undefined);
    const [uploadLoading, setUploadLoading] = useState(false);

    const [extractURL, setExtractURL] = useState("");
    const [extractFileName, setExtractFileName] = useState("");
    const [extractLoading, setExtractLoading] = useState(false);

    // remote actions
    const {mutate: addFile, loading: addLoading, error: addError } = useAddFile(Number(projectId))

    // actions
    const handleAddFile = () => {
        addFile({
            variables: {
                name: fileName,
                content: '',
                project_id: Number(projectId)
            }
        }).then(_ => {
            setFileName('');
            setShow(false);
        });
    };
    const handleUploadFile = () => {
        if (uploadFile) {
            setUploadLoading(true);
            const data = new FormData();
            data.append('file', uploadFile)
            axios.post("http://localhost:3333/upload", data).then(result => {
                if (result?.data?.text) {
                    addFile({
                        variables: {
                            name: uploadFileName,
                            content: result.data.text.reduce((previousValue: string, currentValue: string) => previousValue + "\n" + currentValue, "").trim(),
                            project_id: Number(projectId)
                        }
                    }).then(_ => {
                        setUploadFileName('');
                        setUploadFile(undefined);
                        setShow(false);
                    })
                } else {
                    throw new Error("An error occurred during text extraction.")
                }
            }).catch(error => {
                alert(error);
            }).finally(() => {
                setUploadLoading(false);
            })
        }
    }
    const handleExtractURL = () => {
        setExtractLoading(true);
        axios.post("http://localhost:3333/extract", {url: extractURL}).then(result => {
            if (result?.data?.text) {
                addFile({
                    variables: {
                        name: extractFileName,
                        content: result.data.text.reduce((previousValue: string, currentValue: string) => previousValue + "\n" + currentValue, "").trim(),
                        project_id: Number(projectId)
                    }
                }).then(_ => {
                    setExtractFileName('');
                    setExtractURL('');
                    setShow(false);
                })
            } else {
                alert("Extraction result is malformed!")
            }
        }).catch(error => {
            alert(error.response.status + ": " + error.response.data.message)
        }).finally(() => {
            setExtractLoading(false);
        })
    }


    // ui actions
    const handleClose = () => setShow(false);
    const handleShow = () => setShow(true);
    const handleFileNameChange = (event: ChangeEvent<HTMLInputElement>) => {
        setFileName(event.target.value)
    }
    const handleUploadFileNameChange = (event: ChangeEvent<HTMLInputElement>) => {
        setUploadFileName(event.target.value)
    }
    const handleFileSelect = (event: ChangeEvent<HTMLInputElement>) => {
        console.log(event.target.files?.[0])
        setUploadFile(event.target.files?.[0])
    }
    const handleExtractFileNameChange = (event: ChangeEvent<HTMLInputElement>) => {
        setExtractFileName(event.target.value)
    }
    const handleExtractURLChange = (event: ChangeEvent<HTMLInputElement>) => {
        setExtractURL(event.target.value)
    }

    // view
    const checkUploadDisabled = () => {
        return !(!uploadLoading && uploadFileName.length > 0 && uploadFile !== undefined && uploadFileName.endsWith(".txt") && (uploadFile.name.endsWith(".txt") || uploadFile.name.endsWith(".pdf")))
    }
    const checkExtractDisabled = () => {
        return !(!extractLoading && extractFileName.length > 0 && extractFileName.endsWith(".txt") && extractURL.length > 0 && isValidHttpUrl(extractURL))
    }

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
                                                <Form.File.Input onChange={handleFileSelect} disabled={uploadLoading}/>
                                            </Form.File>
                                            <Form.Group controlId="formUploadFileId">
                                                <Form.Label>File Name in this project (*.txt)</Form.Label>
                                                <Form.Control type="text" placeholder="Enter file name" value={uploadFileName} onChange={handleUploadFileNameChange}  disabled={uploadLoading}/>
                                                {addError && (
                                                    <Form.Text className="text-danger">
                                                        {addError.message}
                                                    </Form.Text>
                                                )}
                                            </Form.Group>
                                        </Form>
                                    </Tab.Pane>

                                    <Tab.Pane eventKey="website">
                                        <Form.Group controlId="formUrlId" className="mb-4">
                                            <Form.Label>URL to extract content from (https://...)</Form.Label>
                                            <Form.Control type="text" placeholder="https://www.example.com/" value={extractURL} onChange={handleExtractURLChange} disabled={extractLoading}/>
                                        </Form.Group>
                                        <Form.Group controlId="formUrlFileName">
                                            <Form.Label>File Name in this project (*.txt)</Form.Label>
                                            <Form.Control type="text" placeholder="example.txt" value={extractFileName} onChange={handleExtractFileNameChange} disabled={extractLoading}/>
                                            {addError && (
                                                <Form.Text className="text-danger">
                                                    {addError.message}
                                                </Form.Text>
                                            )}
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
                                <Button variant="success" onClick={handleAddFile} disabled={addLoading || fileName.length === 0 || !fileName.endsWith(".txt")}>
                                    Create
                                </Button>
                            </Tab.Pane>

                            <Tab.Pane eventKey="upload">
                                <Button variant="success" onClick={handleUploadFile} disabled={checkUploadDisabled()}>
                                    {uploadLoading && (
                                        <Spinner
                                            style={{marginRight: "8px"}}
                                            as="span"
                                            animation="border"
                                            size="sm"
                                            role="status"
                                            aria-hidden="true"
                                        />
                                    )}
                                    Upload & Create
                                </Button>
                            </Tab.Pane>

                            <Tab.Pane eventKey="website">
                                <Button variant="success" onClick={handleExtractURL} disabled={checkExtractDisabled()}>
                                    {extractLoading && (
                                        <Spinner
                                            style={{marginRight: "8px"}}
                                            as="span"
                                            animation="border"
                                            size="sm"
                                            role="status"
                                            aria-hidden="true"
                                        />
                                    )}
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