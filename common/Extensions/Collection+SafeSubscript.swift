//
//  Collection+SafeSubscript.swift
//  AdventOfCode2016
//
//  Created by asu on 2016-12-12.
//  Copyright © 2016 ArsenykUstaris. All rights reserved.
//

import Foundation

extension Collection where Indices.Iterator.Element == Index, Self.IndexDistance == Int {
  
  /// Returns the element at the specified index iff it is within bounds, otherwise nil.
  subscript (safe index: Index) -> Generator.Element? {
    return indices.contains(index) ? self[index] : nil
  }

  subscript (safe indexNumber: Int) -> Generator.Element? {
    let index = self.index(startIndex, offsetBy: indexNumber)
    return self[safe: index]
  }
}
