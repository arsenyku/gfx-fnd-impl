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
  
  String(describing:camera).write(toFile: outputFile)
  String(describing:walls).write(toFile: outputFile)
  String(describing:groundColour).write(toFile: outputFile)
  String(describing:skyColour).write(toFile: outputFile)
 
  let screen = PNMImage.imageOfSize(width: camera.viewWidth, height: camera.viewHeight, type: .RGB, max: maxColour)
  
  let skyBottom = Int(ceil(Float(screen.height)/2))
  screen.paintRect(p1: (screen.left,screen.top), p2: (screen.right, skyBottom), colour: skyColour)
  screen.paintRect(p1: (screen.left, skyBottom+1), p2: (screen.right, screen.bottom), colour: groundColour)

  screen.write(toFile: outputFile)
}

main()

