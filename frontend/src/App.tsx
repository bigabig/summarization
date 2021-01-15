import React from "react";
import { BrowserRouter as Router, Route, Switch, Redirect } from "react-router-dom";
import Navbar from "react-bootstrap/Navbar";
import {FontAwesomeIcon} from "@fortawesome/react-fontawesome";
import {faArrowUp, faGlobe, faSignInAlt} from "@fortawesome/free-solid-svg-icons";
import ProjectManager from "./features/projects/ProjectManager";
import Login from "./features/users/Login";
import Button from "react-bootstrap/Button";
import Editor from "./features/editor/Editor";
import {keycloak} from "./api/keycloak";
import {NavDropdown} from "react-bootstrap";
import Row from "react-bootstrap/Row";
import Col from "react-bootstrap/Col";
import Nav from "react-bootstrap/Nav";

function App() {
    const handleLogout = () => {
        keycloak.logout();
    }
    const handleAccount = () => {
        // keycloak.register();
        keycloak.accountManagement()
    }

    return (
        <Router>
            <Navbar id="main-navigation" bg="dark" variant="dark" expand="lg">
                <Navbar.Brand><FontAwesomeIcon icon={faGlobe} /> LT Webapp</Navbar.Brand>
                <Navbar.Brand className="mr-auto ml-auto">Project Name Here</Navbar.Brand>
                {/*<Button variant="outline-danger" href="/projects">Back to projects <FontAwesomeIcon icon={faArrowUp} /></Button>*/}
                {/*<Login />*/}
                <Nav>
                    <NavDropdown title="👤 Tim Fischer" id="account-dropdown" alignRight style={{position: "initial"}} active>
                        <div className="dropdown-item">
                            <div style={{float: "left"}}>
                                <img src="https://www.w3schools.com/w3css/img_avatar3.png" style={{width: "105px", borderRadius: "0.5rem"}}></img>
                            </div>
                            <div  style={{float: "left", paddingLeft: "1rem"}}>
                                <p className="text-left"><strong>Tim Fischer</strong></p>
                                <p className="text-left small">tim.s.fischer96@googlemail.com</p>
                                <p className="text-left">
                                    <Button variant="primary" className="w-100" onClick={handleAccount}>Manage Account</Button>
                                </p>
                            </div>
                        </div>
                        <NavDropdown.Divider style={{clear: "both"}} />
                        <div className="dropdown-item">
                            <Button variant="danger" className="w-100" onClick={handleLogout}>Log Out <FontAwesomeIcon icon={faSignInAlt} /></Button>
                        </div>
                    </NavDropdown>
                </Nav>
            </Navbar>
            <Switch>
                <Route exact path="/projects" component={ProjectManager} />
                <Route exact path="/project/:id" component={Editor} />
                <Redirect to="/projects" />
            </Switch>
        </Router>
    )
}

export default App;