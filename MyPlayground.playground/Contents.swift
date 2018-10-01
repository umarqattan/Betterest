import Foundation

public class Vertex {
    var key: String?
    var rank: Double
    var sinks: Array<Edge>
    init() {
        self.key = nil
        self.rank = 0
        self.sinks = Array<Edge>()
    }
}

public class Edge {
    var sink: Vertex
    var weight: Int
    init() {
        self.sink = Vertex()
        self.weight = 0
    }
}

class Path {
    var total: Int
    var destination: Vertex
    var previous: Path
    
    init() {
        self.total = 0
        self.destination = Vertex()
        self.previous = Path()
    }
}

public class Graph {
    private var canvas: Array<Vertex>
    public var isDirected: Bool
    init(isDirected: Bool) {
        canvas = Array<Vertex>()
        self.isDirected = isDirected
    }
    //create a new vertex
    func addVertex(key: String) -> Vertex {
        //set the key
        let childVertex = Vertex()
        childVertex.key = key
        //add the vertex to the graph canvas
        canvas.append(childVertex)
        return childVertex
    }
    func addEdge(source: Vertex, sink: Vertex, weight: Int) {
        //create a new edge
        let newEdge = Edge()
        //establish the default properties
        newEdge.sink = sink
        newEdge.weight = weight
        source.sinks.append(newEdge)
        
        //check for undirected graph
        if !isDirected {
            //create a new reversed edge
            let reverseEdge = Edge()
            //establish the reversed properties
            reverseEdge.sink = source
            reverseEdge.weight = weight
            sink.sinks.append(reverseEdge)
        }
    }
    /**
     * pageRank(),function This calculates the page rank of various vertices using the formula described here:
     *  https://en.wikipedia.org/wiki/PageRank#Damping_factor
     *    First counts the vertices and returns the value,
     *    Then initializes all the vertices to the same page rank (1/N where N is the number of vertices),
     *    Then loops through the vertices X times, calculating their page rank and
     *    damping factor(d)= 0.85
     *  PR(A)=(1-d)/N + d (PR(B)/L(B) + PR(C)/L(C) + ........)
     *
     ***/
    func pageRank(iterations: Int) {
        
        let d = Double(0.85)
        let N = Double(canvas.count)
        
        canvas.forEach({ $0.rank = 1/N })
        
        print("Number Of Vertices: ", N)
        print("*************************")
        for _ in 0..<iterations {
            for v in canvas {
                var inbound = Double(0)
                for v2 in canvas {
                    let m = Double(v2.sinks.count)
                    for e in v2.sinks {
                        if e.sink === v {
                            inbound += v2.rank / m
                        }
                    }
                }
                v.rank =  (1 - d) / N + d * inbound;
            }
        }
        
        print("Rank of Vertices ");
        print("******************");
        canvas = canvas.sorted(by: {(v1, v2) in
            return v1.rank > v2.rank
        })
        
        for (v) in canvas{
            if let key = v.key {
                print(key, v.rank)
            }
        }
    }
}

var graph = Graph(isDirected: true)

var a = graph.addVertex(key: "a")
var b = graph.addVertex(key: "b")
var c = graph.addVertex(key: "c")
var d = graph.addVertex(key: "d")
var e = graph.addVertex(key: "e")
var f = graph.addVertex(key: "f")
var z = graph.addVertex(key: "z")
var y = graph.addVertex(key: "y")
var x = graph.addVertex(key: "x")
var w = graph.addVertex(key: "w")
var v = graph.addVertex(key: "v")

graph.addEdge(source: d, sink: a, weight: 1)
graph.addEdge(source: d, sink: b, weight: 1)
graph.addEdge(source: z, sink: b, weight: 1)
graph.addEdge(source: y, sink: b, weight: 1)
graph.addEdge(source: x, sink: b, weight: 1)
graph.addEdge(source: e, sink: b, weight: 1)
graph.addEdge(source: f, sink: b, weight: 1)
graph.addEdge(source: c, sink: b, weight: 1)
graph.addEdge(source: b, sink: c, weight: 1)
graph.addEdge(source: e, sink: d, weight: 1)
graph.addEdge(source: z, sink: e, weight: 1)
graph.addEdge(source: y, sink: e, weight: 1)
graph.addEdge(source: x, sink: e, weight: 1)
graph.addEdge(source: w, sink: e, weight: 1)
graph.addEdge(source: v, sink: e, weight: 1)
graph.addEdge(source: f, sink: e, weight: 1)
graph.addEdge(source: e, sink: f, weight: 1)

graph.pageRank(iterations: 20)
