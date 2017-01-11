//
//  Dictionary+Filter.swift
//  AdventOfCode2016
//
//  Created by asu on 2017-01-02.
//  Copyright © 2017 ArsenykUstaris. All rights reserved.
//

import Foundation

extension Dictionary
{
  func filteredDictionary(_ isIncluded: (Key, Value) -> Bool)  -> Dictionary<Key, Value>
  {
    return self.filter(isIncluded).toDictionary(byTransforming: { $0 })
  }
}

extension Array
{
  func toDictionary<H:Hashable, T>(byTransforming transformer: (Element) -> (H, T)) -> Dictionary<H, T>
  {
    var result = Dictionary<H,T>()
    self.forEach({ element in
      let (key,value) = transformer(element)
      result[key] = value
    })
    return result
  }
}
