import {useParams} from "react-router-dom";
import {ProjectMatch} from "../../types/ProjectMatch";
import {useGetAllFiles} from "../../graphql/files";
import React, {useContext, useState} from "react";
import {FontAwesomeIcon} from "@fortawesome/react-fontawesome";
import {faPlay} from "@fortawesome/free-solid-svg-icons";
import ProvenanceViewer from "../provenance/ProvenanceViewer";
import TripleViewer from "../provenance/TripleViewer";
import Graph from "../graph/Graph";
// @ts-ignore
import Split from 'react-split';
import {GetAllFiles} from "../../types/files-generated-types";
import axios, {AxiosResponse} from "axios";
import {NewSummarizationResult} from "../../types/results";
import {useGetProjectById, useUpdateProjectById} from "../../graphql/projects";
import EditorWrapper from "../basic_editor/EditorWrapper";
import EditorPane from "../basic_editor/EditorPane";
import EditorContent from "../basic_editor/EditorContent";

const AllFilesContext = React.createContext<GetAllFiles>({files: []});

type TestComponentProps = {
    name: string
}

const TestComponent = ({name}: TestComponentProps) => {
    return (
        <p>{name}</p>
    )
}

const withFilesData = (Component: any) => ({...props}) => {
    return (
        <Component {...props} />
    )
}


type FilesExistWrapperProps = {
    children: React.ReactNode
}

export function FilesExistWrapper({children}: FilesExistWrapperProps) {
    // global url state
    let params = useParams<ProjectMatch>();
    const projectId: number = Number(params.projectId);

    // remote state
    const {loading: filesLoading, error: filesError, data: filesData} = useGetAllFiles({_eq: projectId})

    return (
        <>
            {filesError && (
                <p>ERROR</p>
            )}
            {filesLoading && (
                <p>Loading Indicator</p>
            )}
            {!filesError && !filesLoading && !filesData && (
                <p>An unexpected error occured while loading all files of the project with project id {projectId}.</p>
            )}
            {!filesError && !filesLoading && filesData && (
                <div>
                    <AllFilesContext.Provider value={filesData}>
                        {children}
                    </AllFilesContext.Provider>
                </div>
            )}
        </>
    )
}






type AllFileEditorProps = {
}

function AllFileEditor({}: AllFileEditorProps) {
    // global url state
    let params = useParams<ProjectMatch>();
    const projectId: number = Number(params.projectId);

    // context
    const filesData = useContext(AllFilesContext)

    // local state
    const [showNER, setShowNER] = useState(false);
    const [showTriples, setShowTriples] = useState<boolean>(false);
    const [showFaithfulness, setShowFaithfulness] = useState(false);
    const [isSummaryLoading, setIsSummaryLoading] = useState<boolean>(false)
    const [sentenceID, setSentenceID] = useState(-1);
    const [isSummarySentence, setIsSummarySentence] = useState(true);
    const [tripleID, setTripleID] = useState(-1);
    const [isSummaryTriple, setIsSummaryTriple] = useState(true);
    const [sizes, setSizes] = useState([50, 50])

    // TODO: Move into project exists wrapper!
    // remote state
    const {loading: projectLoading, error: projectError, data: projectData} = useGetProjectById({id: projectId})

    // actions
    const handleNerChange = () => {
        setShowNER(!showNER)
        if(!showNER) {
            setShowTriples(false);
            setShowFaithfulness(false);
        }
    }
    const handleTriplesChange = () => {
        setShowTriples(!showTriples);
        if(!showTriples) {
            setShowNER(false);
            setShowFaithfulness(false);
        }
    }
    const handleFaithfulnessChange = () => {
        setShowFaithfulness(!showFaithfulness);
        if(!showFaithfulness) {
            setShowNER(false);
            setShowTriples(false);
        }
    }

    // remote actions
    const {mutate: updateProject} = useUpdateProjectById();

    const mode2text = (mode: number) => {
        switch (mode) {
            case 0:
                return "Provenance"
            case 1:
                return "Triples"
            default:
                return "Unkown"
        }
    }

    const pills2text = (pill: number) => {
        switch (pill) {
            case 0:
                return "Text"
            case 1:
                return "Graph"
            default:
                return "Unkown"
        }
    }

    const isSummarizeButtonDisabled = () => {
        return isSummaryLoading;
    }

    const handleSummarizeButtonClick = async () => {
        // set a loading indicator
        setIsSummaryLoading(true);

        // validate that the data we want to post exists
        if (filesData.files.length === 0) {
            alert("Error: The post data (file content) is undefined!")
            setIsSummaryLoading(false)
            return
        }

        try {
            // do the post request
            let result = await axios.post<any, AxiosResponse<NewSummarizationResult>>("http://localhost:3333/summarizeAll", {
                data: filesData.files.map((value) => {return {text: value.content, id: value.id}}),
                length: 140,
                method: "sshleifer/distilbart-cnn-12-6"
            })

            // check if result contains the data we need
            if(result?.data?.input_document && result?.data?.summary_document) {

                console.log(result)

                // perform some logic with the result data
                await updateProject({
                    variables: {
                        id: projectId,
                        document: result.data.input_document,
                        summary_document: result.data.summary_document,
                    }
                });

                // throw an error if the result does not contain the data we expect
            } else {
                throw new Error("Error while parsing the result from http://localhost:3333/summarize.");
            }

            // display errors that occur during the process as alerts
        } catch (error) {
            if(error?.response?.status && error?.response?.message) {
                alert(error.response.status + ": " + error.response.data.message)
            } else {
                alert(error)
            }

            // finally set the loading indicator
        } finally {
            setIsSummaryLoading(false);
        }
    }

    const onDragEnd = (sizes: number[]) => {
        setSizes(sizes)
    }

    return (
        <EditorWrapper numModes={2}
                       mode2text={mode2text}
                       numPills={2}
                       pill2text={pills2text}
                       toolbarLabels={["NER", "Triples", "Faithfulness"]}
                       toolbarOnChangeFunctions={[handleNerChange, handleTriplesChange, handleFaithfulnessChange]}
                       toolbarChecked={[showNER, showTriples, showFaithfulness]}
                       isButtonDisabled={isSummarizeButtonDisabled}
                       handleButtonClick={handleSummarizeButtonClick}
                       buttonContent={<><FontAwesomeIcon icon={faPlay} /> Summarize</>}
                       height={"500px"}
        >
                <EditorPane pill={0}>

                    <EditorContent mode={0}>
                        <Split className="wrap" sizes={sizes} collapsed={0} minSize={0} onDragEnd={onDragEnd}>

                            <div className="comp">
                                <ProvenanceViewer visualizeSummary={false}
                                                  inputDocument={projectData?.projects_by_pk?.document}
                                                  summaryDocument={projectData?.projects_by_pk?.summary_document}
                                                  sentenceID={sentenceID}
                                                  setSentenceID={setSentenceID}
                                                  isSummarySentence={isSummarySentence}
                                                  setIsSummarySentence={setIsSummarySentence}
                                                  showNER={showNER}
                                                  showTriples={showTriples}
                                                  showFaithfulness={false}
                                />
                            </div>
                            <div className="comp">
                                <ProvenanceViewer visualizeSummary={true}
                                                  inputDocument={projectData?.projects_by_pk?.document}
                                                  summaryDocument={projectData?.projects_by_pk?.summary_document}
                                                  sentenceID={sentenceID}
                                                  setSentenceID={setSentenceID}
                                                  isSummarySentence={isSummarySentence}
                                                  setIsSummarySentence={setIsSummarySentence}
                                                  showNER={showNER}
                                                  showTriples={showTriples}
                                                  showFaithfulness={showFaithfulness}
                                />
                            </div>
                        </Split>
                    </EditorContent>

                    <EditorContent mode={1}>
                        <Split className="wrap" sizes={sizes} collapsed={0} minSize={0} onDragEnd={onDragEnd}>
                            <div className="comp">
                                <TripleViewer
                                    summaryDocument={projectData?.projects_by_pk?.summary_document}
                                    inputDocument={projectData?.projects_by_pk?.document}
                                    visualizeSummary={false}
                                    isSummaryTriple={isSummaryTriple}
                                    setIsSummaryTriple={setIsSummaryTriple}
                                    tripleID={tripleID}
                                    setTripleID={setTripleID}
                                />
                            </div>
                            <div className="comp">
                                <TripleViewer
                                    summaryDocument={projectData?.projects_by_pk?.summary_document}
                                    inputDocument={projectData?.projects_by_pk?.document}
                                    visualizeSummary={true}
                                    isSummaryTriple={isSummaryTriple}
                                    setIsSummaryTriple={setIsSummaryTriple}
                                    tripleID={tripleID}
                                    setTripleID={setTripleID}
                                />
                            </div>
                        </Split>
                    </EditorContent>

                </EditorPane>

                <EditorPane pill={1}>
                    <EditorContent mode={0}>
                        <div className="comp">
                            <p>Graph Provenance</p>
                        </div>
                        <div className="comp">
                            <p>Graph Provenance</p>
                        </div>
                    </EditorContent>

                    <EditorContent mode={1}>
                        <div className="comp">
                            <p>Graph Triples</p>
                        </div>
                        <div className="comp">
                            <p>Graph Triples</p>
                        </div>
                    </EditorContent>
                </EditorPane>


        </EditorWrapper>
    )
}

export default AllFileEditor;