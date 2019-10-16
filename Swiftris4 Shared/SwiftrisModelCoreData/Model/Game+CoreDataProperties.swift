//
//  Game+CoreDataProperties.swift
//  Swiftris2
//
//  Created by Erik Buck on 9/26/19.
//  Copyright © 2019 WSU. All rights reserved.
//
//

import Foundation
import CoreData


extension Game {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Game> {
        return NSFetchRequest<Game>(entityName: "Game")
    }

    @NSManaged public var fallRate: Float
    @NSManaged public var isFallingFast: Bool
    @NSManaged public var isOver: Bool
    @NSManaged public var isPaused: Bool
    @NSManaged public var score: Int32
    @NSManaged public var highScore: Int32
    @NSManaged public var board: BoardBlockGrid?
    @NSManaged public var fallingBlock: FallingBlockGrid?

}
