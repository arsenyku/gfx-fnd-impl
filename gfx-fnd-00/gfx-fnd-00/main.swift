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

typealias GfxData = (pnmType:PNMType, xDimension:Int, yDimension:Int, pixels:[String])

func readInput(inputFile:String?) -> GfxData
{
  var inputLines:[String]
  
  if let inputFile = inputFile
  {
    inputLines = readLines(pathAndFilename: inputFile)
  }
  else
  {
    inputLines = readLines()
  }
  inputLines = inputLines.filter({ !$0.hasPrefix("#") })
  
  guard let line = inputLines[safe:0],
    line.length > 0,
    let pnmType = PNMType(rawValue: Int(line[1..<line.length]!)!),
    let dimensions = inputLines[safe: 1]?.components(separatedBy: .whitespaces),
    let xDimension = Int(dimensions[safe: 0] ?? "0"),
    let yDimension = Int(dimensions[safe: 1] ?? "0"),
    inputLines.count > 2
    else { exit(1) }
  
  print ("PNMTYPE: \(pnmType), xSize:\(xDimension) ySize:\(yDimension)")
  
  let pixels = Array(inputLines[2..<inputLines.count])

  return (pnmType, xDimension, yDimension, pixels)
}

func writeOutput(outputFile:String?, data:GfxData)
{
  if let outputFile = outputFile
  {
    if (FileManager.default.fileExists(atPath: outputFile))
    {
      try? FileManager.default.removeItem(atPath: outputFile)
    }
    FileManager.default.createFile(atPath: outputFile, contents:Data(), attributes: nil)
    
    ("P" + String(data.pnmType.rawValue) + "\n").append(toFile: outputFile)
    "\(data.xDimension) \(data.yDimension) \n".append(toFile: outputFile)
    data.pixels.forEach({($0 + "\n").append(toFile: outputFile)})
  }
  else
  {
    print ("P" + String(data.pnmType.rawValue))
    print ("\(data.xDimension) \(data.yDimension)")
    data.pixels.forEach({print($0)})
  }

}

func scale(pixels:[String], by factor:Int) -> [String]
{
  var hScaled = [String]()
  pixels.filter({ $0.trimmingCharacters(in: .whitespaces).length > 0 }).forEach({ line in
    hScaled.append( line.characters.map({ pixel -> String in
      let pixelAsString = String(pixel)
      let repeated = pixelAsString == " " ? "" : pixelAsString + " "
      let times = pixelAsString == " " ? 0 : factor
      return String(repeatElement(repeated, count: times).joined())
    }).joined() )
  })
  
  var scaled = [String]()
  hScaled.forEach({ scaled.append(contentsOf: Array(repeatElement($0, count: factor)) ) })
  
  return scaled
}

func main()
{
  let arguments = CommandLine.arguments
  
  guard arguments.count >= 2,
    let factor = Int(arguments[1])
    else
  {
    Usage(execName: arguments[0])
    exit(1)
  }
  
  print ("SCALE: \(factor) IN: \(arguments[safe:1] ?? "<<")  OUT:\(arguments[safe:2] ?? ">>")")
  
  let inputFile = arguments[safe:2]
  let outputFile = arguments[safe: 3]
  
  let data = readInput(inputFile: inputFile)
  let scaled = scale(pixels: data.pixels, by:factor)
//  print (scaled)
  writeOutput(outputFile: outputFile, data: (data.pnmType, Int(scaled.first!.length/2), scaled.count, scaled))
}

main()

