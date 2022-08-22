//
//  AppDelegate.swift
//  Swiftris2
//
//  Created by Erik Buck on 9/26/19.
//  Copyright © 2019 WSU. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    @IBAction func start() {
        Model.shared.game.start()
        Model.shared.update()
    }
    
    @IBAction func moveLeft() {
        Model.shared.game.moveFallingBlockLeft()
    }
    
    @IBAction func moveRight() {
        Model.shared.game.moveFallingBlockRight()
    }
    
    @IBAction func rotateClockwise() {
        Model.shared.game.rotateFallingBlockClockwise()
    }
    
    @IBAction func rotateCounterclockwise() {
        Model.shared.game.rotateFallingBlockCounterclockwise()
    }
    
    @IBAction func drop() {
        Model.shared.game.fallFast()
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool { 
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        Model.shared.game.isPaused = true
        Model.shared.saveContext()
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        Model.shared.game.isPaused = false
        Model.shared.update()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        Model.shared.saveContext()
    }
}

