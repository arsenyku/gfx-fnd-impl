//
//  main.swift
//  gfx-fnd-10
//
//  Created by asu on 2017-01-23.
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

func main()
{
  
  let (inputFile, outputFile) = readArgs()
  let jsonInput = JSON(data: read(pathAndFilename: inputFile).data(using: .ascii)!)

  print (jsonInput.count)
  
  PNMImage(type: .RGB, width: 100, height: 100, maxScale: 255).write(toFile: outputFile)

}


main()




