//
//  Float+Comparison.swift
//  gfx-fnd-11
//
//  Created by asu on 2017-02-02.
//  Copyright © 2017 ArsenykUstaris. All rights reserved.
//

import Foundation

infix operator =~: ComparisonPrecedence
extension Float
{
  static let AlmostEqualEpsilon:Float = 1e-5
  static func =~(lhs: Float, rhs: Float) -> Bool {
    return abs(lhs - rhs) <= AlmostEqualEpsilon
  }
  
}


