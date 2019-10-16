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
      let appDelegate = UIApplication.shared.delegate as! AppDelegate
      appDelegate.update()
   }
   
   public func update() {
      self.gameView!.setNeedsDisplay()
      let appDelegate = UIApplication.shared.delegate as! AppDelegate
      self.gameOverView?.isHidden = !appDelegate.game.isOver
      scoreLabel?.text = String(appDelegate.game.score)
      highScoreLabel?.text = String(appDelegate.game.highScore)
   }
}

