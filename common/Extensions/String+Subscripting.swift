//
//  String+IntSubscript.swift
//  AdventOfCode2016
//
//  Created by asu on 2016-12-11.
//  Copyright © 2016 ArsenykUstaris. All rights reserved.
//

import Foundation

extension String
{
  
  subscript (i: Int) -> String?
  {
    guard let index = self.index(self.startIndex, offsetBy: i, limitedBy: self.endIndex)
    else
    {
      return nil
    }
    return String(self[index])
  }
  
  func lastIndexOf(substring:String) -> Int?
  {
    guard let startOfSubstring = self.range(of: substring, options: .backwards)?.lowerBound
      else { return nil }
    
    return self.distance(from: self.startIndex, to: startOfSubstring)
  }
  
  func substring(from position:Int) -> String
  {
    let startOfSubstring = self.index(self.startIndex, offsetBy: position)
    return self.substring(from: startOfSubstring)
  }
  
  subscript (r: Range<Int>) -> String?
  {
    guard r.lowerBound >= 0, r.lowerBound <= length,
          r.upperBound >= 0, r.upperBound <= length
      else { return nil }
    
    let start = index(startIndex, offsetBy: r.lowerBound)
    let end = index(start, offsetBy: r.upperBound - r.lowerBound)
    return self[Range(start ..< end)]
  }

  
  var length: Int
  {
    return self.characters.count
  }
  
  func replace(at index:Int, with substitute:Character) -> String
  {
    var chars = Array(self.characters)
    chars[index] = substitute
    return String(chars)
  }

  func replace(at index:Int, with substitute:String) -> String
  {
    return self.substring(to: self.index(self.startIndex, offsetBy: index)) + substitute + self.substring(from: index+1)
  }
  
  func position(of index:String.Index) -> Int
  {
    return self.distance(from: self.startIndex, to: index)
  }

}
