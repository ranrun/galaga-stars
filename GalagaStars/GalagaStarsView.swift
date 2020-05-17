//
//  GalagaStarsView.swift
//  GalagaStars
//
//  Created by ran on 9/1/19.
//  Copyright © 2019 ran. All rights reserved.
//

import ScreenSaver

class GalagaStarsView : ScreenSaverView {
  let myModuleName = "com.ranrun.GalagaStars"

  override var hasConfigureSheet: Bool { return false }
  override var configureSheet: NSWindow? { return nil }

  var viewBounds: NSRect
  var maxX: CGFloat
  var maxY: CGFloat
  var previewFlag: Bool
  var stars: [Star] = []
  var starGroups: [StarGroup] = []
  var starGroupSize = CGFloat(100)
  var squareSize = CGFloat(5)
  var globalCounter = 0
  let debug = false
  var setBounds = true

  override init?(frame: NSRect, isPreview: Bool) {
    viewBounds = frame
    maxX = frame.maxX
    maxY = frame.maxY
    previewFlag = maxY < 500
    super.init(frame: frame, isPreview: isPreview)
    animationTimeInterval = (1.0 / 30.0)
    setSizes(frame)
  }

  required init?(coder: NSCoder) {
    viewBounds = NSMakeRect(0, 0, 100, 100)
    maxX = 100
    maxY = 100
    previewFlag = true
    super.init(coder: coder)
    setSizes(frame)
  }

  override func animateOneFrame() {
    // window!.disableFlushing()

    NSAnimationContext.runAnimationGroup({(context) -> Void in

      if globalCounter % 5 == 0 {
        addStar(rect:viewBounds)
      } else if (globalCounter % 15 == 0) {
        addStar(rect:viewBounds)
        addStar(rect:viewBounds)
      } else if (globalCounter % 30 == 0) {
        addStar(rect:viewBounds)
        addStar(rect:viewBounds)
        addStar(rect:viewBounds)
      }

      if starGroups.count < 3 && globalCounter % 120 == 0 {
        addStarGroup(rect:viewBounds)
      }

      // updates
      for star in stars {
        star.update()
      }

      for starGroup in starGroups {
        starGroup.update()
      }

      // clean up
      stars = stars.filter {
        let star = ($0 as Star)
        return star.isAlive(viewBounds)
      }

      starGroups = starGroups.filter {
        let starGroup = ($0 as StarGroup)
        return starGroup.isAlive(viewBounds)
      }

      globalCounter += 1
    }) {
      // all done
      self.needsDisplay = true
    }

    // window!.enableFlushing()
  }

  override func draw(_ rect: NSRect) {
    if setBounds {
      viewBounds = rect
      maxX = frame.maxX
      maxY = frame.maxY
      setBounds = false
      setSizes(rect)
    }

    NSColor.black.set()
    NSBezierPath.fill(rect)

    drawSquares(rect)
    drawStars(rect)
    drawStarGroups(rect)
  }

  func addStar(rect: NSRect) {
    let newX = SSRandomFloatBetween(rect.minX, rect.maxX)
    let point = NSMakePoint(newX, rect.maxY)
    let count = Int(SSRandomIntBetween(0, 30))
    let direction = count < 16 ? NSMakePoint(0, -2.5) : NSMakePoint(0, -5)
    let color = getRandomColor()
    let newStar = Star(point:point, direction:direction, color:color, count:count)
    stars.append(newStar)
  }

  func addStarGroup(rect: NSRect) {
    let direction = NSMakePoint(0, -3)
    let count = Int(SSRandomIntBetween(0, 30))
    let color = count < 29 ? NSColor.systemRed : getRandomColor()
    let newStarGroup = StarGroup(rect:rect, starGroupType: getStarGroupType(), squareSize:squareSize, direction:direction, color:color, count:count)
    starGroups.append(newStarGroup)
  }

  func drawSquares(_ rect: NSRect) {
    if debug {
      drawSquare(point:NSMakePoint(rect.minX + 50, rect.minY + 50), color:NSColor.systemRed, size:10, fill: false)
      drawSquare(point:NSMakePoint(rect.maxX - 50, rect.minY + 50), color:NSColor.systemGreen, size:10, fill: false)
      drawSquare(point:NSMakePoint(rect.minX + 50, rect.maxY - 50), color:NSColor.systemBlue, size:10, fill: false)
      drawSquare(point:NSMakePoint(rect.maxX - 50, rect.maxY - 50), color:NSColor.systemOrange, size:10, fill: false)
    }
  }

  func drawStars(_ rect: NSRect) {
    for star in stars {
      if star.visible {
        let point = NSMakePoint(star.point.x, star.point.y)
        drawSquare(point:point, color:star.color, size:squareSize, fill:true)
      }
    }
  }

  func drawStarGroups(_ rect: NSRect) {
    for starGroup in starGroups {
      for star in starGroup.stars {
        if star.visible {
          let point = NSMakePoint(starGroup.point.x + star.point.x, starGroup.point.y + star.point.y)
          drawSquare(point: point, color: star.color, size:squareSize, fill: true)
        }
      }
    }
  }

  func drawSquare(point: NSPoint, color: NSColor, size: CGFloat, fill: Bool) {
    let ctx: CGContext = currentContext()
    ctx.saveGState()
    ctx.translateBy(x:point.x, y:point.y)
    color.set()
    let bPath = NSBezierPath.init()
    bPath.move(to: NSPoint.init(x:0, y:0))
    bPath.line(to: NSPoint.init(x:size + 1, y:0))
    bPath.line(to: NSPoint.init(x:size + 1, y:size))
    bPath.line(to:NSPoint.init(x:0, y:size))
    bPath.close()
    bPath.lineWidth = 2
    if fill {
      bPath.fill()
    } else {
      bPath.stroke()
    }
    ctx.restoreGState()
  }

  func getRandomColor() -> NSColor {
    let rand = SSRandomIntBetween(0, 5)
    switch rand {
    case 0:
      return NSColor.systemRed
    case 1:
      return NSColor.systemGreen
    case 2:
      return NSColor.systemBlue
    case 3:
      return NSColor.systemOrange
    case 4:
      return NSColor.systemPurple
    case 5:
      return NSColor.systemYellow
    case 6:
      return NSColor.systemGray
    default:
      return NSColor.white
    }
  }

  func getStarGroupType() -> StarGroupType {
    if SSRandomIntBetween(0, 1) == 0 {
      return .Butterfly
    } else {
      return .Dipper
    }
  }

  func setSizes(_ rect: NSRect) {
    if previewFlag {
      squareSize = maxY * 0.02
    } else {
      squareSize = maxY * 0.005
    }
    starGroupSize = squareSize * 5
  }

  override func viewDidMoveToWindow() {
    setBounds = true;
  }

  override func startAnimation() {
    super.startAnimation()
  }

  override func stopAnimation() {
    super.stopAnimation()
  }

  func currentContext() -> CGContext {
    return NSGraphicsContext.current!.cgContext
  }

}
