import React, {ChangeEvent, useState} from "react";
import Button from "react-bootstrap/Button";
import Modal from "react-bootstrap/Modal";
import Form from "react-bootstrap/Form";
import {useGetFileById, useRenameFileById} from "./graphql/filesGraphQL";
import Dropdown from "react-bootstrap/Dropdown";
import {FontAwesomeIcon} from "@fortawesome/react-fontawesome";
import {faPen, faPlus} from "@fortawesome/free-solid-svg-icons";
import {GetFileById} from "./types/files-generated-types";
import OverlayTrigger from "react-bootstrap/OverlayTrigger";
import Tooltip from "react-bootstrap/Tooltip";

export enum RenameFileFormMode {
    Button,
    Dropdown
}

type RenameFileFormProps = {
    fileId: number | undefined,
    mode: RenameFileFormMode
}

// This is a wrapper for RenameFileFormContent and makes sure that fileID is not undefined
function RenameFileForm({ fileId, mode }: RenameFileFormProps) {
    if (!fileId) {
        switch (mode) {
            case RenameFileFormMode.Button:
                return (
                    <OverlayTrigger transition={false} placement="right" overlay={
                        <Tooltip id="tooltip-add-file">Rename selected file</Tooltip>
                    } >
                        {({ ref, ...triggerHandler }) => (
                            <div style={{display: 'inline-block', cursor: 'not-allowed'}} {...triggerHandler} >
                                <Button ref={ref} variant="light" disabled style={{pointerEvents: 'none'}}>
                                    <FontAwesomeIcon icon={faPen}/>
                                </Button>
                            </div>
                        )}
                    </OverlayTrigger>
                )
            case RenameFileFormMode.Dropdown:
                return (
                    <Dropdown.Item eventKey="1" disabled>
                        Rename
                    </Dropdown.Item>
                )
            default:
                return (<div>Something went wrong.</div>)
        }
    } else {
        return (
            <RenameFileFormContent fileId={fileId}  mode={mode}/>
        )
    }
}

type RenameFileFormContentProps = {
    fileId: number,
    mode: RenameFileFormMode
}

function RenameFileFormContent({ fileId, mode }: RenameFileFormContentProps) {
    // local state
    const [show, setShow] = useState(false);
    const [fileName, setFileName] = useState("");

    // initialize the file name as soon as the query completes
    const onGetFileCompleted = (data: GetFileById) => {
        if(data.files_by_pk?.name) {
            setFileName(data.files_by_pk.name)
        }
    }

    // remote state
    const { loading, error, data } = useGetFileById(fileId, onGetFileCompleted);

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
                name: fileName
            }
        }).then(_ => {
            setShow(false)
        });
    };

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
                                    disabled={loading || !data?.files_by_pk?.id}
                                    style={loading || !data?.files_by_pk?.id ? {pointerEvents: 'none'} : {}}>
                                <FontAwesomeIcon icon={faPen}/>
                            </Button>
                        </div>
                    )}
                </OverlayTrigger>
            )}
            {mode === RenameFileFormMode.Dropdown && (
                <Dropdown.Item eventKey="1" onClick={handleShow} disabled={loading || !data?.files_by_pk?.id}>
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
                            <Form.Label>File Name</Form.Label>
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
                    <Button variant="success" onClick={handleRename} disabled={fileName.length === 0 || updateLoading}>Rename</Button>
                </Modal.Footer>
            </Modal>
        </>
    );
}

export default RenameFileForm