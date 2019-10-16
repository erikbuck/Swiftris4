//
//  FallingBlockGrid+CoreDataProperties.swift
//  Swiftris2Quartz
//
//  Created by Erik Buck on 10/4/19.
//  Copyright © 2019 WSU. All rights reserved.
//
//

import Foundation
import CoreData


extension FallingBlockGrid {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FallingBlockGrid> {
        return NSFetchRequest<FallingBlockGrid>(entityName: "FallingBlockGrid")
    }

    @NSManaged public var gridPositionX: Int16
    @NSManaged public var gridPositionY: Int16
    @NSManaged public var rotations: Int16
    @NSManaged public var info: String?
    @NSManaged public var game: Game?

}
