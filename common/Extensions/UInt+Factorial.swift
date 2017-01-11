//
//  UInt+Factorial.swift
//  AdventOfCode2016
//
//  Created by asu on 2016-12-25.
//  Copyright © 2016 ArsenykUstaris. All rights reserved.
//

import Foundation

postfix operator ~!

postfix public func ~! (num: UInt) -> UInt
{
  guard num > 1
  else
  {
    return 1
  }

  return num * (num-1)~!

}
