import React from 'react';
import * as d3 from "d3";
import Vector from "../../helper/vector";

class Graph extends React.Component {
    componentDidMount() {
        this.drawGraph();
    }

    drawGraph() {
        let data = {
            "links": [
                {
                    "source": 0,
                    "target": 1,
                    "text": "s",
                    "texts": [
                        "s"
                    ],
                    "weight": 1
                },
                {
                    "source": 2,
                    "target": 3,
                    "text": "s",
                    "texts": [
                        "s"
                    ],
                    "weight": 1
                },
                {
                    "source": 4,
                    "target": 5,
                    "text": "aligned",
                    "texts": [
                        "aligned"
                    ],
                    "weight": 1
                },
                {
                    "source": 6,
                    "target": 7,
                    "text": "hits",
                    "texts": [
                        "hits"
                    ],
                    "weight": 1
                },
                {
                    "source": 8,
                    "target": 9,
                    "text": "polled",
                    "texts": [
                        "polled"
                    ],
                    "weight": 1
                },
                {
                    "source": 10,
                    "target": 11,
                    "text": "compared",
                    "texts": [
                        "compared"
                    ],
                    "weight": 1
                },
                {
                    "source": 12,
                    "target": 13,
                    "text": "hold",
                    "texts": [
                        "hold"
                    ],
                    "weight": 1
                },
                {
                    "source": 14,
                    "target": 15,
                    "text": "ll",
                    "texts": [
                        "ll"
                    ],
                    "weight": 1
                },
                {
                    "source": 16,
                    "target": 17,
                    "text": "offering",
                    "texts": [
                        "offering"
                    ],
                    "weight": 1
                },
                {
                    "source": 18,
                    "target": 7,
                    "text": "crosses",
                    "texts": [
                        "crosses"
                    ],
                    "weight": 1
                },
                {
                    "source": 19,
                    "target": 20,
                    "text": "growing",
                    "texts": [
                        "growing"
                    ],
                    "weight": 1
                },
                {
                    "source": 21,
                    "target": 22,
                    "text": "sustain",
                    "texts": [
                        "sustain"
                    ],
                    "weight": 1
                },
                {
                    "source": 23,
                    "target": 24,
                    "text": "stopped",
                    "texts": [
                        "stopped"
                    ],
                    "weight": 1
                },
                {
                    "source": 19,
                    "target": 25,
                    "text": "added",
                    "texts": [
                        "added"
                    ],
                    "weight": 1
                },
                {
                    "source": 12,
                    "target": 26,
                    "text": "fell",
                    "texts": [
                        "fell"
                    ],
                    "weight": 1
                },
                {
                    "source": 27,
                    "target": 28,
                    "text": "includes",
                    "texts": [
                        "includes"
                    ],
                    "weight": 1
                },
                {
                    "source": 29,
                    "target": 30,
                    "text": "seeking",
                    "texts": [
                        "seeking"
                    ],
                    "weight": 1
                },
                {
                    "source": 31,
                    "target": 32,
                    "text": "cautioned",
                    "texts": [
                        "cautioned"
                    ],
                    "weight": 1
                }
            ],
            "nodes": [
                {
                    "id": 0,
                    "text": "it ’",
                    "texts": [
                        "it ’"
                    ],
                    "weight": 1
                },
                {
                    "id": 1,
                    "text": "that time",
                    "texts": [
                        "that time"
                    ],
                    "weight": 1
                },
                {
                    "id": 2,
                    "text": "’",
                    "texts": [
                        "’"
                    ],
                    "weight": 1
                },
                {
                    "id": 3,
                    "text": "the first friday of the month , when for one ever - so - brief moment the interests of wall street , washington and main street are all aligned on one thing : jobs",
                    "texts": [
                        "the first friday of the month , when for one ever - so - brief moment the interests of wall street , washington and main street are all aligned on one thing : jobs"
                    ],
                    "weight": 1
                },
                {
                    "id": 4,
                    "text": "washington and main street",
                    "texts": [
                        "washington and main street"
                    ],
                    "weight": 1
                },
                {
                    "id": 5,
                    "text": "on one thing : jobs",
                    "texts": [
                        "on one thing : jobs"
                    ],
                    "weight": 1
                },
                {
                    "id": 6,
                    "text": "employment situation for january",
                    "texts": [
                        "employment situation for january"
                    ],
                    "weight": 1
                },
                {
                    "id": 7,
                    "text": "the wires",
                    "texts": [
                        "the wires",
                        "the wires"
                    ],
                    "weight": 2
                },
                {
                    "id": 8,
                    "text": "by dow jones newswires",
                    "texts": [
                        "by dow jones newswires"
                    ],
                    "weight": 1
                },
                {
                    "id": 9,
                    "text": "economists",
                    "texts": [
                        "economists"
                    ],
                    "weight": 1
                },
                {
                    "id": 10,
                    "text": "economists polled",
                    "texts": [
                        "economists polled"
                    ],
                    "weight": 1
                },
                {
                    "id": 11,
                    "text": "to 227,000 jobs added in february",
                    "texts": [
                        "to 227,000 jobs added in february"
                    ],
                    "weight": 1
                },
                {
                    "id": 12,
                    "text": "the unemployment rate",
                    "texts": [
                        "the unemployment rate",
                        "the unemployment rate"
                    ],
                    "weight": 2
                },
                {
                    "id": 13,
                    "text": "steady",
                    "texts": [
                        "steady"
                    ],
                    "weight": 1
                },
                {
                    "id": 14,
                    "text": "we ’",
                    "texts": [
                        "we ’"
                    ],
                    "weight": 1
                },
                {
                    "id": 15,
                    "text": "be offering color commentary before and after the data crosses the wires",
                    "texts": [
                        "be offering color commentary before and after the data crosses the wires"
                    ],
                    "weight": 1
                },
                {
                    "id": 16,
                    "text": "we ’ ll",
                    "texts": [
                        "we ’ ll"
                    ],
                    "weight": 1
                },
                {
                    "id": 17,
                    "text": "color commentary",
                    "texts": [
                        "color commentary"
                    ],
                    "weight": 1
                },
                {
                    "id": 18,
                    "text": "the data",
                    "texts": [
                        "the data"
                    ],
                    "weight": 1
                },
                {
                    "id": 19,
                    "text": "the economy",
                    "texts": [
                        "economy",
                        "the economy"
                    ],
                    "weight": 2
                },
                {
                    "id": 20,
                    "text": "fast enough to sustain robust job growth",
                    "texts": [
                        "fast enough to sustain robust job growth"
                    ],
                    "weight": 1
                },
                {
                    "id": 21,
                    "text": "the u.s . economy",
                    "texts": [
                        "the u.s . economy"
                    ],
                    "weight": 1
                },
                {
                    "id": 22,
                    "text": "robust job growth",
                    "texts": [
                        "robust job growth"
                    ],
                    "weight": 1
                },
                {
                    "id": 23,
                    "text": "more americans",
                    "texts": [
                        "more americans"
                    ],
                    "weight": 1
                },
                {
                    "id": 24,
                    "text": "looking for work",
                    "texts": [
                        "looking for work"
                    ],
                    "weight": 1
                },
                {
                    "id": 25,
                    "text": "120,000 jobs",
                    "texts": [
                        "120,000 jobs"
                    ],
                    "weight": 1
                },
                {
                    "id": 26,
                    "text": "to 8.2 percent , the lowest since january 2009",
                    "texts": [
                        "to 8.2 percent , the lowest since january 2009"
                    ],
                    "weight": 1
                },
                {
                    "id": 27,
                    "text": "those seeking work",
                    "texts": [
                        "those seeking work"
                    ],
                    "weight": 1
                },
                {
                    "id": 28,
                    "text": "the official unemployment tally",
                    "texts": [
                        "the official unemployment tally"
                    ],
                    "weight": 1
                },
                {
                    "id": 29,
                    "text": "those",
                    "texts": [
                        "those"
                    ],
                    "weight": 1
                },
                {
                    "id": 30,
                    "text": "work",
                    "texts": [
                        "work"
                    ],
                    "weight": 1
                },
                {
                    "id": 31,
                    "text": "federal reserve chairman ben bernanke",
                    "texts": [
                        "federal reserve chairman ben bernanke"
                    ],
                    "weight": 1
                },
                {
                    "id": 32,
                    "text": "that the current hiring pace is unlikely to continue without more consumer spending",
                    "texts": [
                        "that the current hiring pace is unlikely to continue without more consumer spending"
                    ],
                    "weight": 1
                }
            ]
        };

        let color = (d) => {
            let scale = d3.scaleOrdinal(d3.schemeCategory10);
            return scale(d.group);
        }

        let drag = (simulation) => {
            function dragstarted(event) {
                if (!event.active) simulation.alphaTarget(0.3).restart();
                event.subject.fx = event.subject.x;
                event.subject.fy = event.subject.y;
            }

            function dragged(event) {
                event.subject.fx = event.x;
                event.subject.fy = event.y;
            }

            function dragended(event) {
                if (!event.active) simulation.alphaTarget(0);
                event.subject.fx = null;
                event.subject.fy = null;
            }

            return d3.drag()
                .on("start", dragstarted)
                .on("drag", dragged)
                .on("end", dragended);
        }

        let chart = () => {
            let graphElement = document.getElementById("input-content").getBoundingClientRect();
            let width = graphElement.width;
            let height = graphElement.height;

            const links = data.links.map(d => Object.create(d));
            const nodes = data.nodes.map(d => Object.create(d));

            const simulation = d3.forceSimulation(nodes)
                .force("link", d3.forceLink(links).distance(d => 150.0).id(d => d.id))
                .force("charge", d3.forceManyBody())
                .force("center", d3.forceCenter(width / 2, height / 2));

            const svg = d3.select("#graph")
                // .attr("viewBox", [0, 0, width, height])
                // .attr("width", width)   // <-- Here
                .attr("height", height); // <-- and here!

            svg.append('defs').append('marker')
                .attr('id', 'arrowhead')
                .attr('viewBox', '-0 -5 10 10')
                .attr('refX', 9)
                .attr('refY', 0)
                .attr('orient', 'auto')
                .attr('markerWidth', 13)
                .attr('markerHeight', 13)
                .attr('xoverflow', 'visible')
                .append('svg:path')
                .attr('d', 'M 0,-5 L 10 ,0 L 0,5')
                .attr('fill', '#999')
                .style('stroke','none');

            const g = svg.append("g");

            let zoomed = ({transform}) => {
                g.attr("transform", transform);
            }

            svg.call(d3.zoom()
                .extent([[0, 0], [width, height]])
                .scaleExtent([1, 8])
                .on("zoom", zoomed));

            const link = g.append("g")
                .attr("stroke", "#999")
                .attr("stroke-opacity", 0.6)
                .selectAll("line")
                .data(links)
                .join("line")
                .attr("stroke-width", d => Math.sqrt(d.weight))
                .attr('marker-end','url(#arrowhead)');

            // displayed on mouse over
            link.append("title")
                .text(d => d.texts);

            const link_title = g.append("g")
                .attr("stroke", "#000")
                .attr("stroke-width", "#2px")
                .selectAll("text")
                .data(links)
                .join("text")
                .attr("x", "50%")
                .attr("y", "50%")
                .attr("text-anchor", "middle")
                .attr("dy", ".3em")
                .text(d => d.text);

            const node = g.append("g")
                .attr("stroke", "#fff")
                .attr("stroke-width", 1.5)
                .selectAll("circle")
                .data(nodes)
                .join("circle")
                .attr("r", d =>  Math.sqrt(d.weight) * 15)
                .attr("fill", color)
                .call(drag(simulation));

            // displayed on mouse over
            node.append("title")
                .text(d => d.texts);

            const title = g.append("g")
                .attr("stroke", "#000")
                .attr("stroke-width", "#2px")
                .selectAll("text")
                .data(nodes)
                .join("text")
                .attr("x", "50%")
                .attr("y", "50%")
                .attr("text-anchor", "middle")
                .attr("dy", ".3em")
                .text(d => d.text);

            simulation.on("tick", () => {

                link.each(function(d,i,n) {
                    let radius_start =  Math.sqrt(d.source.weight) * 15;
                    let radius_end =  Math.sqrt(d.target.weight) * 15;

                    let start = new Vector(d.source.x, d.source.y);
                    let end = new Vector(d.target.x, d.target.y);

                    let dir = Vector.sub(start, end);
                    dir = Vector.normalize(dir);
                    dir = Vector.mul(dir, radius_end);

                    let dir2 = Vector.sub(end, start);
                    dir2 = Vector.normalize(dir2);
                    dir2 = Vector.mul(dir2, radius_start);

                    end = Vector.add(end, dir);
                    start = Vector.add(start, dir2);

                    d3.select(this)
                        .attr("x1", start.x)
                        .attr("x2", start.x + (end.x - start.x))
                        .attr("y1", start.y)
                        .attr("y2", start.y + (end.y - start.y))
                })

                link_title.each(function(d,i,n) {
                    let radius_start =  Math.sqrt(d.source.weight * 15);
                    let radius_end =  Math.sqrt(d.target.weight * 15);

                    let start = new Vector(d.source.x, d.source.y);
                    let end = new Vector(d.target.x, d.target.y);

                    let dir = Vector.sub(start, end);
                    dir = Vector.normalize(dir);
                    dir = Vector.mul(dir, radius_end);

                    let dir2 = Vector.sub(end, start);
                    dir2 = Vector.normalize(dir2);
                    dir2 = Vector.mul(dir2, radius_start);

                    end = Vector.add(end, dir);
                    start = Vector.add(start, dir2);

                    d3.select(this)
                        .attr("x", start.x + (end.x - start.x) / 2)
                        .attr("y", start.y + (end.y - start.y) / 2)
                })

                node
                    .attr("cx", d => d.x)
                    .attr("cy", d => d.y);

                title
                    .attr("x", d => d.x)
                    .attr("y", d => d.y);
            });
        }
        chart();
    }
    render(){
        return <svg id="graph" className="w-100 h-100"></svg>
    }
}

export default Graph;