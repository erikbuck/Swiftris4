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
   
   public lazy var game : Game = {
      let managedContext = self.persistentContainer.viewContext
      var game : Game
      let games = try! managedContext.fetch(Game.fetchRequest())
      if(0 < games.count)
      {
         game = games.last as! Game
      } else {
         let gameEntity = NSEntityDescription.entity(forEntityName: "Game", in: managedContext)!
         if let newGame = NSManagedObject(entity: gameEntity, insertInto: managedContext) as? Game {
            game = newGame
            let boardEntity = NSEntityDescription.entity(forEntityName: "BoardBlockGrid", in: managedContext)!
            game.board = (NSManagedObject(entity: boardEntity, insertInto: managedContext) as! BoardBlockGrid)
         } else {
            fatalError("Failed to create Game")
         }
      }
      
      return game
   }()
   
   @IBAction func start() {
      self.game.start()
      self.update()
   }
   
   @IBAction func moveLeft() {
      game.moveFallingBlockLeft()
   }
   
   @IBAction func moveRight() {
      game.moveFallingBlockRight()
   }
   
   @IBAction func rotateClockwise() {
      game.rotateFallingBlockClockwise()
   }
   
   @IBAction func rotateCounterclockwise() {
      game.rotateFallingBlockCounterclockwise()
   }
   
   @IBAction func drop() {
      game.fallFast()
   }
   
   public func update() {
      let managedContext = self.persistentContainer.viewContext
      game.update(managedContext)
      let controller = window!.rootViewController! as! ViewController
      controller.update()
      if !game.isOver && !game.isPaused {
         DispatchQueue.main.asyncAfter(deadline: .now() + 0.017) {
            self.update()
         }
      }
   }
   
   func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool { 
      return true
   }
   
   func applicationWillResignActive(_ application: UIApplication) {
      game.isPaused = true
      self.saveContext()
   }
   
   func applicationDidEnterBackground(_ application: UIApplication) {
   }
   
   func applicationWillEnterForeground(_ application: UIApplication) {
   }
   
   func applicationDidBecomeActive(_ application: UIApplication) {
      game.isPaused = false
      self.update()
   }
   
   func applicationWillTerminate(_ application: UIApplication) {
      // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
      // Saves changes in the application's managed object context before the application terminates.
      self.saveContext()
   }
   
   // MARK: - Core Data stack
   
   lazy var persistentContainer: NSPersistentContainer = {
      /*
       The persistent container for the application. This implementation
       creates and returns a container, having loaded the store for the
       application to it. This property is optional since there are legitimate
       error conditions that could cause the creation of the store to fail.
       */
      let container = NSPersistentContainer(name: "Swiftris2")
      container.loadPersistentStores(completionHandler: { (storeDescription, error) in
         if let error = error as NSError? {
            fatalError("Unresolved error \(error), \(error.userInfo)")
         }
      })
      return container
   }()
   
   // MARK: - Core Data Saving support
   
   func saveContext () {
      let context = persistentContainer.viewContext
      if context.hasChanges {
         do {
            try context.save()
         } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
         }
      }
   }
   
}

