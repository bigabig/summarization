import React from "react";
import FileList from "./FileList";
import FileToolbar from "./FileToolbar";

type FileBrowserProps = {
    height: number,
}

function FileBrowser({height}: FileBrowserProps) {
    return (
        <>
            <FileToolbar />
            <FileList height={height}/>
        </>
    );
}

export default FileBrowser;