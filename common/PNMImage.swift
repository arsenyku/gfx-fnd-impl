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
typealias ScreenPoint = (x:Int, y:Int)

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
  
  required init(type:PNMType, width:Int, height:Int, maxScale:Int = 1)
  {
    self.type = type
    self.width = width
    self.height = height
    self.maxScale = (type == .BlackAndWhite) ? 1 : maxScale
    self.pixels = (0..<height)
      .map({ _ in [Pixel]() })
      .map({ _ -> [Pixel] in Array(repeatElement(Pixel(on:false), count: width)) })
  }
  
  required init(type:PNMType, maxScale:Int = 1, pixels:[[Pixel]])
  {
    self.type = type
    self.width = (pixels.first != nil) ? pixels.first!.count : 0
    self.height = pixels.count
    self.maxScale = (type == .BlackAndWhite) ? 1 : maxScale
    self.pixels = pixels
  }
  
  convenience init?(fromFile pathAndFilename:String?)
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
    
    let rows = pixels.count
    let columns = (rows > 0) ? pixels.first!.count : 0

    guard columns == pixels.reduce(columns, {$0 == $1.count ? columns : Int.min})
      else
    {
      print("The given pixels must have equal length rows.")
      return nil
    }
    
    guard (width != columns || height == rows)
      else
    {
      print ("PNM Image Dimensions (W:\(width) x H:\(columns)) do not match the given pixels (W:\(columns) x H:\(rows)).")
      return nil
    }
    
    self.init(type:pnmType, maxScale:maxScale, pixels:pixels)

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
    
    return PNMImage(type:type, maxScale:maxScale, pixels:scaled)
  }

  public func drawLine(start:ScreenPoint, end:ScreenPoint, colour:Colour? = nil)
  {
    let drawing = (colour == nil) ? Pixel(on: true) : Pixel(colour: colour!)
    
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

      pixels[row][column] = drawing
    })
    
    range.forEach({ row in
      
      let y = Double(row)
      let x = (y - b) / m

      let column = (vertical||horizontal) ? start.x : Int(round(x))

      pixels[row][column] = drawing
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
    return PNMImage(type: type, width: width, height: height, maxScale:max)
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
  func paintRect(p1:ScreenPoint, p2:ScreenPoint, colour:Colour) -> PNMImage
  {
    let topLeft:ScreenPoint = (max(min(p1.x, p2.x), left), max(min(p1.y, p2.y), top))
    let bottomRight:ScreenPoint = (min(max(p1.x, p2.x), right), min(max(p1.y, p2.y), bottom))
    
    let rows = topLeft.y...bottomRight.y
    let columns = topLeft.x...bottomRight.x
    
    rows.forEach({ row in
      columns.forEach({ column in
        pixels[row][column] = Pixel(colour:colour)
      })
    })
    
    return self
  }
  
  typealias DrawFunction = (Int, Int) -> (Int)
  
  public func draw(start:ScreenPoint, end:ScreenPoint, colour:Colour?)
  {
    let drawing = (colour == nil) ? Pixel(on: true) : Pixel(colour: colour!)
    
    let dx = Double(end.x - start.x)
    let dy = Double(end.y - start.y)
    let m = dy/dx
    let b = Double(start.y) - m * Double(start.x)
    
    let vertical = (start.x == end.x)
    
    let domain = stride(from: start.x, through: end.x, by: (start.x <= end.x) ? 1 : -1)
    let range = stride(from: start.y, through: end.y, by: (start.y <= end.y) ? 1 : -1)
    
    domain.forEach({ column in
      let x = Double(column)
      let y = m*x + b
      
      let row = vertical ? start.y : Int(round(y))
      
      pixels[row][column] = drawing
    })
    
    range.forEach({ row in
      
      let y = Double(row)
      let x = (y - b) / m
      
      let column = vertical ? start.x : Int(round(x))
      
      pixels[row][column] = drawing
    })
  }

  public func draw(triangles:[Shape], inPerspective:Bool = false) -> PNMImage
  {
    let triangles = !inPerspective ? triangles :
      triangles.map({ triangle in
        Shape(points: triangle.vertices.map({ vertex in Point(vertex.x/vertex.z, vertex.y/vertex.z) }), colour: triangle.colour)
      })
    
    let domain = stride(from: left, through: right, by: 1)

    var hits:[(ScreenPoint, Shape)] = []
    
    domain.forEach({ pixelX in
      let x = Float(pixelX) + 0.5
      let y:Float = 0.0

      let testLine = Line(from: Point(x,y), to: Point(x,y+Float(height*10)))
      
      triangles.forEach({ triangle in
        let intersections = triangle.edges
          .map({ edge in testLine.intersection(with: edge, includingEndPoints: true) })
          .filter({ $0 != nil })
          .map({ $0! })
        
        guard let minHitY = intersections.map({ $0.y }).min(),
          let maxHitY = intersections.map({ $0.y }).max()
        else
        {
          return
        }

        let hitTop = minHitY - 1
        let hitBottom = maxHitY + 1
        
        stride(from: hitTop, through: hitBottom, by: 1)
          .filter({ hitY in
            let midY = Float(Int(floor(hitY))) + 0.5
            
            let inBetween = (midY >= minHitY) && (midY <= maxHitY)

            // Delay evaluation of =~ if unnecessary
            return inBetween || ( (midY =~ minHitY) || (midY =~ maxHitY) )

          })
          .forEach({ hitY in
            let pixelY = Int(floor(hitY))
            hits.append((ScreenPoint(pixelX, pixelY), triangle))
          })
      })
        
    })
    
    hits.forEach({ point, shape in
      self.draw(pixel: Pixel(colour: shape.colour), at: point)
    })
    
    
    return self
  }
 
  func draw(pixel:Pixel, at point:ScreenPoint)
  {
    let row = point.y
    let column = point.x
    guard (row >= 0 && row < height),
      (column >= 0 && column < height)
      else { return }
    pixels[row][column] = pixel
  }
  
  func draw(pixelsFor pixelData:[DrawingData], withXOffset xOffset:Float = 0.0, withYOffset yOffset:Float = 0.0) -> PNMImage
  {
    pixelData.map({ (originalPoint, colour, distance) -> (ScreenPoint, Pixel, Float) in
      let newX = Int(floor( (originalPoint.x + xOffset) ))
      let newY = Int(floor( (originalPoint.y + yOffset) ))
      
      return (ScreenPoint(newX, newY), Pixel(colour: colour), distance)
    })
      .forEach({ point, pixel, distance in
        self.draw(pixel: pixel, at: point)
      })
    
    return self
  }
  
}










