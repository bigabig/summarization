import {MyTriple} from "../../graphql/types/annotations";
import {useState} from "react";
import parse from 'html-react-parser';

export type TripleSentenceProps = {
    triple: MyTriple,
    onSelect: (arg0: boolean) => void
}

function TripleSentence({triple, onSelect}: TripleSentenceProps) {
    // local state
    const [verbID, setVerbID] = useState(-1)
    const [isHidden, setIsHidden] = useState(false);

    // ui actions
    const handleClickVerb = (id:number) => {
        if(id === verbID) {
            if(isHidden) {
                setVerbID(id)
                setIsHidden(false)
                onSelect(true)
            } else {
                setVerbID(-1);
                setIsHidden(true);
                onSelect(false)
            }
        } else {
            setVerbID(id);
            setIsHidden(false);
            onSelect(true)
        }
    }

    // render annotation
    let result: string = "";
    if(verbID >=0 && triple.verbs.length > 0) {
        // zip words and tags
        let wordTagPairs = triple.words.map((value, index) => {return {word: value, tag: triple.verbs[verbID].tags[index]}});

        let sequences = []
        let sequence_tag = "";
        let sequence_string = "";

        let last_value = ''
        wordTagPairs.forEach(({word, tag}) => {
            let iob: string;
            let value: string;

            if(tag === 'O') {
                iob = "O";
                value = "O";
            } else {
                iob = tag.split("-")[0]
                value = tag.slice(iob.length + 1)
            }

            if(iob === 'B') {
                if(last_value !== "") {
                    sequences.push({
                        tag: sequence_tag,
                        string: sequence_string,
                    })
                    sequence_tag = "";
                    sequence_string = "";
                }
                sequence_tag = value;
                sequence_string += word;
            } else if(iob === 'I' && last_value === value) {
                sequence_string += " " + word
            } else if(iob === 'O') {
                if(last_value !== 'O' && last_value !== "") {
                    sequences.push({
                        tag: sequence_tag,
                        string: sequence_string,
                    })
                    sequence_tag = value;
                    sequence_string = word;
                } else {
                    sequence_tag = value;
                    sequence_string += " " + word;
                }
            }

            last_value = value;
        })
        sequences.push({
            tag: sequence_tag,
            string: sequence_string,
        })

        sequences.forEach((value, index) => {
            if(value.tag === 'V') {
                result += `<mark data-entity=${value.tag.toLowerCase()} onClick="handleClickVerb(0)" data-active=${true} data-id=${verbID} data-value=${value.string}>${value.string}</mark>`;
            } else if (value.tag === 'O') {
                result += value.string;
            } else {
                result += `<mark data-entity=${value.tag.toLowerCase()}>${value.string}</mark>`
            }
        })
    } else if(triple.verbs.length > 0) {
        let verbs = triple.verbs.map(v => v.verb)
        triple.words.forEach((word, id) => {
            let index = verbs.indexOf(word)
            if(index !== -1) {
                result += `<mark data-entity='v' onClick="handleClickVerb(0)" data-id=${index} data-value=${word}>${word} </mark>`
            } else {
                result += word + " "
            }
        });
    } else {
        result += triple.words.join(" ")
    }

    return (
        <>
            {parse(result, {
                replace: domNode => {
                    if (domNode.name === 'mark' && domNode.attribs.onclick) {
                        delete domNode.attribs.onclick;
                        return (
                            <mark
                                {...domNode.attribs}
                                className={domNode.attribs["data-active"] ? 'active-verb' : ''}
                                onClick={(e) => { handleClickVerb(Number(domNode.attribs["data-id"])); e.stopPropagation(); }}
                            >
                                {domNode.attribs["data-value"]}
                            </mark>
                        );
                    }
                }
            })}
        </>
    )
}

export default TripleSentence;