//
//  StarGroup.swift
//  GalagaStars
//
//  Created by ran on 9/3/19.
//  Copyright © 2019 ran. All rights reserved.
//

import ScreenSaver

enum StarGroupType {
  case Butterfly
  case Dipper
}

class StarGroup: NSObject {

  var point: NSPoint
  var direction: NSPoint
  var stars: [Star] = []
  var visible = true
  var color: NSColor
  var count = 0

  init(rect: NSRect, starGroupType: StarGroupType, squareSize: CGFloat, direction: NSPoint, color: NSColor, count: Int) {
    self.direction = direction
    self.color = color
    self.count = count
    let maxXHalf = (rect.minX + rect.maxX)/2
    switch starGroupType {
    case .Butterfly:
      // right half
      let newX = SSRandomFloatBetween(rect.minX + maxXHalf, rect.maxX)
      self.point = NSMakePoint(newX, rect.maxY)
      // left
      stars.append(Star(point:NSMakePoint(0, squareSize*20), direction:direction, color:color, count:count))
      stars.append(Star(point:NSMakePoint(squareSize, 0), direction:direction, color:color, count:count))
      // middle
      stars.append(Star(point:NSMakePoint(squareSize*18, squareSize*18), direction:direction, color:color, count:count))
      stars.append(Star(point:NSMakePoint(squareSize*19, squareSize*14), direction:direction, color:color, count:count))
      stars.append(Star(point:NSMakePoint(squareSize*20, squareSize*9), direction:direction, color:color, count:count))
      // right
      stars.append(Star(point:NSMakePoint(squareSize*32, squareSize*27), direction:direction, color:color, count:count))
      stars.append(Star(point:NSMakePoint(squareSize*42, squareSize*4), direction:direction, color:color, count:count))
    case .Dipper:
      // left half
      let newX = SSRandomFloatBetween(rect.minX, rect.minX + maxXHalf)
      self.point = NSMakePoint(newX, rect.maxY)
      // pot
      stars.append(Star(point:NSMakePoint(0, squareSize*50), direction:direction, color:color, count:count))
      stars.append(Star(point:NSMakePoint(squareSize*5, squareSize*31), direction:direction, color:color, count:count))
      stars.append(Star(point:NSMakePoint(squareSize*14, squareSize*51), direction:direction, color:color, count:count))
      stars.append(Star(point:NSMakePoint(squareSize*17, squareSize*38), direction:direction, color:color, count:count))
      // handle
      stars.append(Star(point:NSMakePoint(squareSize*7, squareSize*21), direction:direction, color:color, count:count))
      stars.append(Star(point:NSMakePoint(squareSize*15, squareSize*10), direction:direction, color:color, count:count))
      stars.append(Star(point:NSMakePoint(squareSize*17, squareSize*0), direction:direction, color:color, count:count))
    }
  }

  func update() {
    count += 1
    point = NSMakePoint(point.x + direction.x, point.y + direction.y)
    if count % 30 == 0 {
      visible = !visible
      for star in stars {
        star.visible = visible
      }
    }
  }

  func isAlive(_ rect: NSRect) -> Bool {
    let alive = stars.filter {
      let star = ($0 as Star)
      return star.isAlive(rect, point)
    }
    return !alive.isEmpty
  }

}
