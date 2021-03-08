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
import ButtonGroup from "react-bootstrap/esm/ButtonGroup";
import OverlayTrigger from "react-bootstrap/esm/OverlayTrigger";
import Tooltip from "react-bootstrap/esm/Tooltip";
import {FontAwesomeIcon} from "@fortawesome/react-fontawesome";
import {faInfo, faInfoCircle} from "@fortawesome/free-solid-svg-icons";


type EditorWrapperProps = {
    children: React.ReactNode
    numModes: number,
    mode2text: (arg: number) => string
    mode2info: (arg: number) => string
    numPills: number,
    pill2text: (arg: number) => string
    toolbarLabels: string[],
    toolbarOnChangeFunctions: (() => void)[],
    toolbarChecked: boolean[],
    isButtonDisabled: () => boolean,
    handleButtonClick: () => void,
    buttonContent: React.ReactNode,
    height: string,
    faithfulnessMode: boolean,
    setFaithfulnessMode: React.Dispatch<React.SetStateAction<boolean>>,
}

export function EditorWrapper({children, numModes, numPills, mode2text, mode2info, pill2text, toolbarLabels, toolbarChecked, toolbarOnChangeFunctions, isButtonDisabled, handleButtonClick, buttonContent, height, faithfulnessMode, setFaithfulnessMode}: EditorWrapperProps) {
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
        <OverlayTrigger
            key={index}
            placement={'right'}
            overlay={
                <Tooltip key={index} id={`tooltip-info`}>
                    {mode2info(m)}
                </Tooltip>
            }
        >
            <Dropdown.Item key={index} active={mode === index} onClick={() => setMode(m)} eventKey="pill-0">
                {mode2text(m)}
            </Dropdown.Item>
        </OverlayTrigger>

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

    const calcButtonVariant = (faithful: boolean) => {
        if(faithful === faithfulnessMode) {
            return "primary"
        } else {
            return "light"
        }
    }


    const ContentStyle: CSSProperties = {
        height: height,
        maxHeight: height
    }
    return (
        <ModeContext.Provider value={mode}>
            <Tab.Container id="input-tabs" defaultActiveKey="pill-0">
                <nav id="input-navigation" className="navbar navbar-expand-lg navbar-light bg-light">
                    {navPills.length > 0 && (
                        <Nav variant="pills" className="mr-auto" style={NavStyle}>
                            {navPills}
                        </Nav>
                    )}
                    <ButtonGroup aria-label="Basic example" className="mr-auto">
                        <Button variant={calcButtonVariant(true)} onClick={() => setFaithfulnessMode(true)}>Faithfulness</Button>
                        <Button variant={calcButtonVariant(false)} onClick={() => setFaithfulnessMode(false)}>Coverage</Button>
                    </ButtonGroup>

                    <DropdownButton variant="outline-secondary" id="dropdown-basic-button" title={mode2text(mode)} className="mr-auto">
                        {modeDropdowns}
                    </DropdownButton>
                    <FaithfulnessSettingsVisualizer name={"tim"} />
                    {buttonContent && (
                        <Button variant="success" className={"ml-2"} disabled={isButtonDisabled()} onClick={handleButtonClick}>
                            {buttonContent}
                        </Button>
                    )}
                </nav>
                <Tab.Content id="input-content" style={ContentStyle}>
                    {children}
                </Tab.Content>
            </Tab.Container>
            <Navbar id="input-footer-navigation" expand="lg" variant="light" bg="secondary">
                <Navbar.Brand>
                    <Form inline>
                        {toolbarForms}
                    </Form>
                </Navbar.Brand>
            </Navbar>
        </ModeContext.Provider>
    );
}

export default EditorWrapper;