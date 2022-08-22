//
//  QuartzGameView.swift
//  Swiftris2
//
//  Created by Erik Buck on 9/26/19.
//  Copyright © 2019 WSU. All rights reserved.
//

import UIKit

class QuartzGameView : UIView {
   
   static let defaultStrokeColor = UIColor.black
   static let alternateStrokeColor = UIColor.blue
   static let defaultFillColor = UIColor.init(displayP3Red: 0.1, green: 0.1, blue: 0.6, alpha: 0.6)
   
   public override func draw(_ rect: CGRect) {
      self.layer.transform = CATransform3DMakeScale(1, -1, 1)
      let blockWidth = bounds.size.width / CGFloat(BoardBlockGrid.width)
      let blockHeight = bounds.size.height / CGFloat(BoardBlockGrid.height)
      QuartzGameView.defaultStrokeColor.setStroke()
      QuartzGameView.defaultFillColor.setFill()
       for candidateBlock in Model.shared.game.board!.blocks! {
         let block = candidateBlock as! Block
         let blockRect = CGRect(x: CGFloat(block.gridPositionX) * blockWidth, 
                                y: CGFloat(block.gridPositionY) * blockHeight, 
                                width: blockWidth, 
                                height: blockHeight)
         let path = UIBezierPath(rect: blockRect)
         path.fill()
         path.stroke()
      }
      
      QuartzGameView.defaultFillColor.setStroke()
       if let fallingBlock = Model.shared.game.fallingBlock {
         for candidateBlock in fallingBlock.blocks! {
            let block = candidateBlock as! Block
            let (x, y) = fallingBlock.transformedGridPosition(
               block.gridPositionX, block.gridPositionY)
            let blockRect = CGRect(x: CGFloat(x) * blockWidth, 
                                   y: CGFloat(y) * blockHeight, 
                                   width: blockWidth, 
                                   height: blockHeight)
            let path = UIBezierPath(rect: blockRect)
            path.fill()
            path.stroke()
         }
      }
   }
}
