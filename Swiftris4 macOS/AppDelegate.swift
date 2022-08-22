//
//  AppDelegate.swift
//  Swiftris4 macOS
//
//  Created by Erik Buck on 10/4/19.
//  Copyright © 2019 CosmicThump. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBAction func start(_ : Any) {
        Model.shared.game.start()
        Model.shared.update()
    }
    
    @IBAction func moveLeft(_ : Any) {
        Model.shared.game.moveFallingBlockLeft()
    }
    
    @IBAction func moveRight(_ : Any) {
        Model.shared.game.moveFallingBlockRight()
    }
    
    @IBAction func rotateClockwise(_ : Any) {
        Model.shared.game.rotateFallingBlockClockwise()
    }
    
    @IBAction func rotateCounterclockwise(_ : Any) {
        Model.shared.game.rotateFallingBlockCounterclockwise()
    }
    
    @IBAction func drop(_ : Any) {
        Model.shared.game.fallFast()
    }
    
    private func applicationWillResignActive(_ application: NSApplication) {
        Model.shared.game.isPaused = true
        Model.shared.saveContext()
    }
    
    private func applicationDidBecomeActive(_ application: NSApplication) {
        Model.shared.game.isPaused = false
        Model.shared.update()
    }
    
    private func applicationWillTerminate(_ application: NSApplication) {
        Model.shared.saveContext()
    }
}
