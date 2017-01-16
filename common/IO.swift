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

extension FileManager
{
  func emptyFile(atPath filePathAndFilename:String)
  {
    if (FileManager.default.fileExists(atPath: filePathAndFilename))
    {
      try? FileManager.default.removeItem(atPath: filePathAndFilename)
    }
    FileManager.default.createFile(atPath: filePathAndFilename, contents:Data(), attributes: nil)

  }
}

extension String
{
  func write(toFile filePathAndFilename:String?)
  {
    guard let filePathAndFilename = filePathAndFilename
      else
    {
      print (self)
      return
    }

    FileManager.default.emptyFile(atPath: filePathAndFilename)

    self.append(toFile: filePathAndFilename)
  }
  
  func append(toFile filePathAndFilename:String?)
  {
    guard let filePathAndFilename = filePathAndFilename
    else
    {
      print (self)
      return
    }
    
    if (!FileManager.default.fileExists(atPath: filePathAndFilename))
    {
      FileManager.default.emptyFile(atPath: filePathAndFilename)
    }
    
    if let fileHandle = FileHandle(forWritingAtPath: filePathAndFilename) {
      defer {
        fileHandle.closeFile()
      }
      fileHandle.seekToEndOfFile()
      fileHandle.write(data(using:.ascii)!)
    }
  }
}
