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
