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
  
  //print ("SCALE: \(factor)  IN:\(arguments[safe:2] ?? "<<")  OUT:\(arguments[safe:3] ?? ">>")")
  
  let inputFile = arguments[safe:2]
  let outputFile = arguments[safe: 3]
  
  let original = PNMImage(fromFile: inputFile!)
  let scaled = original.scaled(by: factor)
  
  scaled.write(toFile:outputFile)
}

main()

