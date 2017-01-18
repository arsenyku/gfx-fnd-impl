//
//  Wall.swift
//  gfx-fnd-03
//
//  Created by asu on 2017-01-15.
//  Copyright © 2017 ArsenykUstaris. All rights reserved.
//

import Foundation

class Wall: CustomStringConvertible
{
  let start:Point
  let end:Point
  let colour:Colour
  
  required init(start:Point, end:Point, colour:Colour)
  {
    self.start = start
    self.end = end
    self.colour = colour
  }
  
  convenience init(fromJSON wallJson:JSON, maxColour:Int)
  {
    self.init(start:Point(wallJson["x0"].floatValue,wallJson["y0"].floatValue), end:Point(wallJson["x1"].floatValue,wallJson["y1"].floatValue), colour:(wallJson["color"][0].intValue,wallJson["color"][1].intValue,wallJson["color"][2].intValue, maxColour))
  }
  
  var description: String
  {
    return "[start:\(start), end:\(end), colour:\(colour)]"
  }
}
