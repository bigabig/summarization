import React, {useContext} from "react";
import {ModeContext} from "./ModeContext";

type EditorContentProps = {
    children: React.ReactNode
    mode: number
}

function EditorContent({children, mode}: EditorContentProps)  {
    const currentMode = useContext(ModeContext)

    return (
        <>
            {currentMode === mode && (
                <>
                    {children}
                </>
            )}
        </>
    )
}

export default EditorContent;