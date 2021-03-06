import React from "react";
import { BrowserRouter as Router, Route, Switch, Redirect } from "react-router-dom";
import ProjectManager from "./features/projects/ProjectManager";
import Navigation from "./features/navigation/Navigation";
import Editor from "./features/editor/Editor";
import DocumentEditor from "./features/editor/DocumentEditor";

function App() {
    return (
        <Router>
            <Navigation />
            <Switch>
                <Route path="/projects" component={ProjectManager} />
                <Route path={"/project/:projectId"} component={Editor} />
                <Route path={"/editor"} component={DocumentEditor} />
                <Redirect to="/projects" />
            </Switch>
        </Router>
    )
}

export default App;