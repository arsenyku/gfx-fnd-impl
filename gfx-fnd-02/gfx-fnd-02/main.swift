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
  
  // s32_x * s02_y - s32_y * s02_x
  let numeratorCD = (dxCD * dyCA) - (dyCD * dxCA)
  if (numeratorCD < 0) == positiveDenominator
  {
    return nil
  }
  
  if ((numeratorAB > denominator) == positiveDenominator) ||
    ((numeratorCD > denominator) == positiveDenominator)
  {
    return nil
  }
  
  // Collision detected
  
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
  
  let json = JSON(data: read(pathAndFilename: inputFile).data(using: .ascii)!)

  let jsonWalls = Array(json["walls"])
  let camX = json["camera_x"].floatValue
  let camY = json["camera_y"].floatValue
  let jsonAngles = json["angles"].arrayValue
  let largeR:Float = 10000
  
  let walls = jsonWalls.map({ (wallId, wallPoints) -> Wall in
    let wallStart = (wallPoints["x0"].floatValue, wallPoints["y0"].floatValue) as Point
    let wallEnd = (wallPoints["x1"].floatValue, wallPoints["y1"].floatValue) as Point
    return (Int(wallId)!, wallStart, wallEnd)
  })
  
  let angles = jsonAngles.map({ $0.floatValue })
  
  let cameraRays = angles.map({ radianAngle -> Line in
    let rayStart:Point = ( camX, camY )
    let rayEnd:Point = ( camX + largeR * cos(radianAngle), camY + largeR * sin(radianAngle) )
    let cameraRay:Line = (rayStart, rayEnd)
    return cameraRay
  })
  
  let collisions = cameraRays.map({ cameraRay -> [String:Any?] in
    
    var collision:[String : Any?] = ["wall":nil, "distance":nil]
    
    for wall in walls
    {
      let wallLine = (wall.start, wall.end)
      if let intersect = findIntersect(lineAB: wallLine, lineCD: cameraRay)
      {
        let dx = intersect.x - camX
        let dy = intersect.y - camY
        let distance = sqrt(dx*dx + dy*dy)
        
        collision = ["wall":wall.id, "distance":distance]
        
        break
      }
    }
    
    return collision
  })
  
  let output:String = String(describing:JSON(["collisions":collisions]))
  
  output.write(toFile: outputFile)

}


main()
