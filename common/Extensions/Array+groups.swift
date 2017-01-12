//
//  Array+groups.swift
//  gfx-fnd-00
//
//  Created by asu on 2017-01-11.
//  Copyright © 2017 ArsenykUstaris. All rights reserved.
//

import Foundation

extension Array
{
  subscript(safe range: Range<Index>) -> ArraySlice<Element>
  {
    let from = index(startIndex, offsetBy: range.lowerBound, limitedBy: endIndex) ?? endIndex
    let to = index(startIndex, offsetBy:  range.upperBound, limitedBy: endIndex) ?? endIndex
    return self[from ..< to]
  }
  
  func groupBy(_ groupSize:Int) -> [[Element]]
  {
    let x = stride(from: 0, to:self.count, by: groupSize).map({ Array(self[safe:$0..<$0+groupSize]) })
    return x
    
  }
}



