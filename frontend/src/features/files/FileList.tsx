import React, {CSSProperties} from "react";
import Button from "react-bootstrap/Button";
import FileListEntry from "./FileListEntry";
import {useGetFilesByProjectId} from "./graphql/filesGraphQL";
import {GlobalEditorState} from "../editor/Editor";

type FileListProps = {
    height: number,
    editorState: GlobalEditorState,
}

function FileList({ height, editorState }: FileListProps) {
    const FileListStyle: CSSProperties = {
        height: height + "px",
        maxHeight: height + "px",
        overflow: "auto",
    }

    // remote state
    const { loading, error, data } = useGetFilesByProjectId({_eq: editorState.state.projectId});

    // view
    let content: JSX.Element | JSX.Element[] = []

    if (loading) {
        content = <div>Loading...</div>
    } else if (error) {
        content = <div><pre>{JSON.stringify(error, null, 2)}</pre></div>
    } else if (data) {
        content = data.files
            .map((file) => (<FileListEntry key={file.id} fileId={file.id} editorState={editorState}/>))
    }

    return (
        <div className="no-border-radius" style={FileListStyle}>
            <Button variant="light" className="no-border-radius" block active>ALL</Button>
            {content}
        </div>
    );
}

export default FileList;