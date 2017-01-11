//
//  String+MD5.swift
//  AdventOfCode2016
//
//  Created by asu on 2016-12-14.
//  Copyright © 2016 ArsenykUstaris. All rights reserved.
//

// REQUIRES Bridging Header with:
// #import <CommonCrypto/CommonCrypto.h>


import Foundation

extension String
{
  func md5() -> String {
    guard let messageData = self.data(using:String.Encoding.utf8)
      else { return "" }
    
    var digestData = Data(count: Int(CC_MD5_DIGEST_LENGTH))
    
    _ = digestData.withUnsafeMutableBytes
      { digestBytes in messageData.withUnsafeBytes
        { messageBytes in CC_MD5(messageBytes, CC_LONG(messageData.count), digestBytes)
        }
    }
    
    return digestData.map { String(format: "%02hhx", $0) }.joined()
    
  }
}
