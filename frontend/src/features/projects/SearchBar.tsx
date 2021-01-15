import InputGroup from "react-bootstrap/InputGroup";
import {FontAwesomeIcon} from "@fortawesome/react-fontawesome";
import {faSearch} from "@fortawesome/free-solid-svg-icons";
import FormControl from "react-bootstrap/FormControl";
import Button from "react-bootstrap/Button";
import React from "react";

type SearchBarProps = {
    searchString: string,
    setSearchString: (value: string) => void,
}

function SearchBar(props: SearchBarProps) {
    return (
        <InputGroup className="mb-3">
            <InputGroup.Prepend>
                <InputGroup.Text id="basic-addon1"><FontAwesomeIcon icon={faSearch} /></InputGroup.Text>
            </InputGroup.Prepend>
            <FormControl
                placeholder="Search projects..."
                aria-label="search"
                aria-describedby="basic-addon1"
                value={props.searchString}
                onChange={(event) => props.setSearchString(event.target.value)}
            />
            <InputGroup.Append>
                <Button variant="outline-danger" onClick={() => props.setSearchString("")}>x</Button>
            </InputGroup.Append>
        </InputGroup>
    );
}

export default SearchBar;