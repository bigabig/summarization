import FileBrowser from "../files/FileBrowser";
import InputWindow from "./InputWindow";
import OutputWindow from "../summaries/OutputWindow";
import React, {useEffect, useState} from "react";
import useElementSizes from "../../helper/ElementSizes";
// @ts-ignore
import Split from 'react-split';
import { RouteComponentProps } from "react-router-dom";

interface MatchParams {
    id: string;
}

interface Props extends RouteComponentProps<MatchParams> {
}

type EditorState = {
    projectId: number,
    fileId: number | undefined,
}

export type GlobalEditorState = {
    state: EditorState,
    setState: React.Dispatch<React.SetStateAction<EditorState>>
}

function Editor({ match }: Props) {
    const { id } = match.params;
    console.log(id);

    // local state
    const [height, mainNav, fileNav, inputNav, inputFooterNav, outputNav, outputFooterNav] = useElementSizes();
    const [editorState, setEditorState] = useState<EditorState>({
        projectId: Number(id),
        fileId: undefined,
    })
    const globalEditorState: GlobalEditorState = {
        state: editorState,
        setState: setEditorState,
    }

    // fire the resize event whenever the fileId changes, so that components can calculate the correct heights
    useEffect(() => {
        window.dispatchEvent(new Event('resize'));
    }, [editorState.fileId])

    // view
    return (
        <Split class="wrap" sizes={[12, 44, 44]}>
            <div className="comp">
                <FileBrowser height={(height - mainNav - fileNav)} editorState={globalEditorState} />
            </div>
            <div className="comp text-center">
                {!editorState.fileId && (
                    <div style={{fontSize: '1rem', color: 'black'}}>
                        <p>You have no file selected.</p>
                        <p>Please select a file or add a new file by clicking on the plus icon in the top left corner.</p>
                    </div>
                )}
                {editorState.fileId && (
                    <InputWindow height={(height - mainNav - inputNav - inputFooterNav)} fileId={editorState.fileId}/>
                )}
            </div>
            <div className="comp">
                <OutputWindow height={(height - mainNav - outputNav - outputFooterNav)}/>
            </div>
        </Split>
    )
}

export default Editor