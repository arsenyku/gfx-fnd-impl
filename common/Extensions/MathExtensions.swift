//
//  MathExtensions.swift
//  AdventOfCode2016
//
//  Created by asu on 2016-12-13.
//  Copyright © 2016 ArsenykUstaris. All rights reserved.
//

import Foundation

extension Int
{
  func raise(toPower power:Int) -> Int
  {
    return Int(pow(Float(self),Float(power)))
  }
}
