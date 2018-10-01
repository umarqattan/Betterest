//
//  Rank.swift
//  Bestest
//
//  Created by Umar Qattan on 9/12/18.
//  Copyright © 2018 ukaton. All rights reserved.
//

import Foundation
import UIKit

//struct PhotoPageRank {
//
//    var photos:[Photo]
//    var photoRanks: [[Float]]
//    var iterations: Int
//    var finalPhotoSortedRankings: [Photo]
//
//    init(photos: [Photo], iterations:Int) {
//        self.photos = photos
//        self.iterations = iterations
//        self.finalPhotoSortedRankings = []
//        self.photoRanks = Array(repeating: Array(repeating: 0.0,
//                                                 count: self.photos.count),
//                                count: self.iterations)
//        for j in 0...self.photos.count-1 {
//            self.photoRanks[0][j] = 1.0/Float(self.photos.count)
//
//        }
//
//    }
//
//    public mutating func rankings(photosMatrix:[[Int]]) -> [Photo]? {
//        for k in 1...self.iterations-1 {
//            for i in 0...self.photos.count-1 {
//                for j in 0...self.photos.count-1 {
//                    if photosMatrix[i][j] == -1 && i != j && self.photos[j].outgoing > 0 {
//                        self.photoRanks[k][i] += (self.photoRanks[k-1][j]/Float(self.photos[j].outgoing))
//                    }
//                }
//            }
//        }
//        var finalPhotoRankings = self.photoRanks[self.iterations-1]
//        for i in 0...self.photos.count-1 {
//            self.photos[i].photoRank = finalPhotoRankings[i]
//        }
//        self.finalPhotoSortedRankings = self.photos.sorted(by: {($0.photoRank > $1.photoRank)})
//        return self.finalPhotoSortedRankings
//    }
//
//    public func displayPhotoRankings() -> String {
//        var rankingsString = ""
//
//        for photo in finalPhotoSortedRankings {
//            rankingsString += " \(photo.description)"
//        }
//
//        return rankingsString
//    }
//}

public class Vertex {
    var key: UIImage?
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
    func addVertex(key: UIImage) -> Vertex {
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
    func pageRank(iterations: Int) -> [UIImage] {
        
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
        
        var images = [UIImage]()
        for v in canvas {
            if let key = v.key {
                print(v.rank)
                images.append(key)
            }
        }
        
        return images.reversed()
        
//        for v in canvas {
//            if let key = v.key {
//                print(key, v.rank)
//            }
//        }
    }
}

struct Photo {
    var name: String
    var image:UIImage
    var incoming:Int
    var outgoing:Int
    var photoRank:Float
    
    init(name:Int, image: UIImage) {
        self.name = "\(name)"
        self.incoming = 1
        self.outgoing = 0
        self.photoRank = 0.0
        self.image = image
    }
    
}

extension Photo: CustomStringConvertible {
    public var description: String {
        return name
    }
}
