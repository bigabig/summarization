import Dropdown from "react-bootstrap/Dropdown";
import ButtonGroup from "react-bootstrap/ButtonGroup";
import React from "react";
import {useDeleteFile, useGetFileById} from "../../graphql/files";
import RenameFileForm, {RenameFileFormMode} from "./RenameFileForm";
import {NavLink, useHistory, useRouteMatch} from "react-router-dom";
import {ProjectMatch} from "../../graphql/types/ProjectMatch";

type FileListEntryProps = {
    fileId: number,
}

function FileListEntry({ fileId }: FileListEntryProps) {
    // global url state
    const match = useRouteMatch<ProjectMatch>();
    const projectId: number = Number(match.params.projectId);

    const {push} = useHistory();

    // remote state
    const { loading, error, data } = useGetFileById(fileId, projectId)

    // remote actions
    const { loading: deleteLoading, mutate: deleteFile} = useDeleteFile(projectId)

    // ui actions
    const handleDelete = () => {
        deleteFile({ variables: { id: fileId, projectId: projectId } })
            .then(result => {
                if(!result.data?.delete_files_by_pk?.id) {
                    alert("Error while deleting file with id " + fileId)
                } else {
                    // go to no file selected
                    push(`/project/${projectId}`)
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
                <NavLink to={`/project/${projectId}/file/${fileId}`} className={"no-border-radius btn btn-secondary btn-block"}>
                    {data.files_by_pk.name}
                </NavLink>
                <Dropdown.Toggle split variant="light" id="dropdown-split-basic" className="no-border-radius" />
                <Dropdown.Menu>
                    <RenameFileForm mode={RenameFileFormMode.Dropdown} fileId={fileId} />
                    <Dropdown.Item eventKey="2" onClick={handleDelete} disabled={deleteLoading}>Delete</Dropdown.Item>
                </Dropdown.Menu>
            </Dropdown>
        )
    }
}

export default FileListEntry;