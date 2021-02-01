import React, {ChangeEvent, useState} from "react";
import Button from "react-bootstrap/Button";
import Modal from "react-bootstrap/Modal";
import Form from "react-bootstrap/Form";
import {useGetFileById, useGetFileByIdNew, useRenameFileById} from "../../graphql/files";
import Dropdown from "react-bootstrap/Dropdown";
import {FontAwesomeIcon} from "@fortawesome/react-fontawesome";
import {faPen} from "@fortawesome/free-solid-svg-icons";
import {GetFileById} from "../../graphql/types/files-generated-types";
import OverlayTrigger from "react-bootstrap/OverlayTrigger";
import Tooltip from "react-bootstrap/Tooltip";
import {useRouteMatch} from "react-router-dom";
import {ProjectMatch} from "../../graphql/types/ProjectMatch";

export enum RenameFileFormMode {
    Button,
    Dropdown
}

type RenameFileFormProps = {
    mode: RenameFileFormMode
    fileId: number
}

function RenameFileForm({ mode, fileId }: RenameFileFormProps) {
    // global url state
    const projectMatch = useRouteMatch<ProjectMatch>();
    const projectId: number = Number(projectMatch.params.projectId)

    // local state
    const [show, setShow] = useState(false);
    const [fileName, setFileName] = useState("");

    // initialize the file name as soon as the query completes
    const onGetFileCompleted = (data: GetFileById) => {
        if(data?.files_by_pk?.name) {
            setFileName(data.files_by_pk.name)
        }
    }

    // remote state: fileData is undefined if it does not exist
    const { data: fileData } = useGetFileById(fileId, projectId, onGetFileCompleted);

    // remote actions
    const {mutate: update, error: updateError, loading: updateLoading} = useRenameFileById()

    // ui actions
    const handleClose = () => setShow(false);
    const handleShow = () => setShow(true);
    const handleChange = (event: ChangeEvent<HTMLInputElement|HTMLSelectElement|HTMLTextAreaElement>) => {
        setFileName(event.target.value)
    }
    const handleRename = () => {
        update({
            variables: {
                id: fileId,
                projectId: projectId,
                name: fileName
            }
        }).then(_ => {
            setShow(false)
        }).catch(error => {
            alert(error)
        });
    };

    const checkRenameDisabled = () => {
        return !fileData || updateLoading || fileName.length === 0 || !fileName.endsWith(".txt")
    }

    // view
    return (
        <>
            {mode === RenameFileFormMode.Button && (
                <OverlayTrigger transition={false} placement="right" overlay={
                    <Tooltip id="tooltip-add-file">Rename selected file</Tooltip>
                } >
                    {({ ref, ...triggerHandler }) => (
                        <div style={{display: 'inline-block', cursor: 'not-allowed'}} {...triggerHandler} >
                            <Button ref={ref}
                                    onClick={handleShow}
                                    variant="light"
                                    disabled={updateLoading || !fileData}
                                    style={updateLoading || !fileData  ? {pointerEvents: 'none'} : {}}>
                                <FontAwesomeIcon icon={faPen}/>
                            </Button>
                        </div>
                    )}
                </OverlayTrigger>
            )}
            {mode === RenameFileFormMode.Dropdown && (
                <Dropdown.Item eventKey="1" onClick={handleShow} disabled={updateLoading || !fileData}>
                    Rename
                </Dropdown.Item>
            )}

            <Modal
                show={show}
                onHide={handleClose}
                backdrop="static"
            >
                <Modal.Header closeButton>
                    <Modal.Title>Rename File</Modal.Title>
                </Modal.Header>
                <Modal.Body>
                    <Form>
                        <Form.Group controlId="formFileName">
                            <Form.Label>File Name (*.txt)</Form.Label>
                            <Form.Control type="text" placeholder="Enter file name" value={fileName} onChange={handleChange} />
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
                    <Button variant="success" onClick={handleRename} disabled={checkRenameDisabled()}>Rename</Button>
                </Modal.Footer>
            </Modal>
        </>
    );
}

export default RenameFileForm