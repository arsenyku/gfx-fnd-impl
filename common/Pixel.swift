//
//  Pixel.swift
//  gfx-fnd-00
//
//  Created by asu on 2017-01-11.
//  Copyright © 2017 ArsenykUstaris. All rights reserved.
//

import Foundation

class Pixel:CustomStringConvertible
{
  static let DEFAULT_MAX_GRAYSCALE = 255

  let red:Int
  let green:Int
  let blue:Int
  
  let maxScale:Int?
  let pad = " "
  let padLength:Int
  let pnmType:PNMType
  
  required init(r:Int, g:Int, b:Int, maxColour:Int = DEFAULT_MAX_GRAYSCALE)
  {
    red = r
    green = g
    blue = b
    
    maxScale = maxColour
    pnmType = .RGB
    padLength = String(max(r, g, b)).length
  }
  
  required init(grayscale:Int, maxGrayscale:Int = DEFAULT_MAX_GRAYSCALE)
  {
    red = grayscale
    green = grayscale
    blue = grayscale
    
    self.maxScale = maxGrayscale
    pnmType = (maxGrayscale == 0) ? .BlackAndWhite : .Grayscale
    padLength = String(maxGrayscale).length
  }
  
  convenience init(on:Bool)
  {
    self.init(grayscale:on ? 1 : 0, maxGrayscale:0)
  }
  
  var output:String
  {
    switch pnmType {
    case .RGB:
      return rgb
    case .Grayscale:
      return grayscale
    default:
      return on
    }
  }
  
  var rgb:String
  {
    return "\(padded(red)) \(padded(green)) \(padded(blue))"
  }
  
  var grayscale:String
  {
    return "\(padded(red))"
  }
  
  var on:String
  {
    return "\(red)"
  }
  
  func padded(_ number:Int) -> String
  {
    return String(number)  //.padding(toLength: padLength, withPad: pad, startingAt: 0)
  }
  
  var description: String
  {
    return output
  }
}

