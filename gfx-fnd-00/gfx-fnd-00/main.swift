//
//  main.swift
//  gfx-fnd-00
//
//  Created by asu on 2017-01-10.
//  Copyright © 2017 ArsenykUstaris. All rights reserved.
//

import Foundation

func Usage(execName: String)
{
  print ("\(execName) <scale> <input file> <ouput file>")
}

let arguments = CommandLine.arguments

guard arguments.count >= 2,
      let factor = Int(arguments[1])
else
{
  Usage(execName: arguments[0])
  exit(1)
}

print ("SCALE: \(factor) IN: \(arguments[safe:1] ?? "<<")  OUT:\(arguments[safe:2] ?? ">>")")

var inputLines:[String]
var inputFile = arguments[safe:2]
var outputFile = arguments[safe: 3]

if let inputFile = inputFile
{
  inputLines = readLines(pathAndFilename: inputFile)
}
else
{
  inputLines = readLines()
}
inputLines = inputLines.filter({ !$0.hasPrefix("#") })

var line = inputLines[safe: 0] ?? ""
guard line.length > 0,
      let pnmType = Int(line[1..<line.length]!),
      let dimensions = inputLines[safe: 1]?.components(separatedBy: .whitespaces),
      let xDimension = dimensions[safe: 0],
      let yDimension = dimensions[safe: 1],
      inputLines.count > 2
  else { exit(1) }

print ("PNMTYPE: \(pnmType), xSize:\(xDimension) ySize:\(yDimension)")

let pixels = inputLines[2..<inputLines.count]

if let outputFile = outputFile
{
  if (FileManager.default.fileExists(atPath: outputFile))
  {
    try? FileManager.default.removeItem(atPath: outputFile)
  }
  FileManager.default.createFile(atPath: outputFile, contents:Data(), attributes: nil)
  
  ("P" + String(pnmType) + "\n").append(toFile: outputFile)
  "\(xDimension) \(yDimension) \n".append(toFile: outputFile)
  pixels.forEach({($0 + "\n").append(toFile: outputFile)})
}
else
{
  print ("P" + String(pnmType))
  print ("\(xDimension) \(yDimension)")
  pixels.forEach({print($0)})
}



