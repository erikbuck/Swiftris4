//
//  GameScene.swift
//  Swiftris4 Shared
//
//  Created by Erik Buck on 10/4/19.
//  Copyright © 2019 CosmicThump. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
   struct nodeInfo { 
      var node : SKNode;
      var lastRotation : Int16; 
      var lastPositionX : Int16;
      var lastPositionY : Int16;
   }
   
   static var blockInfoToNodeDictionary = Dictionary<String, SKNode>()
   static var fallingBlockInfo : nodeInfo?
   static var nextUniqueID : Int = 0
   static let rotationPeriod = 0.15
   static let horizontalMovementPeriod = 0.15
   static let removeSound = SKAction.playSoundFileNamed("Magic.mp3", waitForCompletion: false)
   static let wooshSound = SKAction.playSoundFileNamed("Woosh.mp3", waitForCompletion: false)
   static let removeAfterDelayAction =  SKAction.sequence([SKAction.wait(forDuration: 1.0), SKAction.removeFromParent()])

   let boardNode = SKSpriteNode(texture: SKTexture(imageNamed: "green-background-images-23.jpg"))
   var isPlayingWoosh = false
   
   static func getNextUniqueID() -> String {
      let result = String(GameScene.nextUniqueID)
      GameScene.nextUniqueID += 1
      return result
   }
   
   func animateFall(fallingBlock : FallingBlockGrid, fallRate: Float32, isFallingFast : Bool) {
      if var fallingBlockInfo = GameScene.fallingBlockInfo {
         let fallingBlockNode = fallingBlockInfo.node 
         let deltaPositionY = fallingBlock.gridPositionY - fallingBlockInfo.lastPositionY
         if 0 != deltaPositionY {
            var period = 0.5 / fallRate
            if isFallingFast {
               period = 0.05
               if !isPlayingWoosh {
                  boardNode.run(GameScene.wooshSound)
                  isPlayingWoosh = true
               }
            }
            fallingBlockNode.run(SKAction.moveBy(x: 0, y: CGFloat(deltaPositionY), duration: TimeInterval(period)))
            fallingBlockInfo.lastPositionY = fallingBlock.gridPositionY
            GameScene.fallingBlockInfo = fallingBlockInfo
         }
      }
   }
   
   func animateHorizontal(fallingBlock : FallingBlockGrid) {
      if var fallingBlockInfo = GameScene.fallingBlockInfo {
         let fallingBlockNode = fallingBlockInfo.node 
         let deltaPositionX = fallingBlock.gridPositionX - fallingBlockInfo.lastPositionX
         if 0 != deltaPositionX {
            fallingBlockNode.run(SKAction.moveBy(x: CGFloat(deltaPositionX), y: 0, duration: GameScene.horizontalMovementPeriod))
            fallingBlockInfo.lastPositionX = fallingBlock.gridPositionX
            GameScene.fallingBlockInfo = fallingBlockInfo
         }         
      }
   }
   
   func animateRotation(fallingBlock : FallingBlockGrid) {
      if var fallingBlockInfo = GameScene.fallingBlockInfo {
         let fallingBlockNode = fallingBlockInfo.node 
         var deltaRotations = fallingBlock.rotations - GameScene.fallingBlockInfo!.lastRotation
      
         if 0 != deltaRotations { // Some rotation is necessary
            if deltaRotations > 1 { // This is more than 90 deg.
               deltaRotations = -1  // Rotate clockwise avoids rotating 270 deg. counterclockwise       
            } else if deltaRotations < -1 { // This is less than -90 deg.
               deltaRotations = 1   // Rotate counterclockwise avoids rotating 270 deg. clockwise
            }
            fallingBlockNode.run(SKAction.rotate(byAngle: CGFloat.pi * -0.5 * CGFloat(deltaRotations), duration: GameScene.rotationPeriod))
            fallingBlockInfo.lastRotation = fallingBlock.rotations
            GameScene.fallingBlockInfo = fallingBlockInfo
         }
      }
   }
   
   func replaceFallingBlock(_ fallingBlock : FallingBlockGrid) {
      isPlayingWoosh = false
      if let fallingBlockNode = GameScene.fallingBlockInfo?.node {
         // Remove any old falling block node
         fallingBlockNode.removeFromParent()
      }
      
      // Create a new node for the new falling block
      let fallingBlockNode = SKSpriteNode()
      let boardSize = boardNode.frame.size
      let boardHeight = boardSize.height
      let boardWidth = boardSize.width
      let blockWidth = boardWidth / CGFloat(BoardBlockGrid.width)
      let blockHeight = boardHeight / CGFloat(BoardBlockGrid.height)
      
      // Add node for falling block
      // Put anchor in center of 4x4 block that encloses all falling block shapes
      fallingBlockNode.size = CGSize(width: 4, height: 4) 
      fallingBlockNode.zRotation = CGFloat.pi * -0.5 * CGFloat(fallingBlock.rotations)
      boardNode.addChild(fallingBlockNode)
      fallingBlock.info = GameScene.getNextUniqueID()
      GameScene.fallingBlockInfo = nodeInfo(node : fallingBlockNode, lastRotation : fallingBlock.rotations, lastPositionX : fallingBlock.gridPositionX, lastPositionY : fallingBlock.gridPositionY)
      fallingBlockNode.position = CGPoint(x: CGFloat(fallingBlock.gridPositionX) * blockWidth, y: CGFloat(fallingBlock.gridPositionY) * blockHeight)
      
      // Add child nodes for blocks within falling block
      for candidateBlock in fallingBlock.blocks! {
         let block = candidateBlock as! Block
         if nil == block.info { // This must be a new block
            let newNode = SKSpriteNode(imageNamed: "block")
            newNode.size = CGSize(width:blockWidth, height:blockHeight)
            newNode.anchorPoint = CGPoint.zero
            newNode.zPosition = 1
            fallingBlockNode.addChild(newNode)
            block.info = GameScene.getNextUniqueID()
            newNode.position = CGPoint(x: CGFloat(block.gridPositionX) * blockWidth, y:   CGFloat(block.gridPositionY) * blockHeight) 
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
   
   func newRemoveParticleEmitter() -> SKEmitterNode {
       let result = SKEmitterNode(fileNamed: "RemoveParticle.sks")!
       result.numParticlesToEmit = 40
       result.setScale(0.15)
       result.position = CGPoint(x:0.5, y:0.5)
       result.run(GameScene.removeAfterDelayAction)
       return result
   }
   
   func updateAllBoardBlocks() {
      let boardSize = boardNode.frame.size
      let boardHeight = boardSize.height
      let boardWidth = boardSize.width
      let blockWidth = boardWidth / CGFloat(BoardBlockGrid.width)
      let blockHeight = boardHeight / CGFloat(BoardBlockGrid.height)
      let appDelegate = UIApplication.shared.delegate as! AppDelegate
      
      // Update all of the nodes that correspond to blocks in the game board
      // If a node exists for a block that is no longer in the game board, remove
      // the node by not including it in setOfBlockNodesToKeep
      var setOfBlockNodesToKeep = Set<String>()
      for candidateBlock in appDelegate.game.board!.blocks! {
         let block = candidateBlock as! Block
         if nil == block.info || nil == GameScene.blockInfoToNodeDictionary[block.info!] {
            let newNode = SKSpriteNode(imageNamed: "block")
            newNode.size = CGSize(width:blockWidth, height:blockHeight)
            newNode.anchorPoint = CGPoint.zero
            newNode.zPosition = 1
            boardNode.addChild(newNode)
            block.info = GameScene.getNextUniqueID()
            GameScene.blockInfoToNodeDictionary[block.info!] = newNode
         } 
         let node = GameScene.blockInfoToNodeDictionary[block.info!]!
         node.position = CGPoint(x: CGFloat(block.gridPositionX) * blockWidth, y: CGFloat(block.gridPositionY) * blockHeight)
         setOfBlockNodesToKeep.insert(block.info!)
      }

      var isPlayingSound = false
      
      // Remove all block nodes that are not in the set of blocks to keep
      GameScene.blockInfoToNodeDictionary = GameScene.blockInfoToNodeDictionary.filter { (key: String, value: SKNode) -> Bool in
         let result = setOfBlockNodesToKeep.contains(key)
         if !result {
            let newEmitter = newRemoveParticleEmitter()
            newEmitter.position = GameScene.blockInfoToNodeDictionary[key]!.position
            boardNode.addChild(newEmitter)
            GameScene.blockInfoToNodeDictionary[key]!.removeFromParent()
            if !isPlayingSound {
               boardNode.run(GameScene.removeSound)
               isPlayingSound = true
            }
         }
         return result
      }
   }
   
   override func update(_ currentTime: TimeInterval) {
      // Called before each frame is rendered
      updateFallingBlock()
      updateAllBoardBlocks()      
   }
}
