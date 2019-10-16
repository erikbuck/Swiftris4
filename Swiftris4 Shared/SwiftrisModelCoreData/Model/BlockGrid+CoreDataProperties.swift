//
//  BlockGrid+CoreDataProperties.swift
//  Swiftris2
//
//  Created by Erik Buck on 9/26/19.
//  Copyright © 2019 WSU. All rights reserved.
//
//

import Foundation
import CoreData


extension BlockGrid {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BlockGrid> {
        return NSFetchRequest<BlockGrid>(entityName: "BlockGrid")
    }

    @NSManaged public var blocks: NSSet?

}

// MARK: Generated accessors for blocks
extension BlockGrid {

    @objc(addBlocksObject:)
    @NSManaged public func addToBlocks(_ value: Block)

    @objc(removeBlocksObject:)
    @NSManaged public func removeFromBlocks(_ value: Block)

    @objc(addBlocks:)
    @NSManaged public func addToBlocks(_ values: NSSet)

    @objc(removeBlocks:)
    @NSManaged public func removeFromBlocks(_ values: NSSet)

}
