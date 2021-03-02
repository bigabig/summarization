import {Span} from "../../types/annotations";
import React from "react";
import parse from 'html-react-parser';
import {Sentence} from "../../types/sentence";

type AnnotatedSentenceProps = {
    sentence: Sentence
}

function AnnotatedSentence({sentence}: AnnotatedSentenceProps) {

    const render = (text: string, ents: Span[]) => {
        console.log(ents)
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

            result += `<mark data-entity=${tag.toLowerCase()}>${entity}</mark>`

            offset = end;
        });

        result += text.slice(offset, text.length)
        return result
    }

    return (
        <>
            {parse(render(sentence.text, sentence.ents))}
        </>
    )
}

export default AnnotatedSentence;