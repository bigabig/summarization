import React, {ChangeEvent, useState} from "react";
import {useAddProject} from "../../graphql/projects";
import InputGroup from "react-bootstrap/InputGroup";
import Button from "react-bootstrap/Button";
import FormControl from "react-bootstrap/FormControl";
import {FontAwesomeIcon} from "@fortawesome/react-fontawesome";
import {faFile} from "@fortawesome/free-solid-svg-icons";

function AddProjectForm() {
    // local state
    const [projectString, setProjectString] = useState("");

    // remote actions
    const {mutate: addProject, loading, error } = useAddProject()

    // ui actions
    const handleChange = (event: ChangeEvent<HTMLInputElement>) => {
        setProjectString(event.target.value)
    }

    // actions
    const onClickAddProject = () => {
        addProject({
            variables: {
                name: projectString
            }
        }).then(_ => {
            setProjectString('');
        });
    };

    // view
    return (
        <InputGroup className="mb-5">
            <InputGroup.Prepend>
                <InputGroup.Text id="basic-addon1"><FontAwesomeIcon icon={faFile} /></InputGroup.Text>
            </InputGroup.Prepend>
            <FormControl
                placeholder="Enter project name..."
                aria-label="project name"
                aria-describedby="basic-addon2"
                value={projectString}
                onChange={handleChange}
            />
            <InputGroup.Append>
                <Button variant="success" disabled={projectString.length === 0 || loading} onClick={onClickAddProject}>
                    Create Project
                </Button>
                {error && (
                    <p>{error.message}</p>
                )}
            </InputGroup.Append>
        </InputGroup>
    );
}

export default AddProjectForm;