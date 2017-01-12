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

class PNMImage
{
  let pixels:[[Pixel]]
  let width:Int
  let height:Int
  let type:PNMType
  let maxGrayscale:Int
  
  required init(type:PNMType, width:Int, height:Int, maxGrayscale:Int, pixels:[[Pixel]])
  {
    self.type = type
    self.width = width
    self.height = height
    self.maxGrayscale = maxGrayscale
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

    let maxGrayscale = (pnmType == .BlackAndWhite) ? 0 : Int(inputLines[safe: 2]!) ?? 0

    let pixels = PNMImage.pixelTable(from:Array(inputLines[pixelStart..<inputLines.count]), ofType:pnmType)
    
    self.init(type:pnmType, width:width, height:height, maxGrayscale:maxGrayscale, pixels:pixels)

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
    
    return PNMImage(type:type, width:width*factor, height:height*factor, maxGrayscale:maxGrayscale, pixels:scaled)
  }
  
  public func write(toFile outputFile:String?)
  {
    var output =
      ("P" + String(type.rawValue) + "\n") +
      "\(width) \(height) \n"
    
    if (type != .BlackAndWhite)
    {
      output += String(maxGrayscale) + "\n"
    }
    
    output += pixels.reduce("", { partial, row in partial + row.map({ $0.output }).joined(separator: " ") + "\n" })
    
    if let outputFile = outputFile
    {
      if (FileManager.default.fileExists(atPath: outputFile))
      {
        try? FileManager.default.removeItem(atPath: outputFile)
      }
      FileManager.default.createFile(atPath: outputFile, contents:Data(), attributes: nil)
    
      output.append(toFile: outputFile)
    }
    else
    {
      print (output)
    }
  }
}















