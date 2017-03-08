//
//  Shape.swift
//  gfx-fnd-10
//
//  Created by asu on 2017-01-28.
//  Copyright © 2017 ArsenykUstaris. All rights reserved.
//

import Foundation

class Point:CustomStringConvertible
{
  let x:Float
  let y:Float
  let z:Float
  
  required init(_ x:Float, _ y:Float, _ z:Float = 1.0)
  {
    self.x = x
    self.y = y
    self.z = z
  }
  
  func distance(to otherPoint:Point) -> Float
  {
    let dx = otherPoint.x - self.x
    let dy = otherPoint.y - self.y
    let dz = otherPoint.z - self.z
    return sqrt(dx*dx + dy*dy + dz*dz)
  }
 
  var description: String
  {
    return "(\(x), \(y), \(z))"
  }
}


class Shape:CustomStringConvertible
{
  let vertices:[Point]
  let edges:[Line]
  let colour:Colour
  
  required init(points:[Point], colour:Colour)
  {
    var lines = [Line]()
    (points.startIndex..<points.endIndex-1).forEach({ index in
      lines.append(Line(from: points[index], to: points[index+1]))
    })

    if let lastPoint = points.last, let firstPoint = points.first
    {
      lines.append(Line(from: lastPoint, to: firstPoint))
    }
    
    vertices = points
    edges = lines
    self.colour = colour
  }
  
  var description: String
  {
    return "{colour:\(colour), points:\(vertices)}"
  }
}

extension Point
{
  func distance(through otherPoint:Point, to triangle:Shape) -> (distance:Float, intersection:Point?)
  {
    
    let normalToTriangle = -triangle.edges[0] ✕ triangle.edges[1]
    
    // TODO: Check if vector is coplanar or parallel with triangle
    //
    


    // For single-point intersection case:
    
    //           n1a1 + n2a2 + n3a3 - n1o1 - n2o2 - n3o3
    //      t = -----------------------------------------
    //                     (n1d1 + n2d2 + n3d3)
    
    let (n1, n2, n3) = (normalToTriangle.end.x, normalToTriangle.end.y, normalToTriangle.end.z)
    let (a1, a2, a3) = (triangle.vertices[1].x, triangle.vertices[1].y, triangle.vertices[1].z)
    let (o1, o2, o3) = (self.x, self.y, self.z)
    let (d1, d2, d3) = (otherPoint.x, otherPoint.y, otherPoint.z)
    
    let t = (n1*a1 + n2*a2 + n3*a3 - n1*o1 - n2*o2 - n3*o3)/(n1*d1 + n2*d2 + n3*d3)
    
    let (p1, p2, p3) = (o1+d1*t, o2+d2*t, o3+d3*t)
    
//    print (a1, a2, a3)
//    print (n1, n2, n3)
//    print (o1, o2, o3)
//    print (d1, d2, d3)
//    print (p1, p2, p3)
    
    
    let intersection = Point(p1, p2, p3)
    
    return (distance(to: intersection), intersection)
    
  }
  

}
