import chroma from "chroma-js"

export const heatmap = chroma.scale('OrRd').padding(0.3).mode('rgb');
export const colormap = chroma.scale(['#dc3545', '#28a745']).mode('lrgb');
export const highlightColorMap = chroma.scale(['#e72c3c', '#25d94e']).mode('lrgb');