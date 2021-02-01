import {FontAwesomeIcon} from "@fortawesome/react-fontawesome";
import {faGlobe} from "@fortawesome/free-solid-svg-icons";
import React from "react";
import Navbar from "react-bootstrap/Navbar";
import { useRouteMatch } from "react-router-dom";
import AccountManager from "./AccountManager";
import ProjectNameDisplayer from "./ProjectNameDisplayer";
import Button from "react-bootstrap/Button";
import {faArrowUp} from "@fortawesome/free-solid-svg-icons/faArrowUp";
import {keycloak} from "../../api/keycloak";
import {useApolloClient} from "@apollo/client";

type ProjectMatch = {
    projectId: string
}

function Navigation() {
    // get id from route
    const match = useRouteMatch<ProjectMatch>("/project/:projectId");
    const projectId = Number(match?.params.projectId)

    // view
    return (
        <Navbar id="main-navigation" bg="dark" variant="dark" expand="lg">
            <Navbar.Brand className="mr-auto"><FontAwesomeIcon icon={faGlobe} /> LT Webapp</Navbar.Brand>
            {!isNaN(projectId) && (
                <>
                    <ProjectNameDisplayer id={projectId} />
                    <Button variant="outline-danger" href="/projects">Back to projects <FontAwesomeIcon icon={faArrowUp} /></Button>
                </>
            )}
            <AccountManager />
        </Navbar>
    )
}

export default Navigation;