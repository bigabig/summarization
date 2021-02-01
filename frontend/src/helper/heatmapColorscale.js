import chroma from "chroma-js"

const heatmapColorscale = chroma.scale('OrRd').padding(0.3).mode('rgb');

const heatmap = (value) => {
    return heatmapColorscale(value)
}

export default heatmap;