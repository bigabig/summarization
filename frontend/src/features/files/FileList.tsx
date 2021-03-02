import React, {CSSProperties} from "react";
import FileListEntry from "./FileListEntry";
import {useGetFilesByProjectId} from "../../graphql/files";
import {NavLink, useRouteMatch} from "react-router-dom";
import {ProjectMatch} from "../../types/ProjectMatch";

type FileListProps = {
    height: number,
}

function FileList({ height }: FileListProps) {
    const match = useRouteMatch<ProjectMatch>();
    const projectId: number = Number(match.params.projectId);

    // remote state
    const { loading, error, data } = useGetFilesByProjectId({_eq: projectId});

    // view
    let content: JSX.Element | JSX.Element[] = []

    if (loading) {
        content = <div>Loading...</div>
    } else if (error) {
        content = <div><pre>{JSON.stringify(error, null, 2)}</pre></div>
    } else if (data?.files && data?.files.length > 0) {
        content = data.files
            .map((file) => (<FileListEntry key={file.id} fileId={file.id}/>))
        content.unshift(<NavLink
                            to={`/project/${projectId}/all`}
                            key="all-button"
                            className={"no-border-radius btn btn-primary btn-block"}>
                            ALL
                        </NavLink>)
    }

    // view
    const FileListStyle: CSSProperties = {
        height: height + "px",
        maxHeight: height + "px",
        overflow: "auto",
    }

    return (
        <div className="no-border-radius" style={FileListStyle}>
            {content}
        </div>
    );
}

export default FileList;