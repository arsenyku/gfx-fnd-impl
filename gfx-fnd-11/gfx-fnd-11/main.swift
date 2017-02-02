//
//  main.swift
//  gfx-fnd-11
//
//  Created by asu on 2017-01-29.
//  Copyright © 2017 ArsenykUstaris. All rights reserved.
//

import Foundation

func Usage()
{
  let exec = CommandLine.arguments[0]
  print ("\(exec.components(separatedBy: "/").last ?? exec) <inputfile> <outputfile>")
}

func readArgs() -> (inputFile:String, outputFile:String?)
{
  guard let inputFile = CommandLine.arguments[safe: 1]
    else
  {
    Usage()
    exit (1)
  }
  
  if (!FileManager.default.fileExists(atPath: inputFile))
  {
    print ("Input file does not exist: \(inputFile)")
    exit(1)
  }
  
  let outputFile = CommandLine.arguments[safe:2]
  
  return (inputFile, outputFile)
  
}

func parseInputJson(contents json:JSON) -> (background:Colour, width:Int, height:Int, triangles:[Shape])
{
  guard let jsonBg = json["background"].array?.map({ $0.int ?? 0 }),
    let jsonHeight = json["height"].int,
    let jsonWidth = json["width"].int,
    let jsonTriangles = json["triangles"].array
    else
  {
    print ("JSON content could not be parsed")
    exit(1)
  }
  
  let bgColour = Colour(jsonBg[0], jsonBg[1], jsonBg[2], Pixel.DEFAULT_MAX_GRAYSCALE)
  let width = jsonWidth
  let height = jsonHeight
  let triangles = jsonTriangles.map({ jsonTriangle -> Shape? in
    guard let jsonPoints = jsonTriangle["points"].array,
      let jsonColour = jsonTriangle["color"].array?.map({ $0.int ?? 0 })
      else
    {
      return nil
    }
    
    let points = jsonPoints.map({ jsonPoint -> Point in
      return Point(jsonPoint[0].floatValue,jsonPoint[1].floatValue,jsonPoint[2].floatValue)
    })
    
    let colour = Colour(jsonColour[0], jsonColour[1], jsonColour[2], Pixel.DEFAULT_MAX_GRAYSCALE)
    
    return Shape(points:points, colour:colour)
  })
    .filter({ $0 != nil })
    .map({ $0! })
  
  return (bgColour, width, height, triangles)
}

func main()
{
  let (inputFile, outputFile) = readArgs()
  let jsonInput = JSON(data: read(pathAndFilename: inputFile).data(using: .ascii)!)
  let (bg, width, height, triangles) = parseInputJson(contents: jsonInput)
  
  let xOffset = Float(width)/2.0
  let yOffset = Float(height)/2.0
  
  let translatedTriangles = triangles.map({ triangle -> Shape in
    let translatedPoints = triangle.vertices.map({ vertex in Point(vertex.x + xOffset, vertex.y + yOffset, vertex.z) })
    
    return Shape(points: translatedPoints, colour: triangle.colour)
  })
  
  PNMImage(type: .RGB, width: width, height: height, maxScale: Pixel.DEFAULT_MAX_GRAYSCALE)
    .paintRect(p1: (0,0), p2: (width-1, height-1), colour: bg)
    .draw(triangles:translatedTriangles, inPerspective:true)
    .write(toFile: outputFile)
  
}


main()

