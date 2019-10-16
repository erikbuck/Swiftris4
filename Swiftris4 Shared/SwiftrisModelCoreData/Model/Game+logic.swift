//
//  Game+logic.swift
//  Swiftris2
//
//  Created by Erik Buck on 9/26/19.
//  Copyright © 2019 WSU. All rights reserved.
//

import Foundation
import CoreData

extension Game {
   static var lastTime = DispatchTime(uptimeNanoseconds: 0)
   
   public func addNewFallingBlock(_ managedContext : NSManagedObjectContext) {
      if nil != self.fallingBlock {
         managedContext.delete(self.fallingBlock!)
      }
      self.fallingBlock = FallingBlockGrid.generateRandom(managedContext)
      if let newFallingBlock = self.fallingBlock {
         newFallingBlock.gridPositionX = BoardBlockGrid.width / 2
         newFallingBlock.gridPositionY = BoardBlockGrid.height
         newFallingBlock.rotations = Int16.random(in: 0..<4)
      }
      self.isFallingFast = false
   }
   
   private func removeCompleteRows() {
      for j in (0..<BoardBlockGrid.height).reversed() {
         if self.board!.isRowFull(j) {
            self.board!.removeRow(j)
            self.score += 1
            self.highScore = max(self.score, self.highScore)
         }
      }
   }
   
   public func start() {
      self.isOver = false
      self.isPaused = false
      self.fallRate = 1
      self.score = 0
      self.board?.blocks = NSSet()
   }
   
   public func update(_ managedContext : NSManagedObjectContext) {
      if let currentFallingBlock = self.fallingBlock {
         var delay = Double(0.5 / self.fallRate)
         if self.isFallingFast {
            delay = 0.02
         }
         let now = DispatchTime.now()
         let deltaNanoseconds = now.uptimeNanoseconds - Game.lastTime.uptimeNanoseconds
         if deltaNanoseconds > UInt64(delay * 1000000000) {
            Game.lastTime = now
            currentFallingBlock.gridPositionY -= 1

            if(!self.board!.canInsert(currentFallingBlock)) {
               // Block has collided
               currentFallingBlock.gridPositionY += 1
               currentFallingBlock.transferBlocks(self.board!)
               self.fallingBlock = nil
               self.removeCompleteRows()
               
               if BoardBlockGrid.height <= currentFallingBlock.gridPositionY {
                  isOver = true
               }
            }
         }
      } else {
         addNewFallingBlock(managedContext)
      }
   }
   
   public func moveFallingBlockLeft() {
      if let currentFallingBlock = self.fallingBlock {
         currentFallingBlock.gridPositionX -= 1
         if(!self.board!.canInsert(currentFallingBlock)) {
            currentFallingBlock.gridPositionX += 1 // rotation wasn't valid so undo
         }
      }
   }
   
   public func moveFallingBlockRight() {
      if let currentFallingBlock = self.fallingBlock {
         currentFallingBlock.gridPositionX += 1
         if(!self.board!.canInsert(currentFallingBlock)) {
            currentFallingBlock.gridPositionX -= 1 // rotation wasn't valid so undo
         }
      }
   }
   
   public func rotateFallingBlockClockwise() {
      if let currentFallingBlock = self.fallingBlock {
         currentFallingBlock.changeRotations(1) // rotations in units of 90 deg (pi/2 rad)
         if(!self.board!.canInsert(currentFallingBlock)) {
            currentFallingBlock.changeRotations(-1) // rotation wasn't valid so undo
         }
      }
   }
   
   public func rotateFallingBlockCounterclockwise() {
      if let currentFallingBlock = self.fallingBlock {
         currentFallingBlock.changeRotations(-1) // rotations in units of 90 deg (pi/2 rad)
         if(!self.board!.canInsert(currentFallingBlock)) {
            currentFallingBlock.changeRotations(1) // rotation wasn't valid so undo
         }
      }
   }
   
   public func fallFast() {
      if nil != self.fallingBlock {
         self.isFallingFast = true
      }
   }
}
