import React from "react";
import Form from "react-bootstrap/Form";
import Button from "react-bootstrap/Button";
import {useDeleteProject, useGetProjectById } from "./graphql/projectsGraphQL";
import RenameProjectForm from "./RenameProjectForm";

type ProjectTableRowProps = {
    projectId: number,
}

function ProjectTableRow({ projectId }: ProjectTableRowProps) {
    // remote state
    const { loading, error, data } = useGetProjectById({id: projectId});

    // remote actions
    const {mutate: deleteProject, loading: mutationLoading, error: mutationError } = useDeleteProject()

    // actions
    const onClickDeleteProject = () => {
        if (data?.projects_by_pk) {
            deleteProject({variables: {id: data.projects_by_pk.id}})
                .then(_ => {})
        }
    }

    // view
    if (loading) {
        return (
            <tr><td colSpan={4}>
                Loading...
            </td></tr>
        )
    } else if (error) {
        return (
            <tr><td colSpan={4}><pre>
                Error in GET_PROJECT_BY_ID_QUERY
                {JSON.stringify(error, null, 2)}
            </pre></td></tr>
        )
    } else if (!data?.projects_by_pk) {
        return (
            <tr><td colSpan={4}>
                The project with id {projectId} does not exist!
            </td></tr>
        )
    } else {
        return (
            <tr>
                <td className="text-center align-middle"><Form.Check type="checkbox"/></td>
                <td className="align-middle">{data.projects_by_pk.name}</td>
                <td className="align-middle">Last modified 21 days ago</td>
                <td className="align-middle">
                    <Button variant="success" className="mr-2" disabled={mutationLoading} href={'/project/'+data.projects_by_pk.id}>Open</Button>
                    <RenameProjectForm project={data.projects_by_pk} />
                    <Button variant="danger" className="ml-2" disabled={mutationLoading} onClick={onClickDeleteProject}>Delete</Button>
                    {mutationError && (
                        <p>{mutationError.message}</p>
                    )}
                </td>
            </tr>
        )
    }
}

export default ProjectTableRow