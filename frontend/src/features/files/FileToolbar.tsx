import Navbar from "react-bootstrap/Navbar";
import AddFileForm from "./AddFileForm";
import RenameFileForm, {RenameFileFormMode} from "./RenameFileForm";
import React from "react";
import DeleteFileButton from "./DeleteFileButton";
import {useRouteMatch} from "react-router-dom";
import {ProjectAndFileMatch, ProjectMatch} from "../../graphql/types/ProjectMatch";

function FileToolbar() {
    // global url state
    const fileMatch = useRouteMatch<ProjectAndFileMatch>("/project/:projectId/file/:fileId");
    const fileId: number = Number(fileMatch?.params.fileId);

    return (
        <Navbar id="file-navigation" bg="light" expand="lg">
            <AddFileForm />
            <RenameFileForm mode={RenameFileFormMode.Button} fileId={fileId} />
            <DeleteFileButton />
        </Navbar>
    )
}

export default FileToolbar;