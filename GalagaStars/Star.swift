//
//  Star.swift
//  GalagaStars
//
//  Created by ran on 9/3/19.
//  Copyright © 2019 ran. All rights reserved.
//

import ScreenSaver

class Star: NSObject {
  var point: NSPoint
  var direction: NSPoint
  var color: NSColor
  var count: Int = 0
  var visible: Bool = true

  init(point:NSPoint, direction:NSPoint, color:NSColor, count:Int) {
    self.point = point
    self.direction = direction
    self.color = color
    self.count = count
  }

  func update() {
    count += 1
    let newPoint = NSMakePoint(point.x + direction.x, point.y + direction.y)
    point = newPoint
    if count % 30 == 0 {
      visible = !visible
    }
  }

  func isAlive(_ rect: NSRect) -> Bool {
    if rect.minX <= point.x && point.x <= rect.maxX {
      if rect.minY <= point.y && point.y <= rect.maxY {
        return true
      }
    }
    return false
  }

  func isAlive(_ rect: NSRect, _ offset: NSPoint) -> Bool {
    if rect.minX <= point.x + offset.x && point.x + offset.x <= rect.maxX {
      if rect.minY <= point.y + offset.y && point.y + offset.y <= rect.maxY {
        return true
      }
    }
    return false
  }

}
