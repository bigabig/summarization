import React from "react";
import Navbar from "react-bootstrap/Navbar";
import {FontAwesomeIcon} from "@fortawesome/react-fontawesome";
import {faPen, faTrash} from "@fortawesome/free-solid-svg-icons";
import Button from "react-bootstrap/Button";
import Tooltip from 'react-bootstrap/Tooltip';
import OverlayTrigger from 'react-bootstrap/OverlayTrigger';
import AddFileForm from "./AddFileForm";
import FileList from "./FileList";
import {GlobalEditorState} from "../editor/Editor";
import RenameFileForm, {RenameFileFormMode} from "./RenameFileForm";
import {useDeleteFile} from "./graphql/filesGraphQL";

type FileBrowserProps = {
    height: number,
    editorState: GlobalEditorState,
}

function FileBrowser({height, editorState}: FileBrowserProps) {
    // remote actions
    const { loading: deleteLoading, mutate: deleteFile} = useDeleteFile(editorState.state.projectId)

    const handleDelete = () => {
        if (editorState.state.fileId) {
            deleteFile({ variables: { id: editorState.state.fileId } })
                .then(result => {
                    if(!result.data?.delete_files_by_pk?.id) {
                        alert("Error while deleting file with id " + editorState.state.fileId)
                    } else {
                        // update editor state, as the file does not exist anymore!
                        editorState.setState({...editorState.state, fileId: undefined})
                    }
                })
                .catch(error => {
                    alert(error)
                })
        }
    }

    return (
        <div>
            <Navbar id="file-navigation" bg="light" expand="lg">
                <AddFileForm editorState={editorState} />
                <RenameFileForm mode={RenameFileFormMode.Button} fileId={editorState.state.fileId} />
                <OverlayTrigger transition={false}  placement="right" overlay={
                    <Tooltip id="tooltip-add-file">Delete selected file</Tooltip>
                } >
                    {({ ref, ...triggerHandler }) => (
                        <div style={{display: 'inline-block', cursor: 'not-allowed'}} {...triggerHandler}>
                            <Button ref={ref}
                                    variant="light"
                                    onClick={handleDelete}
                                    disabled={deleteLoading || !editorState.state.fileId}
                                    style={deleteLoading || !editorState.state.fileId ? {pointerEvents: 'none'} : {}}>
                                <FontAwesomeIcon icon={faTrash}/>
                            </Button>
                        </div>
                    )}
                </OverlayTrigger>
            </Navbar>
            <FileList height={height} editorState={editorState}/>
        </div>
    );
}

export default FileBrowser;