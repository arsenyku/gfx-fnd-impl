//
//  String+Regex.swift
//  AdventOfCode2016
//
//  Created by asu on 2016-12-12.
//  Copyright © 2016 ArsenykUstaris. All rights reserved.
//

import Foundation

extension String
{
  func capturedGroups(withRegex pattern: String) -> [String]? {
    guard let regex = NSRegularExpression.regularExpression(forPattern: pattern)
      else {return nil}
    
    let matches = regex.matches(in: self, options: [], range: NSRange(location:0, length: self.characters.count))
    
    guard let match = matches.first else { return nil }
    
    // Note: Index 1 is 1st capture group, 2 is 2nd, ..., while index 0 is full match which we don't use
    let lastRangeIndex = match.numberOfRanges - 1
    guard lastRangeIndex >= 1 else { return nil }
    
    var results = [String]()
    
    for i in 1...lastRangeIndex {
      let capturedGroupIndex = match.rangeAt(i)
      let matchedString = (self as NSString).substring(with: capturedGroupIndex)
      results.append(matchedString)
    }
    
    return results
  }
  
  func ranges(ofPattern pattern:String) -> [Range<String.Index>]
  {
    var result = [Range<String.Index>]()
    
    guard let regex = NSRegularExpression.regularExpression(forPattern: pattern)
      else {return result}
    
    let regexMatches = regex.matches(in: self, options:[], range: NSRange(location:0, length: self.characters.count))
    
    for matched in regexMatches
    {
      let matchStart = self.index(self.startIndex, offsetBy:matched.range.location)
      let matchEnd = self.index(matchStart, offsetBy:matched.range.length)
      
      result.append(matchStart..<matchEnd)
    }
    
    return result
  }
  
  func matches(ofPattern pattern:String) -> [String]
  {
    let matches = ranges(ofPattern: pattern)
    return matches.map({self[ $0.lowerBound..<$0.upperBound ]})
  }
  
  func firstMatch(ofPattern pattern:String) -> String?
  {
    guard let matchRange = self.rangeOfFirstMatch(ofPattern: pattern)
      else {return nil}
    
    return self.substring(with: matchRange)
  }
  
  func rangeOfFirstMatch(ofPattern pattern:String) -> Range<String.Index>?
  {
    guard let regex = NSRegularExpression.regularExpression(forPattern: pattern),
          let matched = regex.firstMatch(in: self, options: [], range: NSRange(location:0, length: self.characters.count))
      else {return nil}
    
    let substringStart = self.index(self.startIndex, offsetBy:matched.range.location)
    let substringEnd = self.index(substringStart, offsetBy:matched.range.length)
    
    return Range<String.Index>(uncheckedBounds: (substringStart, substringEnd))
  }
  
  func startOfFirstMatch(ofPattern pattern:String) -> Int?
  {
    guard let range = rangeOfFirstMatch(ofPattern: pattern)
      else {return nil}

    return position(of: range.lowerBound)
  }

}
