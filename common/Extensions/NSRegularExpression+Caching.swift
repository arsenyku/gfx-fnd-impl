//
//  NSRegularExpression+Caching.swift
//  AdventOfCode2016
//
//  Created by asu on 2016-12-14.
//  Copyright © 2016 ArsenykUstaris. All rights reserved.
//

import Foundation

extension NSRegularExpression
{
  
  fileprivate static var regexCache = [String:NSRegularExpression]()
  
  class func regularExpression(forPattern pattern:String) -> NSRegularExpression?
  {
    guard let cachedRegex = regexCache[pattern]
    else
    {
      guard let newRegex = try? NSRegularExpression(pattern: pattern, options: [])
        else { return nil }
      
      regexCache[pattern] = newRegex
      return newRegex
    }
   
    return cachedRegex
  }
  
  
}
