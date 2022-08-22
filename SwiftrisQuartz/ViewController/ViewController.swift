//
//  ViewController.swift
//  Swiftris2
//
//  Created by Erik Buck on 9/26/19.
//  Copyright © 2019 WSU. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var gameOverView : UIView?
    @IBOutlet var gameView : QuartzGameView?
    @IBOutlet var scoreLabel : UILabel?
    @IBOutlet var highScoreLabel : UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Model.shared.updateHandler = {
            self.update()
        }
        Model.shared.update()
    }
    
    public func update() {
        self.gameView!.setNeedsDisplay()
        self.gameOverView?.isHidden = !Model.shared.game.isOver
        scoreLabel?.text = String(Model.shared.game.score)
        highScoreLabel?.text = String(Model.shared.game.highScore)
    }
}

