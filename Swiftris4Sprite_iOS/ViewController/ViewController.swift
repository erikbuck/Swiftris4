//
//  GameViewController.swift
//  SwiftrisSprite
//
//  Created by Erik Buck on 9/30/19.
//  Copyright © 2019 WSU. All rights reserved.
//

import UIKit
import QuartzCore
import SpriteKit

class ViewController: UIViewController {
    @IBOutlet var gameOverView : UIView?
    @IBOutlet var gameView : SKView?
    @IBOutlet var scoreLabel : UILabel?
    @IBOutlet var highScoreLabel : UILabel?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let scene = GameScene() 
        
        scene.size = CGSize(width: CGFloat(BoardBlockGrid.width), height: CGFloat(BoardBlockGrid.height))
        scene.anchorPoint = CGPoint.zero
        scene.scaleMode = .aspectFit
        scene.backgroundColor = UIColor.clear
        
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
        scoreLabel?.text = String(Model.shared.game.score)
        highScoreLabel?.text = String(Model.shared.game.highScore)
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
}
