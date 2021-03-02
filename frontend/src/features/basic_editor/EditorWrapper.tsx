import React, {CSSProperties, useState} from "react";
import Tab from "react-bootstrap/Tab";
import Nav from "react-bootstrap/Nav";
import Dropdown from "react-bootstrap/Dropdown";
import Form from "react-bootstrap/Form";
import DropdownButton from "react-bootstrap/DropdownButton";
import Button from "react-bootstrap/Button";
import Navbar from "react-bootstrap/Navbar";
import {ModeContext} from "./ModeContext";
import FaithfulnessSettingsVisualizer from "../settings/FaithfulnessSettingsVisualizer";


type EditorWrapperProps = {
    children: React.ReactNode
    numModes: number,
    mode2text: (arg: number) => string
    numPills: number,
    pill2text: (arg: number) => string
    toolbarLabels: string[],
    toolbarOnChangeFunctions: (() => void)[],
    toolbarChecked: boolean[],
    isButtonDisabled: () => boolean,
    handleButtonClick: () => void,
    buttonContent: React.ReactNode,
    height: string
}

export function EditorWrapper({children, numModes, numPills, mode2text, pill2text, toolbarLabels, toolbarChecked, toolbarOnChangeFunctions, isButtonDisabled, handleButtonClick, buttonContent, height}: EditorWrapperProps) {
    const modes: number[] = Array.from(Array(numModes).keys())
    const pills: number[] = Array.from(Array(numPills).keys())

    // local state
    const [mode, setMode] = useState(0)

    const NavStyle: CSSProperties = {
        fontSize: '1rem',
        textAlign: "center",
    }

    const navPills = pills.map((pill, index) => (
        <Nav.Item key={index}>
            <Nav.Link key={index} eventKey={"pill-"+pill}>{pill2text(pill)}</Nav.Link>
        </Nav.Item>
    ))

    const modeDropdowns = modes.map((m, index) => (
        <Dropdown.Item key={index} active={mode === index} onClick={() => setMode(m)} eventKey="pill-0">{mode2text(m)}</Dropdown.Item>
    ))

    const toolbarForms = toolbarLabels.map((label: string, index: number) => (
        <Form.Check
            className="mr-4"
            key={label}
            type="switch"
            id={"id-"+label}
            label={label}
            onChange={toolbarOnChangeFunctions[index]}
            checked={toolbarChecked[index]}
        />
    ))

    const ContentStyle: CSSProperties = {
        height: height,
        maxHeight: height
    }
    return (
        <>
            <Tab.Container id="input-tabs" defaultActiveKey="pill-0">
                <nav id="input-navigation" className="navbar navbar-expand-lg navbar-light bg-light">
                    <Nav variant="pills" className="mr-auto" style={NavStyle}>
                        {navPills}
                    </Nav>
                    <DropdownButton variant="outline-secondary" id="dropdown-basic-button" title={mode2text(mode)} className="mr-auto">
                        {modeDropdowns}
                    </DropdownButton>
                    <FaithfulnessSettingsVisualizer name={"tim"} />
                    {buttonContent && (
                        <Button variant="success" disabled={isButtonDisabled()} onClick={handleButtonClick}>
                            {buttonContent}
                        </Button>
                    )}
                </nav>
                <Tab.Content id="input-content" style={ContentStyle}>
                    <ModeContext.Provider value={mode}>
                        {children}
                    </ModeContext.Provider>
                </Tab.Content>
            </Tab.Container>
            <Navbar id="input-footer-navigation" expand="lg" variant="light" bg="secondary">
                <Navbar.Brand>
                    <Form inline>
                        {toolbarForms}
                    </Form>
                </Navbar.Brand>
            </Navbar>
        </>
    );
}

export default EditorWrapper;