//
//  IO.swift
//  AdventOfCode2016
//
//  Created by asu on 2016-12-11.
//  Copyright © 2016 ArsenykUstaris. All rights reserved.
//

import Foundation

func read(pathAndFilename:String) -> String
{
  return (try? String(contentsOfFile: pathAndFilename)) ?? ""
}


func readLines(pathAndFilename:String) -> [String]
{
  let contents = read(pathAndFilename: pathAndFilename)
  let result = contents.components(separatedBy: CharacterSet.newlines)
  return result
  
}

func readLines() -> [String]
{
  var inputLines = [String]()
  while let inputLine = readLine()
  {
    inputLines.append(inputLine)
  }
  return inputLines
}

extension String
{
  func append(toFile filePathAndFilename:String)
  {
    if let fileHandle = FileHandle(forWritingAtPath: filePathAndFilename) {
      defer {
        fileHandle.closeFile()
      }
      fileHandle.seekToEndOfFile()
      fileHandle.write(data(using:.ascii)!)
    }
  }
}
