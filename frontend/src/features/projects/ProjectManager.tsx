import React, {useEffect, useState} from "react";
import Form from "react-bootstrap/Form";
import "./styles/ProjectManager.css";

import ProjectTable from "./ProjectTable";
import SearchBar from "./SearchBar";
import AddProjectForm from "./AddProjectForm";
import {Container} from "react-bootstrap";
import {keycloak} from "../../api/keycloak";

function ProjectManager() {
    // local state
    const [searchString, setSearchString] = useState("");
    const [name, setName] = useState("unknown");

    // get the user profile once
    useEffect(() => {
        keycloak.loadUserProfile().then(profile => {
            if(profile.firstName && profile.lastName) {
                setName(profile.firstName + " " + profile.lastName);
            }
        })
    });

    // view
    return (
        <Container>
            <h2>{name}'s Projects</h2>
            <Form>
                <AddProjectForm />
                <SearchBar searchString={searchString} setSearchString={setSearchString}/>
                <ProjectTable searchString={searchString} />
            </Form>
        </Container>
    );
}

export default ProjectManager;