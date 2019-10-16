//
//  BlockGrid+logic.swift
//  Swiftris2
//
//  Created by Erik Buck on 9/26/19.
//  Copyright © 2019 WSU. All rights reserved.
//

import Foundation

extension BlockGrid {

   public func isOpen(_ x : Int16, _ y : Int16) -> Bool {
      for candidateBlock in  self.blocks! {
         if let block = candidateBlock as? Block {
            if(block.gridPositionX == x && block.gridPositionY == y) {
               return false
            }
         }
      }
      return true
   }
}
