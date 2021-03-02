import React from "react";
import Tab from "react-bootstrap/Tab";

type EditorPaneProps = {
    children: React.ReactNode
    pill: number
}

function EditorPane({children, pill}: EditorPaneProps) {
    return (
        <Tab.Pane eventKey={"pill-" + pill} className="w-100 h-100">
            {children}
        </Tab.Pane>
    )
}

export default EditorPane;