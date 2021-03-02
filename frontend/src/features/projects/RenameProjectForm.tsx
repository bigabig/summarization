import React, {ChangeEvent, useState} from "react";
import Button from "react-bootstrap/Button";
import Modal from "react-bootstrap/Modal";
import Form from "react-bootstrap/Form";
import {useRenameProjectById} from "../../graphql/projects";
import {GetProjectById_projects_by_pk} from "../../types/projects-generated-types";

type RenameProjectFormProps = {
    project: GetProjectById_projects_by_pk
}

function RenameProjectForm({ project }: RenameProjectFormProps) {
    // local state
    const [show, setShow] = useState(false);
    const [projectName, setProjectName] = useState(project.name);

    // remote actions
    const {mutate: rename, error: updateError, loading: updateLoading} = useRenameProjectById()

    // ui actions
    const handleClose = () => setShow(false);
    const handleShow = () => setShow(true);
    const handleChange = (event: ChangeEvent<HTMLInputElement|HTMLSelectElement|HTMLTextAreaElement>) => {
        setProjectName(event.target.value)
    }
    const handleRename = () => {
        rename({
            variables: {
                id: project.id,
                name: projectName
            }
        }).then(_ => {
            setShow(false)
        });
    };

    // view
    return (
        <>
            <Button variant="primary" onClick={handleShow}>
                Rename
            </Button>

            <Modal
                show={show}
                onHide={handleClose}
                backdrop="static"
            >
                <Modal.Header closeButton>
                    <Modal.Title>Rename Project</Modal.Title>
                </Modal.Header>
                <Modal.Body>
                    <Form>
                        <Form.Group controlId="formProjectName">
                            <Form.Label>Project Name</Form.Label>
                            <Form.Control type="text" placeholder="Enter project name" value={projectName} onChange={handleChange} />
                            {updateError && (
                                <Form.Text className="text-danger">
                                    {updateError.message}
                                </Form.Text>
                            )}
                        </Form.Group>
                    </Form>
                </Modal.Body>
                <Modal.Footer>
                    <Button variant="danger" onClick={handleClose}>Abort</Button>
                    <Button variant="success" onClick={handleRename} disabled={projectName.length === 0 || updateLoading}>Rename</Button>
                </Modal.Footer>
            </Modal>
        </>
    );
}

export default RenameProjectForm