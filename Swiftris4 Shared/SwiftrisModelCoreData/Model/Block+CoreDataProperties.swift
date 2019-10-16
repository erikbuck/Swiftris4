//
//  Block+CoreDataProperties.swift
//  Swiftris2
//
//  Created by Erik Buck on 9/26/19.
//  Copyright © 2019 WSU. All rights reserved.
//
//

import Foundation
import CoreData


extension Block {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Block> {
        return NSFetchRequest<Block>(entityName: "Block")
    }

    @NSManaged public var gridPositionX: Int16
    @NSManaged public var gridPositionY: Int16
    @NSManaged public var info: String?
    @NSManaged public var grid: BlockGrid?

}
