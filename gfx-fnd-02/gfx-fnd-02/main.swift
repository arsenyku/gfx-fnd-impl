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
//    print ("Collinear - no intersect")
    return nil
  }
  
  let positiveDenominator = (denominator > 0)

  let dxCA = pointA.x - pointC.x
  let dyCA = pointA.y - pointC.y
  
  let numeratorAB = (dxAB * dyCA) - (dyAB * dxCA)
  
  if (numeratorAB < 0) == positiveDenominator
  {
//    print ("No Collision")
    return nil
  }
  
  // s32_x * s02_y - s32_y * s02_x
  let numeratorCD = (dxCD * dyCA) - (dyCD * dxCA)
  if (numeratorCD < 0) == positiveDenominator
  {
//    print("No Collision")
    return nil
  }
  
  if ((numeratorAB > denominator) == positiveDenominator) ||
    ((numeratorCD > denominator) == positiveDenominator)
  {
//    print ("No Collision")
    return nil
  }
  
  // Collision detected
  
  //t = t_numer / denom
  let t = numeratorCD / denominator
  
  let intersectionX = pointA.x + (t * dxAB)
  let intersectionY = pointA.y + (t * dyAB)

  return (intersectionX, intersectionY)
}

typealias Wall = (id:Int, start:Point, end:Point)

func main()
{
  guard let inputFile = CommandLine.arguments[safe: 1]
    else
  {
    Usage()
    exit (1)
  }
  
  let outputFile = CommandLine.arguments[safe:2]
  

//  print ("\(inputFile) \(outputFile ?? "")")
  
  let json = JSON(data: read(pathAndFilename: inputFile).data(using: .ascii)!)

  let jsonWalls = Array(json["walls"])
  let camX = json["camera_x"].floatValue
  let camY = json["camera_y"].floatValue
  let jsonAngles = json["angles"].arrayValue
  let largeR:Float = 10000
  
//  print (camX, camY)
//  print (jsonAngles)
  
  let walls = jsonWalls.map({ (wallId, wallPoints) -> Wall in
    let wallStart = (wallPoints["x0"].floatValue, wallPoints["y0"].floatValue) as Point
    let wallEnd = (wallPoints["x1"].floatValue, wallPoints["y1"].floatValue) as Point
    return (Int(wallId)!, wallStart, wallEnd)
  }) //.toDictionary(byTransforming: { ($0.name, $0)})

//  print (walls)
  
  var collisions = [[String:Any?]]()
  
  for jsonAngle in jsonAngles
  {
    let radianAngle = jsonAngle.floatValue
    let rayStart:Point = ( camX, camY )
    let rayEnd:Point = ( camX + largeR * cos(radianAngle), camY + largeR * sin(radianAngle) )
    let cameraRay:Line = (rayStart, rayEnd)
//    print(cameraRay)
   
    var collision:[String : Any]? = nil
    
    for wall in walls
    {
      let wallLine = (wall.start, wall.end)
      if let intersect = findIntersect(lineAB: wallLine, lineCD: cameraRay)
      {
        let dx = intersect.x - camX
        let dy = intersect.y - camY
        let distance = sqrt(dx*dx + dy*dy)
        
//      print (intersect ?? "No Intersect")
//        intersections.append((wall.id, distance))
        collision = ["wall":wall.id, "distance":distance]
        break
      }
    }

    if let collision = collision
    {
      collisions.append(collision)
    }
    else
    {
      collisions.append(["wall":nil, "distance":nil])
    }
  }

  var result = [String:Array<Any>]()

  result["collisions"] = collisions
  let jsonResult = JSON(result)

  let output:String = jsonResult.rawString([.castNilToNSNull: true])!
  
  if let outputFile = outputFile
  {
    output.append(toFile: outputFile)
  }
  else
  {
    print (output)
  }

}


main()
