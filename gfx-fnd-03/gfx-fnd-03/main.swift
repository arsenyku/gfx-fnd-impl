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

  let json = JSON(data: read(pathAndFilename: inputFile).data(using: .ascii)!)

  let cameraJson = json["camera"]
  let wallsJson = json["walls"]
  let groundColour = json["ground_color"]
  let skyColour = json["sky_color"]
  
  String(describing:cameraJson).write(toFile: outputFile)
  String(describing:wallsJson).write(toFile: outputFile)
  String(describing:groundColour).write(toFile: outputFile)
  String(describing:skyColour).write(toFile: outputFile)
  
  
  
  
}

main()

