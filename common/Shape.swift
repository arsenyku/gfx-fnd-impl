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
  
  func distance(through otherPoint:Point, to triangle:Shape) -> Float
  {
    let uVector = Line(from:self, to:otherPoint)
    
    // TODO: Check if vector is coplanar or parallel with triangle
    //
    
    let normalToTriangle = -triangle.edges[0] ✕ triangle.edges[1]

    // Note: vertices[1] is the point in common held by edge[0] and edge[1]
    let numerator = -(normalToTriangle ● Line(from:Point(0,0,0), to:triangle.vertices[1]))
    
    let denominator = normalToTriangle ● uVector
  
    print ("Distance from", self, "through", otherPoint, "to", triangle.vertices)
    print ("Normal=\(normalToTriangle)")
    print (numerator, denominator)
    
    return numerator/denominator
  }
 
  var description: String
  {
    return "(\(x), \(y), \(z))"
  }
}

extension Point
{
  static func +(left: Point, right: Point) -> Point
  {
    return Point(left.x+right.x, left.y+right.y, left.z+right.z)
  }
  
  static func -(lhs: Point, rhs: Point) -> Point
  {
    return lhs + (-rhs)
  }
  
  static prefix func -(point:Point) -> Point
  {
    return Point(-point.x, -point.y, -point.z)
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
