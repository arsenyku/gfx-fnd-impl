//
//  main.swift
//  gfx-fnd-02
//
//  Created by asu on 2017-01-13.
//  Copyright © 2017 ArsenykUstaris. All rights reserved.
//

import Foundation

// PROGNAME 8x7 1,2 3,4 OUTFILENAME
func Usage()
{
  let exec = CommandLine.arguments[0]
  print ("\(exec.components(separatedBy: "/").last ?? exec) <inputfile> <outputfile>")
}

typealias Point = (x:Float, y:Float)
typealias Line = (start:Point, end:Point)

func findIntersect(lineAB:Line, lineCD:Line) -> Point?
{
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
    print ("Collinear - no intersect")
    return nil
  }
  
  let positiveDenominator = (denominator > 0)

  let dxCA = pointA.x - pointC.x
  let dyCA = pointA.y - pointC.y
  
  let numeratorAB = (dxAB * dyCA) - (dyAB * dxCA)
  
  if (numeratorAB < 0) == positiveDenominator
  {
    print ("No Collision")
    return nil
  }
  
  // s32_x * s02_y - s32_y * s02_x
  let numeratorCD = (dxCD * dyCA) - (dyCD * dxCA)
  if (numeratorCD < 0) == positiveDenominator
  {
    print("No Collision")
    return nil
  }
  
  if ((numeratorAB > denominator) == positiveDenominator) ||
    ((numeratorCD > denominator) == positiveDenominator)
  {
    print ("No Collision")
    return nil
  }
  
  // Collision detected
  
  //t = t_numer / denom
  let t = numeratorCD / denominator
  
  let intersectionX = pointA.x + (t * dxAB)
  let intersectionY = pointA.y + (t * dyAB)

  return (intersectionX, intersectionY)
}

typealias Wall = (name:String, start:Point, end:Point)

func main()
{
  guard let inputFile = CommandLine.arguments[safe: 1]
    else
  {
    Usage()
    exit (1)
  }
  
  let outputFile = CommandLine.arguments[safe:2]
  

  print ("\(inputFile) \(outputFile ?? "")")
  
  let json = JSON(data: read(pathAndFilename: inputFile).data(using: .ascii)!)

  let jsonWalls = Array(json["walls"])
  let camX = json["camera_x"]
  let camY = json["camera_y"]
  let angles = json["angles"]
  
  print (camX, camY)
  print (angles)
  
  let walls = jsonWalls.map({ (wallName, wallPoints) -> Wall in
    let wallStart = (Float(wallPoints["x0"])!, Float(wallPoints["y0"])!) as Point
    let wallEnd = (Float(wallPoints["x1"])!, Float(wallPoints["y1"])!) as Point
    return (wallName, wallStart, wallEnd)
  }).toDictionary(byTransforming: { ($0.name, $0)})

  print (walls)
  
  
}


main()
