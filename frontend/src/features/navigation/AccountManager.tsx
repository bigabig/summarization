import {keycloak} from "../../api/keycloak";
import Nav from "react-bootstrap/Nav";
import {NavDropdown} from "react-bootstrap";
import Button from "react-bootstrap/Button";
import {FontAwesomeIcon} from "@fortawesome/react-fontawesome";
import {faSignInAlt} from "@fortawesome/free-solid-svg-icons";
import React, {useEffect, useState} from "react";

function AccountManager() {
    // local state
    const [name, setName] = useState("unknown");
    const [mail, setMail] = useState("unknown");

    // actions
    const handleLogout = () => {
        keycloak.logout();
    }
    const handleAccount = () => {
        keycloak.accountManagement()
    }

    // get the user profile once
    useEffect(() => {
        keycloak.loadUserProfile().then(profile => {
            if(profile.email) {
                setMail(profile.email);
            }
            if(profile.firstName && profile.lastName) {
                setName(profile.firstName + " " + profile.lastName);
            }
        })
    });

    // view
    return (
        <Nav>
            <NavDropdown title={"👤 " + name} id="account-dropdown" alignRight style={{position: "initial"}} active>
                <div className="dropdown-item">
                    <div style={{float: "left"}}>
                        <img alt="profile" src="https://www.w3schools.com/w3css/img_avatar3.png" style={{width: "105px", borderRadius: "0.5rem"}} />
                    </div>
                    <div  style={{float: "left", paddingLeft: "1rem"}}>
                        <p className="text-left"><strong>{name}</strong></p>
                        <p className="text-left small">{mail}</p>
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
    )
}

export default AccountManager;