//
//  FallingBlockGrid+logic.swift
//  Swiftris2
//
//  Created by Erik Buck on 9/26/19.
//  Copyright © 2019 WSU. All rights reserved.
//

import Foundation
import CoreData
import CoreGraphics

extension FallingBlockGrid {
   private static let blockPatterns : [[[Int16]]] = [
      [[-2, 0], [-1, 0], [0, 0], [1, 0]],    // long
      [[-1, -1], [0, -1], [-1, 0], [0, 0]],  // square
      [[-1, -1], [-1, 0], [-1, 1], [0, 1]],  // L right
      [[0, -1], [0, 0], [0, 1], [-1, 1]],    // L left    
      [[-1, -1], [0, -1], [0, 0], [1, 0]],   // Z backwards
      [[-1, 0], [0, 0], [0, -1], [1, -1]],   // Z
      [[-1, 0], [0, 0], [1, 0], [0, 1]],     // T
   ]
   
   static func generateRandom(_ managedContext : NSManagedObjectContext) -> FallingBlockGrid {
      let index = Int.random(in: 0..<blockPatterns.count)
      let entity = NSEntityDescription.entity(forEntityName: "FallingBlockGrid", in: managedContext)!
      let result = (NSManagedObject(entity: entity, insertInto: managedContext) as! FallingBlockGrid)
      result.addBlocks(FallingBlockGrid.blockPatterns[index], managedContext: managedContext)
      return result
   }
   
   public func changeRotations(_ delta : Int16) {
      // Make sure self.rotations stays in range 0..<4 even if delta is negative
      self.rotations = (self.rotations + delta + 4) % 4
   }
   
   private func addBlocks(_ pattern : [[Int16]], managedContext : NSManagedObjectContext) {
      for i in 0...3 {
         let entity = NSEntityDescription.entity(forEntityName: "Block", in: managedContext)!
         let newBlock = (NSManagedObject(entity: entity, insertInto: managedContext) as! Block)
         newBlock.gridPositionX = pattern[i][0]
         newBlock.gridPositionY = pattern[i][1]
         addToBlocks(newBlock)
      }
   }
   
   public func transformedGridPosition(_ x : Int16, _ y : Int16) -> (Int16, Int16) {
      let quadrant = rotations % 4
      if(1 == quadrant) {
         return (y + gridPositionX, -x + gridPositionY - 1)
      } else if(2 == quadrant) {
         return (-x + gridPositionX - 1, -y + gridPositionY - 1)
      } else if(3 == quadrant) {
         return (-y + gridPositionX - 1, x + gridPositionY)
      }
      return (x + gridPositionX, y + gridPositionY)
   }
   
   func transferBlocks(_ blockGrid : BlockGrid) {
      let blocksToTransfer = self.blocks!.copy() as! NSSet
      self.removeFromBlocks(blocksToTransfer)
      for candidateBlock in blocksToTransfer {
         let block = candidateBlock as! Block 
         (block.gridPositionX, block.gridPositionY) = transformedGridPosition(
            block.gridPositionX, block.gridPositionY)
         
      }
      blockGrid.addToBlocks(blocksToTransfer)
   }
}
