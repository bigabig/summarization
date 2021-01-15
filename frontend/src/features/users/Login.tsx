import Button from "react-bootstrap/Button";
import Modal from "react-bootstrap/Modal";
import React, {CSSProperties, useState} from "react";
import {FontAwesomeIcon} from "@fortawesome/react-fontawesome";
import {faSignInAlt} from "@fortawesome/free-solid-svg-icons";
import Form from "react-bootstrap/Form";
import "../projects/styles/ProjectManager.css";

function Login() {
    const ModalBodyStyle: CSSProperties = {
        fontSize: '1rem',
    }

    const [show, setShow] = useState(false);

    return (
        <>
            <Button variant="outline-success" onClick={() => setShow(true)}>Log In <FontAwesomeIcon icon={faSignInAlt} /></Button>

            <Modal
                show={show}
                onHide={() => setShow(false)}
                backdrop="static"
            >
                <Modal.Header closeButton>
                    <Modal.Title id="modal-login-title">
                        Log in to LT Webapp
                    </Modal.Title>
                </Modal.Header>
                <Modal.Body style={ModalBodyStyle}>
                    <Form>
                        <Form.Group controlId="formLoginUser">
                            <Form.Control type="text" placeholder="Username" />
                            <Form.Text className="text-danger">
                                Username does not exist!
                            </Form.Text>
                        </Form.Group>
                        <Form.Group controlId="formLoginUser">
                            <Form.Control type="password" placeholder="Password" />
                            <Form.Text className="text-danger">
                                Password is incorrect!
                            </Form.Text>
                        </Form.Group>
                        <Button variant="success" className="w-100" onClick={() => setShow(false)}>Log In</Button>
                    </Form>
                </Modal.Body>
            </Modal>
        </>
    );
}

export default Login;