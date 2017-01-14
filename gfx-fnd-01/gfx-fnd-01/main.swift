//
//  main.swift
//  gfx-fnd-01
//
//  Created by asu on 2017-01-12.
//  Copyright © 2017 ArsenykUstaris. All rights reserved.
//

import Foundation
import AppKit

class TestView: NSView
{
  override init(frame: NSRect)
  {
    super.init(frame: frame)
  }
  
  required init?(coder: NSCoder)
  {
    fatalError("init(coder:) has not been implemented")
  }
  
  var colorgreen = NSColor.green
  
  override func draw(_ rect: NSRect)
  {
    colorgreen.setFill()
    NSRectFill(self.bounds)
    
    let h = rect.height
    let w = rect.width
    let color:NSColor = NSColor.yellow
    
    let drect = NSRect(x: (w * 0.25),y: (h * 0.25),width: (w * 0.5),height: (h * 0.5))
    let bpath:NSBezierPath = NSBezierPath(rect: drect)
    
    color.set()
    bpath.stroke()
    
    NSLog("drawRect has updated the view")
  }
}

final class TestApplicationController: NSObject, NSApplicationDelegate
{
  
  ///     Seems fine to create AppKit UI classes before `NSApplication` object
  ///     to be created starting OSX 10.10. (it was an error in OSX 10.9)
  let     window1 =       NSWindow()
  let     view1   =       TestView(frame: NSRect(x: 0, y: 0, width: 1000, height: 1000))
  
  func applicationDidFinishLaunching(aNotification: NSNotification)
  {
    window1.setFrame(CGRect(x: 0, y: 0, width: 1000, height: 1000), display: true)
    window1.contentView =   view1
    window1.isOpaque      =   false
    window1.center();
    window1.makeKeyAndOrderFront(self)
    //      window1.backgroundColor = view1.colorgreen
    //      window1.displayIfNeeded()
  }
  
  func applicationWillTerminate(aNotification: NSNotification) {
    // Insert code here to tear down your application
  }
}


// PROGNAME 8x7 1,2 3,4 OUTFILENAME
func Usage()
{
  print ("\(CommandLine.arguments[0]) <WIDTHxHEIGHT> <StartX,StartY> <EndX,EndY> <outputfile>")
}

func main()
{
  guard let imageSize = CommandLine.arguments[safe: 1],
    let lineStartCoordinate = CommandLine.arguments[safe: 2],
    let lineEndCoordinate = CommandLine.arguments[safe: 3]
  else
  {
    Usage()
    exit (1)
  }
  
  let outputFile = CommandLine.arguments[safe:4]
  
  var split = imageSize.components(separatedBy: "x")
  let imageWidth = Int(split[0])!
  let imageHeight = Int(split[1])!
  
  split = lineStartCoordinate.components(separatedBy: ",")
  let lineStartX = Int(split[0])!
  let lineStartY = Int(split[1])!
  
  split = lineEndCoordinate.components(separatedBy: ",")
  let lineEndX = Int(split[0])!
  let lineEndY = Int(split[1])!
  
//  print(CommandLine.arguments[1...3].joined(separator:" "))
  
  let pnmImage = PNMImage.imageOfSize(width: imageWidth, height: imageHeight)
  pnmImage.drawLine(start:(lineStartX,lineStartY), end:(lineEndX, lineEndY))
  pnmImage.write(toFile: outputFile)

  let app = NSApplication.shared()
  app.delegate = TestApplicationController()
  app.run()
  
////  let image = NSImage(cgImage:pnmImage.toCGImage()!, size:rect.size)
//
//  let rect = CGRect(x: 0, y: 0, width: 1000, height: 1000) //NSRect(x:100,y:100,width:100,height:100)
//  let window = NSWindow() //contentRect: rect, styleMask: NSWindowStyleMask.titled, backing: .buffered, defer: false)
//
//  window.setFrame(rect, display: true)
//  window.contentView =   NSView(frame: rect)
//  window.isOpaque      =   false
//  window.center();
//  window.makeKeyAndOrderFront(nil)
//  
//  
//  
////  KeyAndOrderFront(nil)
//
//  window.level = 1
//  
//  NSGraphicsContext.setCurrent(window.graphicsContext)
//  NSColor.red.set()
//  NSRectFill(NSRect(x:0,y:0,width:100,height:100))
//  window.flush()

}


main()
