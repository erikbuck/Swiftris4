//
//  SwiftrisView.swift
//  Swiftris3D
//
//  Created by Erik Buck on 10/14/19.
//  Copyright © 2019 Wright State University. All rights reserved.
//

import SceneKit

class SwiftrisView : SCNView, SCNSceneRendererDelegate {
   struct nodeInfo { 
      var node : SCNNode;
      var lastRotation : Int16; 
      var lastPositionX : Int16;
      var lastPositionY : Int16;
   }
   
   static var blockInfoToNodeDictionary = Dictionary<String, SCNNode>()
   static var fallingBlockInfo : nodeInfo?
   static var nextUniqueID : Int = 0
   static var blockGeometry = SCNBox(width: CGFloat(1), height: CGFloat(1), length: CGFloat(1), chamferRadius: CGFloat(1) * 0.1)
   static let rotationPeriod = 0.15
   static let horizontalMovementPeriod = 0.15
   static let playBlockRemoveSoundAction = SCNAction.playAudio(SCNAudioSource(named: "Magic.mp3")!, waitForCompletion: false)
   static let playWooshSoundAction = SCNAction.playAudio(SCNAudioSource(named: "Woosh.mp3")!, waitForCompletion: false)
   static let removeFromParentAction = SCNAction.sequence([
      SCNAction.wait(duration: TimeInterval(1)),
      SCNAction.removeFromParentNode()
   ])
   static let removeBlockParticleSystem = SCNParticleSystem(named: "confetti.scnp", inDirectory: nil)!
   static let tinyBoxGeometry = SCNBox(width: 0.001, height: 0.001, length: 0.001, chamferRadius: 0)
   var realBoardNode : SCNNode?
   let boardNode = SCNNode()
   var isPlayingWoosh = false
   
   static func getNextUniqueID() -> String {
      let result = String(SwiftrisView.nextUniqueID)
      SwiftrisView.nextUniqueID += 1
      return result
   }
   
   func animateFall(fallingBlock : FallingBlockGrid, fallRate: Float32, isFallingFast : Bool) {
      if var fallingBlockInfo = SwiftrisView.fallingBlockInfo {
         let fallingBlockNode = fallingBlockInfo.node 
         let deltaPositionY = fallingBlock.gridPositionY - fallingBlockInfo.lastPositionY
         if 0 != deltaPositionY {
            var period = 0.5 / fallRate
            if isFallingFast {
               period = 0.05
               if !isPlayingWoosh {
                  fallingBlockNode.runAction(SwiftrisView.playWooshSoundAction)
                  isPlayingWoosh = true
               }
            }
            fallingBlockNode.runAction(SCNAction.moveBy(x: 0, y: CGFloat(deltaPositionY), z: 0, duration: TimeInterval(period)))
            fallingBlockInfo.lastPositionY = fallingBlock.gridPositionY
            SwiftrisView.fallingBlockInfo = fallingBlockInfo
         }
      }
   }
   
   func animateHorizontal(fallingBlock : FallingBlockGrid) {
      if var fallingBlockInfo = SwiftrisView.fallingBlockInfo {
         let fallingBlockNode = fallingBlockInfo.node 
         let deltaPositionX = fallingBlock.gridPositionX - fallingBlockInfo.lastPositionX
         if 0 != deltaPositionX {
            fallingBlockNode.runAction(SCNAction.moveBy(x: CGFloat(deltaPositionX), y: 0, z: 0, duration: SwiftrisView.horizontalMovementPeriod))
            fallingBlockInfo.lastPositionX = fallingBlock.gridPositionX
            SwiftrisView.fallingBlockInfo = fallingBlockInfo
         }         
      }
   }
   
   func animateRotation(fallingBlock : FallingBlockGrid) {
      if var fallingBlockInfo = SwiftrisView.fallingBlockInfo {
         let fallingBlockNode = fallingBlockInfo.node 
         var deltaRotations = fallingBlock.rotations - SwiftrisView.fallingBlockInfo!.lastRotation
         
         if 0 != deltaRotations { // Some rotation is necessary
            if deltaRotations > 1 { // This is more than 90 deg.
               deltaRotations = -1  // Rotate clockwise avoids rotating 270 deg. counterclockwise       
            } else if deltaRotations < -1 { // This is less than -90 deg.
               deltaRotations = 1   // Rotate counterclockwise avoids rotating 270 deg. clockwise
            }
            
            fallingBlockNode.runAction(SCNAction.rotateBy(x: 0, y: 0, z: CGFloat.pi * -0.5 * CGFloat(deltaRotations), duration: SwiftrisView.rotationPeriod))
            fallingBlockInfo.lastRotation = fallingBlock.rotations
            SwiftrisView.fallingBlockInfo = fallingBlockInfo
         }
      }
   }
   
   func replaceFallingBlock(_ fallingBlock : FallingBlockGrid) {
      isPlayingWoosh = false
      if let fallingBlockNode = SwiftrisView.fallingBlockInfo?.node {
         // Remove any old falling block node
         fallingBlockNode.removeFromParentNode()
      }
      
      // Create a new node for the new falling block
      let fallingBlockNode = SCNNode()
      boardNode.addChildNode(fallingBlockNode)
      let blockWidth = CGFloat(1)
      let blockHeight = CGFloat(1)
      
      // Add node for falling block
      fallingBlockNode.runAction(SCNAction.rotateTo(x: 0, y: 0, z: CGFloat.pi * -0.5 * CGFloat(fallingBlock.rotations), duration: 0))
      fallingBlock.info = SwiftrisView.getNextUniqueID()
      SwiftrisView.fallingBlockInfo = nodeInfo(node : fallingBlockNode, lastRotation : fallingBlock.rotations, lastPositionX : fallingBlock.gridPositionX, lastPositionY : fallingBlock.gridPositionY)
      fallingBlockNode.position = SCNVector3(CGFloat(fallingBlock.gridPositionX) * 1,
                                             CGFloat(fallingBlock.gridPositionY) * 1, 0)
      
      // Add child nodes for blocks within falling block
      for candidateBlock in fallingBlock.blocks! {
         let block = candidateBlock as! Block
         if nil == block.info { // This must be a new block
            let newNode = SCNNode(geometry: SwiftrisView.blockGeometry)
            newNode.pivot = SCNMatrix4MakeTranslation(-0.5, -0.5, 0)
            newNode.geometry?.materials.first?.transparency = 0.7
            fallingBlockNode.addChildNode(newNode)
            block.info = SwiftrisView.getNextUniqueID()
            newNode.position = SCNVector3(x: Float(CGFloat(block.gridPositionX) * blockWidth), y:   Float(CGFloat(block.gridPositionY) * blockHeight), z: 0) 
         } 
      }
   }
   
   func updateFallingBlock() {
      let appDelegate = UIApplication.shared.delegate as! AppDelegate
      
      if let fallingBlock = appDelegate.game.fallingBlock { 
         if nil == fallingBlock.info { // This must be a new falling block
            replaceFallingBlock(fallingBlock)
         }
         
         animateRotation(fallingBlock : fallingBlock)
         animateHorizontal(fallingBlock : fallingBlock)
         animateFall(fallingBlock : fallingBlock, fallRate: appDelegate.game.fallRate, isFallingFast : appDelegate.game.isFallingFast)            
      }
   }
   
   func newRemoveParticleEmitter() -> SCNNode {
      let result = SCNNode()
      result.addParticleSystem(SwiftrisView.removeBlockParticleSystem)
      result.runAction(SwiftrisView.removeFromParentAction)
      return result
   }
   
   func updateAllBoardBlocks() {
      let appDelegate = UIApplication.shared.delegate as! AppDelegate
      
      // Update all of the nodes that correspond to blocks in the game board
      // If a node exists for a block that is no longer in the game board, remove
      // the node by not including it in setOfBlockNodesToKeep
      var setOfBlockNodesToKeep = Set<String>()
      for candidateBlock in appDelegate.game.board!.blocks! {
         let block = candidateBlock as! Block
         if nil == block.info || nil == SwiftrisView.blockInfoToNodeDictionary[block.info!] {
            let newNode = SCNNode(geometry: SwiftrisView.blockGeometry)
            newNode.pivot = SCNMatrix4MakeTranslation(-0.5, -0.5, 0)
            boardNode.addChildNode(newNode)
            block.info = SwiftrisView.getNextUniqueID()
            SwiftrisView.blockInfoToNodeDictionary[block.info!] = newNode
         } 
         let node = SwiftrisView.blockInfoToNodeDictionary[block.info!]!
         node.position = SCNVector3(x: Float(CGFloat(block.gridPositionX) * 1), y: Float(CGFloat(block.gridPositionY) * 1), z: 0)
         setOfBlockNodesToKeep.insert(block.info!)
      }
      
      var isPlayingSound = false
      
      // Remove all block nodes that are not in the set of blocks to keep
      SwiftrisView.blockInfoToNodeDictionary = SwiftrisView.blockInfoToNodeDictionary.filter { (key: String, value: SCNNode) -> Bool in
         let result = setOfBlockNodesToKeep.contains(key)
         if !result {
            let newEmitter = newRemoveParticleEmitter()
            newEmitter.position = value.position
            newEmitter.geometry = SwiftrisView.tinyBoxGeometry
            boardNode.addChildNode(newEmitter)
            SwiftrisView.blockInfoToNodeDictionary[key]!.removeFromParentNode()
            if !isPlayingSound {
               boardNode.runAction(SwiftrisView.playBlockRemoveSoundAction)
               isPlayingSound = true
            }
         }
         return result
      }
   }
   
   func update() {
      self.updateFallingBlock()
      self.updateAllBoardBlocks() 
   }
}
