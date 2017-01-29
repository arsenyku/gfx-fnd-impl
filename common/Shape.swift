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
  let colour:Colour
  
  required init(points:[Point], colour:Colour)
  {
    vertices = points
    self.colour = colour
  }
  
  var description: String
  {
    return "{colour:\(colour), points:\(vertices)}"
  }
}
