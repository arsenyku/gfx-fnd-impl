//
//  main.swift
//  gfx-fnd-02
//
//  Created by asu on 2017-01-13.
//  Copyright © 2017 ArsenykUstaris. All rights reserved.
//

import Foundation

// PROGNAME 8x7 1,2 3,4 OUTFILENAME
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
  

  print ("\(inputFile) \(outputFile ?? "")")
  
  let json = JSON(data: read(pathAndFilename: inputFile).data(using: .ascii)!)
  print (json)
  
}


main()
