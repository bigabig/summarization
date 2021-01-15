import {useLayoutEffect, useState} from "react";

function getElementHeight(id: string) {
    let height = 0;
    let element = document.getElementById(id);
    if (element) {
        height = element.getBoundingClientRect().height;
    }
    return height
}

function getInitialSizes() {
    return [
        window.innerHeight,
        getElementHeight('main-navigation'),
        getElementHeight('file-navigation'),
        getElementHeight('input-navigation'),
        getElementHeight('input-footer-navigation'),
        getElementHeight('output-navigation'),
        getElementHeight('output-footer-navigation'),
    ];
}

function useElementSizes() {
    const [size, setSize] = useState(getInitialSizes());
    useLayoutEffect(() => {
        function updateSize() {
            setSize([
                window.innerHeight,
                getElementHeight('main-navigation'),
                getElementHeight('file-navigation'),
                getElementHeight('input-navigation'),
                getElementHeight('input-footer-navigation'),
                getElementHeight('output-navigation'),
                getElementHeight('output-footer-navigation'),
            ]);
        }
        window.addEventListener('resize', updateSize);
        updateSize();
        return () => window.removeEventListener('resize', updateSize);
    }, []);
    return size;
}

export default useElementSizes;