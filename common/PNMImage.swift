//
//  PNMImage.swift
//  gfx-fnd-00
//
//  Created by asu on 2017-01-11.
//  Copyright © 2017 ArsenykUstaris. All rights reserved.
//

import Foundation

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

typealias Colour = (r:Int, g:Int, b:Int, max:Int)
typealias Point = (x:Int, y:Int)

class PNMImage
{
  var pixels:[[Pixel]]
  let width:Int
  let height:Int
  let type:PNMType
  let maxScale:Int
  
  let left:Int = 0
  let top:Int = 0
  var right:Int { return width - 1 }
  var bottom:Int { return height - 1 }
  
  required init(type:PNMType, width:Int, height:Int, maxScale:Int = 1, pixels:[[Pixel]])
  {
    self.type = type
    self.width = width
    self.height = height
    self.maxScale = (type == .BlackAndWhite) ? 1 : maxScale
    self.pixels = pixels
  }
  
  convenience init(fromFile pathAndFilename:String?)
  {
    let inputLines = (pathAndFilename == nil) ?
      readLines() :
      readLines(pathAndFilename: pathAndFilename!).filter({ !$0.isEmpty && !$0.hasPrefix("#") })
    
    guard let line = inputLines[safe:0],
      line.length > 0,
      let pnmType = PNMType(rawValue: Int(line[1..<line.length]!)!),
      let dimensions = inputLines[safe: 1]?.components(separatedBy: .whitespaces),
      let width = Int(dimensions[safe: 0] ?? "0"),
      let height = Int(dimensions[safe: 1] ?? "0"),
      inputLines.count > 2
    else { exit(1) }

    let pixelStart = (pnmType == .BlackAndWhite) ? 2 : 3

    let maxScale = (pnmType == .BlackAndWhite) ? 1 : Int(inputLines[safe: 2]!) ?? 0

    let pixels = PNMImage.pixelTable(from:Array(inputLines[pixelStart..<inputLines.count]), ofType:pnmType)
    
    self.init(type:pnmType, width:width, height:height, maxScale:maxScale, pixels:pixels)

  }
  
  public func scaled(by factor:Int) -> PNMImage
  {
    var hScaled = [[Pixel]]()
    pixels.forEach({ row in
      
      hScaled.append( row.map({ pixel -> [Pixel] in
        return Array(repeatElement(pixel, count: factor))
      }).flatMap({$0}) )
      
    })

    var scaled = [[Pixel]]()
    hScaled.forEach({ row in scaled.append(contentsOf: Array(repeatElement(row, count: factor)) ) })
    
    return PNMImage(type:type, width:width*factor, height:height*factor, maxScale:maxScale, pixels:scaled)
  }
  
  public func drawLine(start:(x:Int, y:Int), end:(x:Int, y:Int))
  {
    let dx = Double(end.x - start.x)
    let dy = Double(end.y - start.y)
    let m = dy/dx
    let b = Double(start.y) - m * Double(start.x)
    
    let vertical = (start.x == end.x)
    let horizontal = (start.y == end.y)
    
    let domain = stride(from: start.x, through: end.x, by: (start.x <= end.x) ? 1 : -1)
    let range = stride(from: start.y, through: end.y, by: (start.y <= end.y) ? 1 : -1)

    domain.forEach({ column in
      
      let x = Double(column)
      let y = m*x + b
      
      let row = vertical ? start.y : Int(round(y))
      
      pixels[row][column] = Pixel(on: true)
    })
    
    range.forEach({ row in
      
      let y = Double(row)
      let x = (y - b) / m
      
      let column = horizontal ? start.x : Int(round(x))
      
      pixels[row][column] = Pixel(on: true)
    })
  }
  
  public func write(toFile outputFile:String?)
  {
    var output =
      ("P" + String(type.rawValue) + "\n") +
      "\(width) \(height) \n"
    
    if (type != .BlackAndWhite)
    {
      output += String(maxScale) + "\n"
    }
    
    output += pixels.reduce("", { partial, row in partial + row.map({ $0.output }).joined(separator: " ") + "\n" })
    
    output.write(toFile: outputFile)
    
  }

  class func pixelTable(from pixelArray:[String], ofType pnmType:PNMType) -> [[Pixel]]
  {
    var result = [[Pixel]]()
    
    pixelArray.enumerated().forEach({rowNumber, pixelString in
      
      var row = [Pixel]()
      
      if (pnmType == .RGB)
      {
        pixelString.components(separatedBy: .whitespaces)
          .filter({ !$0.trimmingCharacters(in: .whitespaces).isEmpty })
          .groupBy(3)
          .enumerated()
          .forEach({ columnNumber, pixelTriplet in
            let rgbTriplet = pixelTriplet.map({ Int($0)! })
            let pixel = Pixel(r:rgbTriplet[safe: 0] ?? 0, g:rgbTriplet[safe: 1] ?? 0, b:rgbTriplet[safe: 2] ?? 0)
            row.append(pixel)
          })
      }
      else
      {
        pixelString.components(separatedBy: .whitespaces)
          .filter({ !$0.trimmingCharacters(in: .whitespaces).isEmpty })
          .enumerated()
          .forEach({ columnNumber, pixelElement in
            let pixel = (pnmType == .BlackAndWhite) ? Pixel(on:Int(pixelElement) != 0) : Pixel(grayscale: Int(pixelElement)!)
            row.append(pixel)
          })
      }
      
      result.append(row)
    })
    
    return result
  }
  
  class func imageOfSize(width:Int, height:Int, type:PNMType = .BlackAndWhite, max:Int = 1) -> PNMImage
  {
    let pixelTable = (0..<height)
      .map({ _ in [Pixel]() })
      .map({ _ -> [Pixel] in Array(repeatElement(Pixel(on:false), count: width)) })
    
    return PNMImage(type: type, width: width, height: height, maxScale:max, pixels: pixelTable)
  }
}

extension Pixel
{
  convenience init(colour:Colour)
  {
    self.init(r:colour.r, g:colour.g, b:colour.b, maxColour:colour.max)
  }
}

extension PNMImage
{
  func paintRect(p1:Point, p2:Point, colour:Colour)
  {
    let topLeft:Point = (max(min(p1.x, p2.x), left), max(min(p1.y, p2.y), top))
    let bottomRight:Point = (min(max(p1.x, p2.x), right), min(max(p1.y, p2.y), bottom))
    
    let rows = stride(from: topLeft.y, through:bottomRight.y, by: 1)
    let columns = stride(from: topLeft.x, through: bottomRight.x, by: 1)
    
    rows.forEach({ row in
      columns.forEach({ column in
        pixels[row][column] = Pixel(colour:colour)
      })
    })
    
  }
}













