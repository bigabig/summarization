import OverlayTrigger from "react-bootstrap/OverlayTrigger";
import Tooltip from "react-bootstrap/Tooltip";
import Button from "react-bootstrap/Button";
import {FontAwesomeIcon} from "@fortawesome/react-fontawesome";
import {faTrash} from "@fortawesome/free-solid-svg-icons";
import React from "react";
import {useHistory, useRouteMatch} from "react-router-dom";
import {useDeleteFile, useGetFileByIdNew} from "../../graphql/files";
import {ProjectAndFileMatch, ProjectMatch} from "../../graphql/types/ProjectMatch";

function DeleteFileButton() {
    // global url state
    const projectMatch = useRouteMatch<ProjectMatch>();
    const fileMatch = useRouteMatch<ProjectAndFileMatch>("/project/:projectId/file/:fileId");
    const projectId: number = Number(projectMatch.params.projectId)
    const fileId: number = Number(fileMatch?.params.fileId);

    // check if file exists: yes: fileData no: !fileData
    const {data: fileData} = useGetFileByIdNew({id: fileId, projectId: projectId})

    const {push} = useHistory();

    // remote actions
    const { loading: deleteLoading, mutate: deleteFile} = useDeleteFile(projectId)

    const handleDelete = () => {
        if (fileData) {
            deleteFile({ variables: { id: fileId, projectId: projectId} })
                .then(result => {
                    if(!result.data?.delete_files_by_pk?.id) {
                        alert(`Error while deleting file with id ${fileId}`)
                    } else {
                        // go to no file selected
                        push(`/project/${projectId}`)
                    }
                })
                .catch(error => {
                    alert(error)
                })
        }
    }

    return (
        <OverlayTrigger transition={false}  placement="right" overlay={
            <Tooltip id="tooltip-add-file">Delete selected file</Tooltip>
        } >
            {({ ref, ...triggerHandler }) => (
                <div style={{display: 'inline-block', cursor: 'not-allowed'}} {...triggerHandler}>
                    <Button ref={ref}
                            variant="light"
                            onClick={handleDelete}
                            disabled={deleteLoading || !fileData}
                            style={deleteLoading || !fileData ? {pointerEvents: 'none'} : {}}>
                        <FontAwesomeIcon icon={faTrash}/>
                    </Button>
                </div>
            )}
        </OverlayTrigger>
    )
}

export default DeleteFileButton;