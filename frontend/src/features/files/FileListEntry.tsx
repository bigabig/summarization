import Dropdown from "react-bootstrap/Dropdown";
import ButtonGroup from "react-bootstrap/ButtonGroup";
import Button from "react-bootstrap/Button";
import React from "react";
import {useDeleteFile, useGetFileById} from "./graphql/filesGraphQL";
import {GlobalEditorState} from "../editor/Editor";
import RenameFileForm, {RenameFileFormMode} from "./RenameFileForm";

type FileListEntryProps = {
    fileId: number,
    editorState: GlobalEditorState
}

function FileListEntry({ fileId, editorState }: FileListEntryProps) {
    // remote state
    const { loading, error, data } = useGetFileById(fileId)

    // remote actions
    const { loading: deleteLoading, mutate: deleteFile} = useDeleteFile(editorState.state.projectId)

    // ui actions
    const handleSelect = () => {
        editorState.setState({...editorState.state, fileId})
    }
    const handleDelete = () => {
        deleteFile({ variables: { id: fileId } })
            .then(result => {
                if(!result.data?.delete_files_by_pk?.id) {
                    alert("Error while deleting file with id " + fileId)
                } else {
                    // update editor state, as the file does not exist anymore!
                    editorState.setState({...editorState.state, fileId: undefined})
                }
            })
            .catch(error => {
                alert(error)
            })
    }

    // view
    if (loading) {
        return (
            <div>Loading file with id {fileId}...</div>
        )
    } else if (error) {
        return (
            <div><pre>{JSON.stringify(error, null, 2)}</pre></div>
        )
    } else if (!data?.files_by_pk) {
        return (
            <div>File with id {fileId} does not exist!</div>
        )
    } else {
        return (
            <Dropdown as={ButtonGroup} className="w-100">
                <Button variant="secondary" className="no-border-radius" block active={editorState.state.fileId === fileId} onClick={handleSelect}>{data.files_by_pk.name}</Button>
                <Dropdown.Toggle split variant="secondary" id="dropdown-split-basic" className="no-border-radius" active={editorState.state.fileId === fileId}/>
                <Dropdown.Menu>
                    <RenameFileForm fileId={fileId} mode={RenameFileFormMode.Dropdown} />
                    <Dropdown.Item eventKey="2" onClick={handleDelete} disabled={deleteLoading}>Delete</Dropdown.Item>
                </Dropdown.Menu>
            </Dropdown>
        )
    }
}

export default FileListEntry;