import React from "react";
import { BrowserRouter as Router, Route, Switch, Redirect } from "react-router-dom";
import ProjectManager from "./features/projects/ProjectManager";
import Editor from "./features/editor/Editor";
import Navigation from "./features/navigation/Navigation";
import TestEditor from "./features/TestEditor";

function App() {
    return (
        <Router>
            <Navigation />
            <Switch>
                <Route path="/projects" component={ProjectManager} />
                {/*<Route path={["/project/:projectId/file/:fileId", "/project/:projectId/all", "/project/:projectId"]} component={Editor} />*/}
                <Route path={"/project/:projectId"} component={TestEditor} />
                <Redirect to="/projects" />
            </Switch>
        </Router>
    )
}

export default App;