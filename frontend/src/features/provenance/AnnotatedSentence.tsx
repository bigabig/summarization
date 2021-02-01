import {MyAnnotation} from "../../graphql/types/annotations";
import React from "react";
import parse from 'html-react-parser';

type AnnotatedSentenceProps = {
    annotation: MyAnnotation
    showNER: boolean
}

function AnnotatedSentence({annotation, showNER}: AnnotatedSentenceProps) {

    const render = ({text, ents}: MyAnnotation) => {
        let result = "";
        let offset = 0;

        ents.forEach(({ tag, start, end }) => {
            const entity = text.slice(start, end);
            const fragments = text.slice(offset, start).split('\n');

            fragments.forEach((fragment, i) => {
                result += fragment;
                if(fragments.length > 1 && i !== fragments.length - 1) {
                    result += "<br />";
                }
            });

            if(showNER) {
                result += `<mark data-entity=${tag.toLowerCase()}>${entity}</mark>`
            } else {
                result += entity
            }

            offset = end;
        });

        result += text.slice(offset, text.length)
        return result
    }

    return (
        <>
            {parse(render(annotation))}
        </>
    )
}

export default AnnotatedSentence;