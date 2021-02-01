import {Route, Switch, useParams, useRouteMatch} from "react-router-dom";
import {useGetProjectById} from "../../graphql/projects";
import {useGetFileByIdNew} from "../../graphql/files";
import React, {useEffect, useState} from "react";
// @ts-ignore
import Split from 'react-split';
import FileToolbar from "../files/FileToolbar";
import FileList from "../files/FileList";
import {ProjectAndFileMatch} from "../../graphql/types/ProjectMatch";
import InputWindow from "./InputWindow";
import OutputWindow from "../summaries/OutputWindow";
import useElementSizes from "../../helper/ElementSizes";

export enum Mode {
    Edit,
    Annotation,
    Provenance
}

export function mode2Text(input: Mode) {
    switch (input) {
        case Mode.Edit:
            return "Edit Mode";
        case Mode.Annotation:
            return "Annotation Mode";
        case Mode.Provenance:
            return "Provenance Mode";
        default:
            return "Unkown Mode";
    }
}

type FileEditorProps = {
    left: boolean
    heights: number[],
    mode: Mode
    setMode: React.Dispatch<React.SetStateAction<Mode>>
    sentenceID: number,
    setSentenceID: React.Dispatch<React.SetStateAction<number>>,
}

function FileEditor({left, heights, mode, setMode, sentenceID, setSentenceID}: FileEditorProps) {
    // global url state
    let params = useParams<ProjectAndFileMatch>();
    const projectId: number = Number(params.projectId);
    const fileId: number = Number(params.fileId);

    // local state
    const [height, mainNav, inputNav, inputFooterNav, outputNav, outputFooterNav] = heights;

    // remote state
    const {loading: fileLoading, error: fileError, data: fileData} = useGetFileByIdNew({id: fileId, projectId: projectId})

    useEffect(() => {
        setSentenceID(-1); // reset the selected provenance sentence whenever the file changes
        window.dispatchEvent(new Event('resize'));      // fire the resize event whenever the fileId changes, so that components can calculate the correct heights
    }, [projectId, fileId, setSentenceID])

    return (
        <>
            {fileError && (
                <p>ERROR</p>
            )}
            {fileLoading && (
                <p>Loading Indicator</p>
            )}
            {!fileError && !fileLoading && !fileData && (
                <p>This file does not exist.</p>
            )}
            {!fileError && !fileLoading && fileData && (
                <div>
                    {left && (
                        <InputWindow height={(height - mainNav - inputNav - inputFooterNav)}
                                     mode={mode}
                                     setMode={setMode}
                                     sentenceID={sentenceID} />
                    )}
                    {!left && (
                        <OutputWindow height={(height - mainNav - outputNav - outputFooterNav)}
                                      mode={mode}
                                      sentenceID={sentenceID}
                                      setSentenceID={setSentenceID} />
                    )}
                </div>
            )}
        </>
    )
}


type ProjectMatch = {
    projectId: string
}

function Editor() {
    // global url state
    const match = useRouteMatch<ProjectMatch>()
    const projectId: number = Number(match.params.projectId);

    // local state
    const [height, mainNav, fileNav, inputNav, inputFooterNav, outputNav, outputFooterNav] = useElementSizes();
    const [editorMode, setEditorMode] = useState<Mode>(Mode.Edit)
    const [sentenceID, setSentenceID] = useState(-1);

    // remote state
    const {loading: projectLoading, error: projectError, data: projectData} = useGetProjectById({id: projectId})

    return (
        <>
            {projectError && (
                <p>ERROR</p>
            )}
            {projectLoading && (
                <p>Loading Indicator</p>
            )}
            {!projectError && !projectLoading && !projectData && (
                <p>This project does not exist.</p>
            )}
            {!projectError && !projectLoading && projectData && (
                <Split className="wrap" sizes={[12, 44, 44]}>
                    <div className="comp">
                        <FileToolbar />
                        <FileList height={(height - mainNav - fileNav)} />
                        {/*<ul>*/}
                        {/*    <li>*/}
                        {/*        <NavLink to={`${match.url}/all`} className={"no-border-radius btn btn-primary btn-block"}>ALL</NavLink>*/}
                        {/*    </li>*/}
                        {/*    <li>*/}
                        {/*        <NavLink to={`${match.url}/file/1`} className={"no-border-radius btn btn-primary btn-block"}>File 1</NavLink>*/}
                        {/*    </li>*/}
                        {/*    <li>*/}
                        {/*        <NavLink to={`${match.url}/file/3`} className={"no-border-radius btn btn-primary btn-block"}>File 3</NavLink>*/}
                        {/*    </li>*/}
                        {/*    <li>*/}
                        {/*        <NavLink to={`${match.url}/file/5`} className={"no-border-radius btn btn-primary btn-block"}>File 5</NavLink>*/}
                        {/*    </li>*/}
                        {/*    <li>*/}
                        {/*        <NavLink to={`${match.url}/file/7`} className={"no-border-radius btn btn-primary btn-block"}>File 7</NavLink>*/}
                        {/*    </li>*/}
                        {/*    <li>*/}
                        {/*        <NavLink to={`${match.url}/file/10`} className={"no-border-radius btn btn-primary btn-block"}>File 10</NavLink>*/}
                        {/*    </li>*/}
                        {/*    <li>*/}
                        {/*        <NavLink to={`${match.url}/file/a`} className={"no-border-radius btn btn-primary btn-block"}>File A</NavLink>*/}
                        {/*    </li>*/}
                        {/*    <li>*/}
                        {/*        <NavLink to={`${match.url}/file/100`} className={"no-border-radius btn btn-primary btn-block"}>File 100</NavLink>*/}
                        {/*    </li>*/}
                        {/*    <li>*/}
                        {/*        <NavLink to={"/project/1"} className={"no-border-radius btn btn-primary btn-block"}>Project 1</NavLink>*/}
                        {/*    </li>*/}
                        {/*    <li>*/}
                        {/*        <NavLink to={"/project/a"} className={"no-border-radius btn btn-primary btn-block"}>Project A</NavLink>*/}
                        {/*    </li>*/}
                        {/*    <li>*/}
                        {/*        <NavLink to={"/project/1000"} className={"no-border-radius btn btn-primary btn-block"}>Project 1000</NavLink>*/}
                        {/*    </li>*/}
                        {/*</ul>*/}
                    </div>

                    <Switch>
                        <Route path={`${match.path}/file/:fileId`}>
                            <div className="comp">
                                <FileEditor left={true}
                                            heights={[height, mainNav, inputNav, inputFooterNav, outputNav, outputFooterNav]}
                                            mode={editorMode}
                                            setMode={setEditorMode}
                                            sentenceID={sentenceID}
                                            setSentenceID={setSentenceID}
                                />
                            </div>

                            <div className="comp">
                                <FileEditor left={false}
                                            heights={[height, mainNav, inputNav, inputFooterNav, outputNav, outputFooterNav]}
                                            mode={editorMode}
                                            setMode={setEditorMode}
                                            sentenceID={sentenceID}
                                            setSentenceID={setSentenceID}
                                />
                            </div>
                        </Route>

                        <Route path={`${match.path}/all`}>
                            <div className="comp">
                                <p>ALL</p>
                            </div>

                            <div className="comp">
                                <p>ALL</p>
                            </div>
                        </Route>

                        <Route path={match.path}>
                            <div className="comp">
                                <h3>Please select a file.</h3>
                            </div>

                            <div className="comp">
                                <h3>Please select a file.</h3>
                            </div>
                        </Route>

                    </Switch>

                </Split>
            )}
        </>
    )
}

export default Editor;