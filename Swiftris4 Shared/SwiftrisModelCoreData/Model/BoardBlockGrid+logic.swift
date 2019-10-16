//
//  BoardBlockGrid+logic.swift
//  Swiftris2
//
//  Created by Erik Buck on 9/26/19.
//  Copyright © 2019 WSU. All rights reserved.
//

import Foundation

extension BoardBlockGrid {

   static let width = Int16(10)
   static let height = Int16(28)
   
   public func isRowFull(_ y : Int16) -> Bool {
      var isFull = true
      for i in 0..<BoardBlockGrid.width {
         if self.isOpen(i, y) {
            isFull = false
            break
         }
      }
      return isFull
   }
   
   public func removeRow(_ y : Int16) {
     let blocksToRemove = NSMutableSet()
     for candidateBlock in self.blocks! {
         let block = candidateBlock as! Block
         if block.gridPositionY == y {
            blocksToRemove.add(block)
         } else if block.gridPositionY > y {
            block.gridPositionY -= 1
         }
     } 
     self.removeFromBlocks(blocksToRemove)
     self.game!.fallRate += 0.02
   }
   
   public func canInsert(_ fallingBlockGrid : FallingBlockGrid) -> Bool {
      for currentBlockCandidate in fallingBlockGrid.blocks! {
         if let currentBlock = currentBlockCandidate as? Block {
            let (gameX, gameY) = fallingBlockGrid.transformedGridPosition( currentBlock.gridPositionX, currentBlock.gridPositionY)
            let isOffBoardX = gameX < Int16(0) || gameX >= BoardBlockGrid.width
            let isOffBoardY = gameY < Int16(0)
            if(isOffBoardX || isOffBoardY || !isOpen(gameX, gameY)) {
               return false
            }
         }
      }
      
      return true
   }
}
