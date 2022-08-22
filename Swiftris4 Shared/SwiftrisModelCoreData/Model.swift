//
//  Model.swift
//  Swiftris4
//
//  Created by wsucatslabs on 8/22/22.
//  Copyright © 2022 CosmicThump. All rights reserved.
//

import CoreData

class Model {
    public static var shared = Model()
    
    public lazy var game : Game = {
        let managedContext = self.persistentContainer.viewContext
        var game : Game
        let games = try! managedContext.fetch(Game.fetchRequest())
        if(0 < games.count)
        {
            game = games.last!
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
    
    public var updateHandler: ()->Void = {
        () -> Void in
    }
    
    public func update() {
        let managedContext = persistentContainer.viewContext
        game.update(managedContext)
        updateHandler()
        if !Model.shared.game.isOver && !Model.shared.game.isPaused {
          DispatchQueue.main.asyncAfter(deadline: .now() + 0.017) {
             self.update()
          }
       }
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
