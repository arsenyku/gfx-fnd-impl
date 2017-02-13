//
//  Line.swift
//  gfx-fnd-03
//
//  Created by asu on 2017-01-16.
//  Copyright © 2017 ArsenykUstaris. All rights reserved.
//

import Foundation

class Line: CustomStringConvertible
{
  let start:Point
  let end:Point
  
  required init(from start:Point, to end:Point)
  {
    self.start = start
    self.end = end
  }
  
  var description: String
  {
    return "[start:\(start), end:\(end)]"
  }
  
  func intersection(with otherLine:Line, includingEndPoints closed:Bool = false) -> Point?
  {
    let lineAB = self
    let lineCD = otherLine
    
    let pointA = lineAB.start
    let pointB = lineAB.end
    let pointC = lineCD.start
    let pointD = lineCD.end
    
    let dxAB = pointB.x - pointA.x
    let dyAB = pointB.y - pointA.y
    let dxCD = pointD.x - pointC.x
    let dyCD = pointD.y - pointC.y
    
    let denominator = (dxAB * dyCD) - (dxCD * dyAB)
    
    if denominator == 0
    {
      return nil
    }
    
    let positiveDenominator = (denominator > 0)
    
    let dxCA = pointA.x - pointC.x
    let dyCA = pointA.y - pointC.y
    
    let numeratorAB = (dxAB * dyCA) - (dyAB * dxCA)
    
    if (numeratorAB < 0) == positiveDenominator
    {
      return nil
    }
    
    let numeratorCD = (dxCD * dyCA) - (dyCD * dxCA)
    if (numeratorCD < 0) == positiveDenominator
    {
      return nil
    }
    
    if (closed)
    {
      if ((numeratorAB >= denominator) == positiveDenominator) ||
        ((numeratorCD >= denominator) == positiveDenominator)
      {
        return nil
      }

    }
    else
    {
      if ((numeratorAB > denominator) == positiveDenominator) ||
        ((numeratorCD > denominator) == positiveDenominator)
      {
        return nil
      }
    }
    
    // Collision detected
    
    let t = numeratorCD / denominator
    
    let intersectionX = pointA.x + (t * dxAB)
    let intersectionY = pointA.y + (t * dyAB)

    return Point(intersectionX, intersectionY)

  }
  
}

infix operator ✕: MultiplicationPrecedence
infix operator ●: MultiplicationPrecedence

extension Line
{
  static func ✕ (left:Line, right:Line) -> Line
  {
    let u = left.end - left.start
    let v = right.end - right.start
    
    let cross = Point(
      u.y * v.z + u.z * v.y,
      u.x * v.z + u.z * v.x,
      u.x * v.y + u.y * v.x)
    
    return Line(from: Point(0,0,0), to: cross)
    
  }
  
  static func ● (left:Line, right:Line) -> Float
  {
    let u = left.end - left.start
    let v = right.end - right.start

    return u.x * v.x + u.y * v.y + u.z * v.z
  }
  
  static prefix func -(line:Line) -> Line
  {
    return Line(from: line.end, to: line.start)
  }

}






