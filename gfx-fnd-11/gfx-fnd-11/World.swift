//
//  World.swift
//  gfx-fnd-11
//
//  Created by asu on 2017-02-02.
//  Copyright © 2017 ArsenykUstaris. All rights reserved.
//

import Foundation

typealias PointAndColour = (point:Point, colour:Colour)

let TheWorld = World.Shared

class World
{
  static let Shared = World()
  private init() {}
  
  static let LargestMagnitude:Float = 1e4
  
  var triangles = [Shape]()
  var trianglesInPerspective = [Shape]()
  
  func add(triangles:[Shape])
  {
    self.triangles.append(contentsOf: triangles)
    self.trianglesInPerspective.append(contentsOf: triangles.map({
      Shape(points: $0.vertices.map({
        Point($0.x/$0.z, $0.y/$0.z)
      }), colour: $0.colour)
    }))
  }

  func view(from cameraPoint:Point = Point(0,0,1e-6), withDirectionVector viewVector:Point = Point(0,0,1)) -> [PointAndColour]
  {
    return []
  }
  
  func view() -> [PointAndColour]
  {
    let result = trianglesInPerspective.map({ triangle -> [PointAndColour] in
      let minX = floor(triangle.vertices.map({ $0.x }).min() ?? 0.0) + 0.5
      let maxX = floor(triangle.vertices.map({ $0.x }).max() ?? 0.0) + 0.5
      
      let minY = floor(triangle.vertices.map({ $0.y }).min() ?? 0.0) - 1.0
      
      var colouredPoints = [PointAndColour]()
      
      stride(from: minX, through: maxX, by: 1.0).forEach({ pixelMidX in
        let testLine = Line(from: Point(pixelMidX,minY), to: Point(pixelMidX,World.LargestMagnitude))
        
        let intersections = triangle.edges
          .map({ edge in testLine.intersection(with: edge, includingEndPoints: true) })
          .flatMap({ $0 })
        
        let minHitY = intersections.map({ $0.y }).min() ?? World.LargestMagnitude
        let maxHitY = intersections.map({ $0.y }).max() ?? World.LargestMagnitude
        
        stride(from: minHitY, through: maxHitY, by: 1)
          .filter({ hitY in
            let pixelMidY = Float(Int(floor(hitY))) + 0.5
            
            let inBetween = (pixelMidY >= minHitY) && (pixelMidY <= maxHitY)
            
            // Delay evaluation of =~ until absolutely necessary
            return inBetween || ( (pixelMidY =~ minHitY) || (pixelMidY =~ maxHitY) )
            
          })
          .forEach({ hitY in
            let pixelMidY = floor(hitY) + 0.5
            colouredPoints.append((Point(pixelMidX, pixelMidY), triangle.colour))
          })
        
      })
      
      return colouredPoints
    })
      .flatMap({ $0.map({ $0 }) })
    
    return result
  }
}

