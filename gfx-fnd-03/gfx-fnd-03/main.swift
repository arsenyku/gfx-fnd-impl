//
//  main.swift
//  gfx-fnd-03
//
//  Created by asu on 2017-01-15.
//  Copyright © 2017 ArsenykUstaris. All rights reserved.
//

import Foundation

func Usage()
{
  let exec = CommandLine.arguments[0]
  print ("\(exec.components(separatedBy: "/").last ?? exec) <inputfile> <outputfile>")
}

func main()
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

  let maxColour = 255
  
  let json = JSON(data: read(pathAndFilename: inputFile).data(using: .ascii)!)

  let cameraJson = json["camera"]
  let wallsJson = json["walls"]
  let groundColourJson = json["ground_color"]
  let skyColourJson = json["sky_color"]
  
  let camera = Camera(fromJSON:cameraJson)
  let walls = wallsJson.map ({ Wall(fromJSON:$0.1, maxColour:maxColour) })
  let groundColour:Colour = (groundColourJson[0].intValue, groundColourJson[1].intValue, groundColourJson[2].intValue, maxColour)
  let skyColour:Colour = (skyColourJson[0].intValue, skyColourJson[1].intValue, skyColourJson[2].intValue, maxColour)
  
  let screen = PNMImage.imageOfSize(width: camera.viewWidth, height: camera.viewHeight, type: .RGB, max: maxColour)
  
  let skyBottom = Int(ceil(Float(screen.height)/2.0)) - 1
  screen.paintRect(p1: (screen.left,screen.top), p2: (screen.right, skyBottom), colour: skyColour)
  screen.paintRect(p1: (screen.left, skyBottom+1), p2: (screen.right, screen.bottom), colour: groundColour)

  screen.write(toFile: outputFile)

  let leftEdgeAngle = camera.theta + (camera.horizontalField/2.0)
    
  let halfPixelAngleWidth = (camera.horizontalField / Float(screen.width)) / 2.0
  let halfPixelAngleHeight = (camera.verticalField / Float(screen.height)) / 2.0
  
  let largeR = Float(max(screen.width, screen.height)) * 10.0
  
  let cameraRays = (screen.left...screen.right).enumerated()
    .map({ leftEdgeAngle - halfPixelAngleWidth - (Float($0.offset) * halfPixelAngleWidth * 2.0) })
    .map({ radianAngle -> Line in
      
      let rayStart:Point = Point(camera.x, camera.y )
      let rayEnd:Point = Point(camera.x + largeR * cos(radianAngle), camera.y + largeR * sin(radianAngle) )
      let cameraRay:Line = Line(from:rayStart, to:rayEnd)
      
      return cameraRay
      
    })
  
  let midline = Int(floor(Float(screen.height)/2.0))
  let heightAboveEyeLevel:Float = 1.0
  
  cameraRays.enumerated()
    .forEach({ offset, cameraRay in
      walls.map({ wall -> (distance:Float, wall:Wall?) in
        if let intersect = cameraRay.intersection(with: Line(forWall:wall))
        {
          let distance = intersect.distance(to: camera.point)
          return (distance, wall)
        }
        return (-1.0, nil)
      })
        .filter({ $0.wall != nil })
        .sorted(by: { $0.distance < $1.distance })
        .reversed()
        .forEach({ wallTuple in
          let distance = wallTuple.distance
          let wall = wallTuple.wall!
          
          let angleToTop = atan2(heightAboveEyeLevel, distance)
          let halfWallPixelCount = Int(floor(angleToTop / (2.0*halfPixelAngleHeight)))
          
          screen.drawLine(start: (offset, midline+halfWallPixelCount), end: (offset, midline-halfWallPixelCount), colour: wall.colour)
        })
  })
  
  screen.write(toFile: outputFile)

}

main()

