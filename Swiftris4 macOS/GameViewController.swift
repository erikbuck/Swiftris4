//
//  GameViewController.swift
//  Swiftris4 macOS
//
//  Created by Erik Buck on 10/4/19.
//  Copyright © 2019 CosmicThump. All rights reserved.
//

import Cocoa
import SpriteKit
import GameplayKit

class GameViewController: NSViewController {
    @IBOutlet var gameOverView : NSView?
    @IBOutlet var gameView : SKView?
    @IBOutlet var scoreLabel : NSTextField?
    @IBOutlet var highScoreLabel : NSTextField?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scene = GameScene()
        
        scene.size = CGSize(width: CGFloat(BoardBlockGrid.width), height: CGFloat(BoardBlockGrid.height))
        scene.anchorPoint = CGPoint.zero
        scene.scaleMode = .aspectFit
        scene.backgroundColor = NSColor.clear
        
        // Configure board node to replicate Quartz coordinate system
        scene.boardNode.size = scene.size
        scene.boardNode.anchorPoint = CGPoint.zero
        scene.boardNode.zPosition = -1
        scene.addChild(scene.boardNode)
        
        // Present the scene
        gameView!.presentScene(scene)
        gameView!.ignoresSiblingOrder = true
        gameView!.showsFPS = true
        gameView!.showsNodeCount = true
        
        Model.shared.updateHandler = {
            self.update()
        }
        Model.shared.update()
    }

    public func update() {
        self.gameOverView?.isHidden = !Model.shared.game.isOver
        scoreLabel?.stringValue = String(Model.shared.game.score)
        highScoreLabel?.stringValue = String(Model.shared.game.highScore)
    }
}

