//
//  Camera.swift
//  gfx-fnd-03
//
//  Created by asu on 2017-01-15.
//  Copyright © 2017 ArsenykUstaris. All rights reserved.
//

import Foundation

class Camera: CustomStringConvertible
{
  let x:Float
  let y:Float
  let theta:Float
  let horizontalField:Float
  
  let viewWidth:Int
  let viewHeight:Int

  required init(x:Float, y:Float, theta:Float, horizontalField:Float, viewWidth:Int, viewHeight:Int)
  {
    self.x = x
    self.y = y
    self.theta = theta
    self.horizontalField = horizontalField
    self.viewWidth = viewWidth
    self.viewHeight = viewHeight
  }
  
  convenience init(fromJSON cameraJson:JSON)
  {
    self.init(x:cameraJson["x"].floatValue, y:cameraJson["y"].floatValue, theta:cameraJson["theta"].floatValue, horizontalField:cameraJson["h_fov"].floatValue, viewWidth:cameraJson["width"].intValue, viewHeight:cameraJson["height"].intValue)
  }
  
  var point:Point
  {
    return Point(x, y)
  }
  
  var verticalField:Float
  {
    return (Float(viewHeight)/Float(viewWidth)) * horizontalField
  }
  
  var description: String
  {
    return "[x:\(x), y:\(y), theta:\(theta), hFov:\(horizontalField), w:\(viewWidth), h:\(viewHeight)]"
  }
}
