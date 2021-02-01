import Navbar from "react-bootstrap/Navbar";
import React from "react";
import {useGetProjectById} from "../../graphql/projects";

type ProjectNameDisplayerProps = {
    id: number
}

function ProjectNameDisplayer({id}: ProjectNameDisplayerProps) {
    const {loading, error, data} = useGetProjectById({id})

    return (
        <>
            {loading && (
                <Navbar.Brand className="mr-auto">Loading...</Navbar.Brand>
            )}
            {error && (
                <Navbar.Brand className="mr-auto">{error}</Navbar.Brand>
            )}
            {!data && (
                <Navbar.Brand className="mr-auto">This project does not exist!</Navbar.Brand>
            )}
            {!loading && !error && data && (
                <Navbar.Brand className="mr-auto">{data?.projects_by_pk?.name}</Navbar.Brand>
            )}
        </>
    );
}

export default ProjectNameDisplayer;