//
//  World.swift
//  gfx-fnd-11
//
//  Created by asu on 2017-02-02.
//  Copyright © 2017 ArsenykUstaris. All rights reserved.
//

import Foundation

typealias DrawingData = (point:Point, colour:Colour, distance:Float)

let TheWorld = World.Shared

class World
{
  static let Shared = World()
  private init() {}
  
  static let LargestMagnitude:Float = 1e4
  
  var triangles = [Shape]()
  
  func add(triangles:[Shape])
  {
    self.triangles.append(contentsOf: triangles)
  }

  func view(from cameraPoint:Point = Point(0,0,1e-6), withDirectionVector viewVector:Point = Point(0,0,1)) -> [DrawingData]
  {
    return []
  }

  func orthographicView() -> [DrawingData]
  {
    return self.view(inPerspective: false)
  }
  
  func perspectiveView() -> [DrawingData]
  {
    return self.view(inPerspective: true)
  }
  
  fileprivate func view(inPerspective:Bool) -> [DrawingData]
  {
    let viewTriangles = !inPerspective ? triangles : triangles.map({ triangle -> Shape in
      Shape(points: triangle.vertices.map({ vertex -> Point in
        Point(vertex.x/vertex.z, vertex.y/vertex.z)
      }), colour: triangle.colour)
    })
    
    let result = triangles.enumerated()
      .map({ index, originalTriangle -> [DrawingData] in
        
        let triangle = inPerspective ? viewTriangles[index] : originalTriangle;
        
        let triangleZ = originalTriangle.vertices[0].z
        
        let minX = floor(triangle.vertices.map({ $0.x }).min() ?? 0.0) + 0.5
        let maxX = floor(triangle.vertices.map({ $0.x }).max() ?? 0.0) + 0.5
        
        let minY = floor(triangle.vertices.map({ $0.y }).min() ?? 0.0) - 1.0
        
        let drawingData = stride(from: minX, through: maxX, by: 1.0)
          .reduce([DrawingData](), { (drawingDataForAllTriangles, pixelMidX) -> [DrawingData] in
            
            let testLine = Line(from: Point(pixelMidX,minY), to: Point(pixelMidX,World.LargestMagnitude))
            
            let intersections = triangle.edges
              .map({ edge in testLine.intersection(with: edge, includingEndPoints: true) })
              .flatMap({ $0 })
            
            let minHitY = intersections.map({ $0.y }).min() ?? World.LargestMagnitude
            let maxHitY = intersections.map({ $0.y }).max() ?? World.LargestMagnitude
            
            let drawingDataForTriangle = stride(from: minHitY, through: maxHitY, by: 1)
              .filter({ hitY in
                let pixelMidY = Float(Int(floor(hitY))) + 0.5
                
                let inBetween = (pixelMidY >= minHitY) && (pixelMidY <= maxHitY)
                
                // Delay evaluation of =~ until absolutely necessary
                return inBetween || ( (pixelMidY =~ minHitY) || (pixelMidY =~ maxHitY) )
                
              })
              .reduce([DrawingData](), { (partial, hitY) -> [DrawingData] in
                let pixelMidY = floor(hitY) + 0.5
                let pixelMid = Point(pixelMidX, pixelMidY)
                return partial + [(pixelMid, triangle.colour, triangleZ)]
              })
            
            return drawingDataForAllTriangles + drawingDataForTriangle
          })
        
        return drawingData
      })
      .flatMap({ $0.map({ $0 }) })
      .sorted(by: { pixel1, pixel2 in pixel1.distance > pixel2.distance })
    
    print ("No Sort")
    result.forEach({ print ($0) })
    
    return result
  }
}

