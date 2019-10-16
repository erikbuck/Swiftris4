//
//  GameViewController.swift
//  Swiftris3D
//
//  Created by Erik Buck on 10/14/19.
//  Copyright © 2019 Wright State University. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class ViewController: UIViewController {
   
   @IBOutlet var gameOverView : UIView?
   @IBOutlet var gameView : SwiftrisView?
   @IBOutlet var scoreLabel : UILabel?
   @IBOutlet var highScoreLabel : UILabel?
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      // create a new scene
      let scene = SCNScene(named: "art.scnassets/game.scn")!
      
      // create and add a camera to the scene
      let cameraNode = SCNNode()
      cameraNode.camera = SCNCamera()
      scene.rootNode.addChildNode(cameraNode)
      
      // place the camera
      cameraNode.position = SCNVector3(x: 5, y: 4, z: 25)
      cameraNode.eulerAngles = SCNVector3(x: Float.pi * 0.09, y: 0, z: 0)
      
      // create and add a light to the scene
      let lightNode = SCNNode()
      lightNode.light = SCNLight()
      lightNode.light!.type = .omni
      lightNode.position = SCNVector3(x: 0, y: 10, z: 20)
      scene.rootNode.addChildNode(lightNode)
      
      // create and add an ambient light to the scene
      let ambientLightNode = SCNNode()
      ambientLightNode.light = SCNLight()
      ambientLightNode.light!.type = .ambient
      ambientLightNode.light!.color = UIColor.darkGray
      scene.rootNode.addChildNode(ambientLightNode)
      
      let background = SCNNode(geometry: SCNPlane(width: 10, height: 28))
      background.position = SCNVector3(5, 14, -0.5)
      background.geometry?.materials.first?.diffuse.contents = UIImage(named: "multiwavelength-crab-nebula-wallpaper.jpg")
      scene.rootNode.addChildNode(background)
      scene.rootNode.addChildNode(gameView!.boardNode)
      
      gameView!.delegate = gameView
      gameView!.scene = scene
      gameView!.allowsCameraControl = true
      gameView!.showsStatistics = true
      gameView!.backgroundColor = UIColor.black
   }
   
   public func update() {
      let appDelegate = UIApplication.shared.delegate as! AppDelegate
      self.gameOverView?.isHidden = !appDelegate.game.isOver
      scoreLabel?.text = String(appDelegate.game.score)
      highScoreLabel?.text = String(appDelegate.game.highScore)
      gameView!.update()
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
