import React from "react";
import { BrowserRouter as Router, Route, Switch, Redirect } from "react-router-dom";
import ProjectManager from "./features/projects/ProjectManager";
import Navigation from "./features/navigation/Navigation";
import Editor from "./features/editor/Editor";

function App() {
    return (
        <Router>
            <Navigation />
            <Switch>
                <Route path="/projects" component={ProjectManager} />
                <Route path={"/project/:projectId"} component={Editor} />
                <Redirect to="/projects" />
            </Switch>
        </Router>
    )
}

export default App;