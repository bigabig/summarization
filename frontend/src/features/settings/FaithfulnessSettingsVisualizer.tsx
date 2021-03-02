import OverlayTrigger from "react-bootstrap/OverlayTrigger";
import Tooltip from "react-bootstrap/Tooltip";
import Button from "react-bootstrap/Button";
import {FontAwesomeIcon} from "@fortawesome/react-fontawesome";
import {faCog} from "@fortawesome/free-solid-svg-icons";
import Modal from "react-bootstrap/Modal";
import Form from "react-bootstrap/Form";
import React, {useContext, useState} from "react";
import Tab from "react-bootstrap/Tab";
import { Row } from "react-bootstrap";
import Col from "react-bootstrap/Col";
import Nav from "react-bootstrap/Nav";
import {FaithfulnesSettingsContext} from "../editor/DocumentEditor";
import { EntailmentMethod } from "../../types/entailmentmethod";

export interface FaithfulnessSettings {
    BERTScoreThreshold: number,
    QAThreshold: number,
    EntailmentMethod: EntailmentMethod
}

export type FaithfulnessSettingsProps = {
    name: string
}

function FaithfulnessSettingsVisualizer({name}: FaithfulnessSettingsProps) {
    // context
    const { settings, setSettings } = useContext(FaithfulnesSettingsContext)

    // local state
    const [show, setShow] = useState(false)
    const [bertscoreThreshold, setBertscoreThreshold] = useState(95);
    const [qaThreshold, setQAThreshold] = useState(90);
    const [entailmentMethod, setEntailmentMethod] = useState(EntailmentMethod.TopSentencesSentence)

    // actions
    const handleClose = () => {
        // reset changes to the settings to global state
        setBertscoreThreshold(settings.BERTScoreThreshold)
        setQAThreshold(settings.QAThreshold)
        setEntailmentMethod(settings.EntailmentMethod)

        setShow(false);
    }
    const handleShow = () => setShow(true);
    const handleSave = () => {
        // save settings globally
        setSettings({
            QAThreshold: qaThreshold,
            EntailmentMethod: entailmentMethod,
            BERTScoreThreshold: bertscoreThreshold
        })

        setShow(false);
    }
    const handleBertscoreThresholdChange = (newValue: number) => {
        setBertscoreThreshold(newValue)
    }
    const handleQAThresholdChange = (newValue: number) => {
        setQAThreshold(newValue)
    }


    const checkSaveDisabled = () => {
        return false;
    }


    return (
        <>
            <OverlayTrigger transition={false} placement="bottom" overlay={
                <Tooltip id="tooltip-add-file">Faithfulness Settings</Tooltip>
            } >
                {({ ref, ...triggerHandler }) => (
                    <div style={{display: 'inline-block', cursor: 'not-allowed'}} {...triggerHandler} >
                        <Button ref={ref}
                                onClick={handleShow}
                                variant="dark"
                        >
                            <FontAwesomeIcon icon={faCog}/>
                        </Button>
                    </div>
                )}
            </OverlayTrigger>
            <Modal
                show={show}
                onHide={handleClose}
                backdrop="static"
                size="lg"
            >
                <Modal.Header closeButton>
                    <Modal.Title>Faithfulness Settings</Modal.Title>
                </Modal.Header>
                <Modal.Body>

                    <Tab.Container id="left-tabs-settings" defaultActiveKey="bertscore">
                        <Row>
                            <Col sm={3}>
                                <Nav variant="pills" className="flex-column">
                                    <Nav.Item>
                                        <Nav.Link eventKey="bertscore">BERTScore</Nav.Link>
                                    </Nav.Item>
                                    <Nav.Item>
                                        <Nav.Link eventKey="entailment">Entailment</Nav.Link>
                                    </Nav.Item>
                                    <Nav.Item>
                                        <Nav.Link eventKey="qa">QA</Nav.Link>
                                    </Nav.Item>
                                </Nav>
                            </Col>

                            <Col sm={9}>
                                <Tab.Content>
                                    <Tab.Pane eventKey="bertscore">
                                        <Form>
                                            <Form.Group controlId="formBERTScoreThreshold">
                                                <Form.Label>Similarity Threshold: {bertscoreThreshold}%</Form.Label>
                                                <Form.Control type="range"
                                                              min={0}
                                                              value={bertscoreThreshold}
                                                              onChange={(event) => handleBertscoreThresholdChange(parseFloat(event.target.value))}/>
                                            </Form.Group>
                                        </Form>
                                    </Tab.Pane>

                                    <Tab.Pane eventKey="entailment">
                                        <Form>

                                            <div className="mb-3">
                                                <Form.Label>Entailment Method:</Form.Label>
                                                <Form.Check
                                                    custom
                                                    type={"radio"}
                                                    id='toggle-entailment-method-1'
                                                    label={`source document -> summary sentence`}
                                                    checked={entailmentMethod === EntailmentMethod.DocumentSentence}
                                                    onChange={() => setEntailmentMethod(EntailmentMethod.DocumentSentence)}
                                                />
                                                <Form.Check
                                                    custom
                                                    type={"radio"}
                                                    id='toggle-entailment-method-2'
                                                    label={`top 3 source sentences -> summary sentence`}
                                                    checked={entailmentMethod === EntailmentMethod.TopSentencesSentence}
                                                    onChange={() => setEntailmentMethod(EntailmentMethod.TopSentencesSentence)}
                                                />
                                                <Form.Check
                                                    custom
                                                    type={"radio"}
                                                    id='toggle-entailment-method-3'
                                                    label={`source sentence -> summary sentence`}
                                                    checked={entailmentMethod === EntailmentMethod.SentenceSentence}
                                                    onChange={() => setEntailmentMethod(EntailmentMethod.SentenceSentence)}
                                                />
                                            </div>

                                        </Form>

                                    </Tab.Pane>

                                    <Tab.Pane eventKey="qa">
                                        <Form>
                                            <Form.Group controlId="formQAThreshold">
                                                <Form.Label>Answer Similarity Threshold: {qaThreshold}%</Form.Label>
                                                <Form.Control type="range"
                                                              min={0}
                                                              value={qaThreshold}
                                                              onChange={(event) => handleQAThresholdChange(parseFloat(event.target.value))}/>
                                            </Form.Group>
                                        </Form>
                                    </Tab.Pane>
                                </Tab.Content>
                            </Col>

                        </Row>
                    </Tab.Container>
                </Modal.Body>
                <Modal.Footer>
                    <Button variant="danger" onClick={handleClose}>Abort</Button>
                    <Button variant="success" onClick={handleSave} disabled={checkSaveDisabled()}>Save</Button>
                </Modal.Footer>
            </Modal>
        </>
    )
}

export default FaithfulnessSettingsVisualizer;