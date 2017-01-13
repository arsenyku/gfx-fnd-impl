//
//  main.swift
//  gfx-fnd-01
//
//  Created by asu on 2017-01-12.
//  Copyright © 2017 ArsenykUstaris. All rights reserved.
//

import Foundation

// PROGNAME 8x7 1,2 3,4 OUTFILENAME
func Usage()
{
  print ("\(CommandLine.arguments[0]) <WIDTHxHEIGHT> <StartX,StartY> <EndX,EndY> <outputfile>")
}

func main()
{
  guard let imageSize = CommandLine.arguments[safe: 1],
    let lineStartCoordinate = CommandLine.arguments[safe: 2],
    let lineEndCoordinate = CommandLine.arguments[safe: 3]
    else
  {
    Usage()
    exit (1)
  }
  
  let outputFile = CommandLine.arguments[safe:4]
  
  var split = imageSize.components(separatedBy: "x")
  let imageWidth = Int(split[0])!
  let imageHeight = Int(split[1])!
  
  split = lineStartCoordinate.components(separatedBy: ",")
  let lineStartX = Int(split[0])!
  let lineStartY = Int(split[1])!
  
  split = lineEndCoordinate.components(separatedBy: ",")
  let lineEndX = Int(split[0])!
  let lineEndY = Int(split[1])!
  
  
  let image = PNMImage.imageOfSize(width: imageWidth, height: imageHeight)
  image.drawLine(start:(lineStartX,lineStartY), end:(lineEndX, lineEndY))
  image.write(toFile: outputFile)

}


main()
