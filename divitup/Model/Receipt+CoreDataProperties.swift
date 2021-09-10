//
//  Receipt+CoreDataProperties.swift
//  divitup
//
//  Created by danny sochoux on 9/9/21.
//
//

import Foundation
import CoreData


extension Receipt {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Receipt> {
        return NSFetchRequest<Receipt>(entityName: "Receipt")
    }

    @NSManaged public var date: Date?
    @NSManaged public var name: String?
    @NSManaged public var people: [String]?
    @NSManaged public var items: NSSet?

}

// MARK: Generated accessors for items
extension Receipt {

    @objc(addItemsObject:)
    @NSManaged public func addToItems(_ value: Item)

    @objc(removeItemsObject:)
    @NSManaged public func removeFromItems(_ value: Item)

    @objc(addItems:)
    @NSManaged public func addToItems(_ values: NSSet)

    @objc(removeItems:)
    @NSManaged public func removeFromItems(_ values: NSSet)

}

extension Receipt : Identifiable {

}
