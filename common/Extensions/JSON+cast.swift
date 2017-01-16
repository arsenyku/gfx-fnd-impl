//
//  JSON+cast.swift
//  gfx-fnd-02
//
//  Created by asu on 2017-01-15.
//  Copyright © 2017 ArsenykUstaris. All rights reserved.
//

import Foundation

extension String {
  init(_ json:JSON)
  {
    self = String(describing: json)
  }
}

extension Float {
  init?(_ json:JSON)
  {
    guard let floatJson = Float(String(json))
    else
    {
      return nil
    }
    self = floatJson
  }
}
