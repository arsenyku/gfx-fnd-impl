//
//  PNMImage.swift
//  gfx-fnd-00
//
//  Created by asu on 2017-01-11.
//  Copyright © 2017 ArsenykUstaris. All rights reserved.
//

import Foundation

let DEFAULT_MAX_GRAYSCALE = 255

enum PNMType:Int {
  case Unknown = 0
  case BlackAndWhite
  case Grayscale
  case RGB
//  case BinaryBlackAndWhite
//  case BinaryGrayscale
//  case BinaryRGB
//  case AnyType
}

public func ==(lhs: Point, rhs: Point) -> Bool
{
  return lhs.x == rhs.x && lhs.y == rhs.y
}

public class Point:Hashable
{
  let x:Int
  let y:Int
  
  required public init(x:Int, y:Int)
  {
    self.x = x
    self.y = y
  }

  public var hashValue: Int
  {
    return "\(x):\(y)".hashValue
  }
}

class Pixel
{
  let red:Int
  let green:Int
  let blue:Int
  
  let maxGrayscale:Int?
  let pad = " "
  let padLength:Int
  
  required init(r:Int, g:Int, b:Int)
  {
    red = r
    green = g
    blue = b
    
    maxGrayscale = nil
    padLength = String(max(r, g, b)).length
  }
  
  required init(grayscale:Int, maxGrayscale:Int = DEFAULT_MAX_GRAYSCALE)
  {
    red = grayscale
    green = grayscale
    blue = grayscale
    
    self.maxGrayscale = maxGrayscale
    padLength = String(maxGrayscale).length
  }
  
  convenience init(on:Bool)
  {
    self.init(grayscale:on ? 1 : 0, maxGrayscale:1)
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
    return String(number).padding(toLength: padLength, withPad: pad, startingAt: 0)
  }
}

class PNMImage
{
  let pixels:[Point:Pixel]
  let width:Int
  let height:Int
  let type:PNMType
  
  required init(type:PNMType, width:Int, height:Int, pixels:[Point:Pixel])
  {
    self.type = type
    self.width = width
    self.height = height
    self.pixels = pixels
  }
  
  required init(pixelArray:[String])
  {
    pixels=[:]
    width = 0
    height = 0
    type = .Unknown
  }
  
  convenience init(fromFile pathAndFilename:String)
  {
    let inputLines = readLines(pathAndFilename: pathAndFilename).filter({ !$0.hasPrefix("#") })

    guard let line = inputLines[safe:0],
      line.length > 0,
      let pnmType = PNMType(rawValue: Int(line[1..<line.length]!)!),
      let dimensions = inputLines[safe: 1]?.components(separatedBy: .whitespaces),
      let width = Int(dimensions[safe: 0] ?? "0"),
      let height = Int(dimensions[safe: 1] ?? "0"),
      inputLines.count > 2
    else { exit(1) }

    let pixels = PNMImage.pixelTable(from:Array(inputLines[2..<inputLines.count]), ofType:pnmType)
    
    self.init(type:pnmType, width:width, height:height, pixels:pixels)

  }
  
  class func pixelTable(from pixelArray:[String], ofType pnmType:PNMType) -> [Point:Pixel]
  {
    var result = [Point:Pixel]()

    pixelArray.enumerated().forEach({rowNumber, pixelString in
      
      if (pnmType == .RGB)
      {
        pixelString.components(separatedBy: .whitespaces)
          .groupBy(3)
          .enumerated()
          .forEach({ columnNumber, pixelTriplet in
            let rgbTriplet = pixelTriplet.map({ Int($0)! })
            let pixel = Pixel(r:rgbTriplet[safe: 0] ?? 0, g:rgbTriplet[safe: 1] ?? 0, b:rgbTriplet[safe: 2] ?? 0)
            result[Point(x:columnNumber, y:rowNumber)] = pixel
          })
      }
      else
      {
        pixelString.components(separatedBy: .whitespaces)
          .enumerated()
          .forEach({ columnNumber, pixelElement in
            let pixel = (pnmType == .BlackAndWhite) ? Pixel(on:Int(pixelElement) != 0) : Pixel(grayscale: Int(pixelElement)!)
            result[Point(x:columnNumber, y:rowNumber)] = pixel
          })
      
      }
    })
    
    return result
  }
  
    
}















