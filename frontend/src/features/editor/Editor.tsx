import FileBrowser from "../files/FileBrowser";
import InputWindow from "./InputWindow";
import OutputWindow from "../summaries/OutputWindow";
import React, {useEffect, useLayoutEffect, useState} from "react";
import useElementSizes from "../../helper/ElementSizes";
// @ts-ignore
import Split from 'react-split';
import {Redirect, Route, RouteComponentProps, Switch, useParams, useRouteMatch} from "react-router-dom";
import {ProjectAndFileMatch, ProjectMatch} from "../../graphql/types/ProjectMatch";
import {useGetProjectById} from "../../graphql/projects";
import {useGetFileById, useGetFileByIdNew} from "../../graphql/files";

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

interface Props extends RouteComponentProps<ProjectAndFileMatch> {
}

/**
 * this component makes sure that the URL parameters projectId and fileId are valid and correspond to existing projects and files, respectively.
 */
function Editor({match}: Props) {
    const params = match.params;
    const [fileId, setFileId] = useState<number>(-1);
    const [projectId, setProjectId] = useState<number>(-1);
    
    useEffect(() => {
        setProjectId(Number(params.projectId))
        setFileId(Number(params.fileId))
    })
    // const fileId: number = fileId;
    // const fileId: number = 1;
    // const projectId: number = projectId;
    // console.log(fileId);

    // local state
    const [height, mainNav, fileNav, inputNav, inputFooterNav, outputNav, outputFooterNav] = useElementSizes();
    const [editorMode, setEditorMode] = useState<Mode>(Mode.Edit)
    const [sentenceID, setSentenceID] = useState(-1);

    // remote state
    const {loading: projectLoading, error: projectError, data: projectData} = useGetProjectById({id: projectId})
    const {loading: fileLoading, error: fileError, data: fileData} = useGetFileByIdNew({id: fileId, projectId: projectId})

    useEffect(() => {
        setSentenceID(-1); // reset the selected provenance sentence whenever the file changes
        window.dispatchEvent(new Event('resize'));      // fire the resize event whenever the fileId changes, so that components can calculate the correct heights
    }, [projectId, fileId])

    if (!isNaN(projectId) && projectError) console.error(projectError);
    if (!isNaN(fileId) && fileError) console.error(fileError);

    console.log("------------------------------------")
    console.log("Project ID " + projectId)
    console.log("File ID " + fileId)

    // view
    return (
        <>
            {isNaN(projectId) && (
                <p>{params.projectId} is not a valid project ID</p>
            )}

            {!isNaN(projectId) && projectError && (
                <p>A PROJECT ERROR OCCURED: Please check the console with shortcut CTRL + I</p>
            )}

            {!isNaN(projectId) && !projectError && (
                <>
                    {projectLoading && (
                        <p>LOADING INDICATOR HERE PLS :) TODO</p>
                    )}

                    {!projectLoading && !projectData && (
                        <p>This project does not exist</p>
                    )}

                    {!projectLoading && projectData && (

                        <Split className="wrap" sizes={[12, 44, 44]}>
                            <div className="comp">
                                <FileBrowser height={(height - mainNav - fileNav)} />
                            </div>

                            <div className="comp text-center">

                                <Switch>
                                    <Route exact path={`/project/:projectId`}>
                                        <div style={{fontSize: '1rem', color: 'black'}}>
                                            <p>You have no file selected.</p>
                                            <p>Please select a file or add a new file by clicking on the plus icon in the top left corner.</p>
                                        </div>
                                    </Route>

                                    <Route exact path={`/project/:projectId/all`}>
                                        <h3>All view</h3>
                                    </Route>

                                    <Route exact path={`/project/:projectId/file/:fileId`}>

                                        {isNaN(fileId) && (
                                            <p>{params.fileId} is not a valid file ID</p>
                                        )}

                                        {!isNaN(fileId) && fileError && (
                                            <p>A FILE ERROR OCCURED: Please check the console with shortcut CTRL + I</p>
                                        )}

                                        {!isNaN(fileId) && !fileError && (
                                            <>
                                                {fileLoading && (
                                                    <p>LOADING INDICATOR HERE PLS :) TODO</p>
                                                )}

                                                {!fileLoading && !fileData && (
                                                    <p>This file does not exist</p>
                                                )}

                                                {!fileLoading && fileData && (

                                                    <InputWindow height={(height - mainNav - inputNav - inputFooterNav)}
                                                                 mode={editorMode}
                                                                 setMode={setEditorMode}
                                                                 sentenceID={sentenceID}
                                                    />

                                                )}
                                            </>
                                        )}
                                    </Route>

                                    <Redirect to={`/project/${projectId}/`} />
                                </Switch>

                            </div>

                            <div className="comp text-center">
                                {/*<Switch>*/}
                                {/*    <Route exact path={`/project/:projectId/file/:fileId`}>*/}
                                {/*        {!fileData && (*/}
                                {/*            <p>This file does not exist!</p>*/}
                                {/*        )}*/}
                                {/*        {fileData && (*/}
                                {/*            <OutputWindow height={(height - mainNav - outputNav - outputFooterNav)}*/}
                                {/*                          mode={editorMode}*/}
                                {/*                          sentenceID={sentenceID}*/}
                                {/*                          setSentenceID={setSentenceID}*/}
                                {/*            />*/}
                                {/*        )}*/}
                                {/*    </Route>*/}
                                {/*</Switch>*/}
                            </div>
                        </Split>
                    )}
                </>
            )}
        </>
    )
}

export default Editor;