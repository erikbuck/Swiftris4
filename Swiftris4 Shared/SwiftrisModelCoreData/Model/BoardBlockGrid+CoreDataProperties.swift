//
//  BoardBlockGrid+CoreDataProperties.swift
//  Swiftris2
//
//  Created by Erik Buck on 9/26/19.
//  Copyright © 2019 WSU. All rights reserved.
//
//

import Foundation
import CoreData


extension BoardBlockGrid {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BoardBlockGrid> {
        return NSFetchRequest<BoardBlockGrid>(entityName: "BoardBlockGrid")
    }

    @NSManaged public var game: Game?

}
