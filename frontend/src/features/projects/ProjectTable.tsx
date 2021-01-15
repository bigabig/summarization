import React from "react";
import Table from "react-bootstrap/Table";
import Form from "react-bootstrap/Form";
import ProjectTableRow from "./ProjectTableRow";
import {useGetAllProjects} from "./graphql/projectsGraphQL";

type ProjectTableProps = {
    searchString: string
}

function ProjectTable({searchString}: ProjectTableProps) {
    const { loading, error, data } = useGetAllProjects();

    // view
    let content: JSX.Element | JSX.Element[] = []

    if (loading) {
        content = <tr><td colSpan={4}>Loading...</td></tr>
    } else if (error) {
        content = <tr><td colSpan={4}><pre>{JSON.stringify(error, null, 2)}</pre></td></tr>
    } else if (data) {
        content = data.projects
            .filter((project) => project.name.startsWith(searchString))
            .map((project) => (<ProjectTableRow key={project.id} projectId={project.id} />))
    }

    return (
        <Table striped bordered hover className="mb-0 table-fontsize">
            <thead>
            <tr>
                <th className="text-center table-w10"><Form.Check type="checkbox"/></th>
                <th>Title</th>
                <th>Metadata</th>
                <th className="table-w265">Actions</th>
            </tr>
            </thead>
            <tbody>{content}</tbody>
        </Table>
    );
}

export default ProjectTable