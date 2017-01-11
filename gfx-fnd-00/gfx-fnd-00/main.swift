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

guard arguments.count == 4,
      let factor = Int(arguments[1])
else
{
  Usage(execName: arguments[0])
  exit(1)
}

let input = arguments[2]
let output = arguments[3]

print ("SCALE: \(factor) IN: \(input)  OUT:\(output)")



