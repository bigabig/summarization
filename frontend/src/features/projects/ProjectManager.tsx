import React, {useState} from "react";
import Form from "react-bootstrap/Form";
import "./styles/ProjectManager.css";

import ProjectTable from "./ProjectTable";
import SearchBar from "./SearchBar";
import AddProjectForm from "./AddProjectForm";
import {Container} from "react-bootstrap";

function ProjectManager() {
    // local state
    const [searchString, setSearchString] = useState("");

    // view
    return (
        <Container>
            <h2>Bigabig's Projects</h2>
            <Form>
                <AddProjectForm />
                <SearchBar searchString={searchString} setSearchString={setSearchString}/>
                <ProjectTable searchString={searchString} />
            </Form>
        </Container>
    );
}

export default ProjectManager;