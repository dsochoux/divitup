//
//  Item+CoreDataProperties.swift
//  divitup
//
//  Created by danny sochoux on 9/10/21.
//
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var price: Double
    @NSManaged public var quantity: Int64
    @NSManaged public var buyers: NSSet?
    @NSManaged public var receipt: Receipt?

}

// MARK: Generated accessors for buyers
extension Item {

    @objc(addBuyersObject:)
    @NSManaged public func addToBuyers(_ value: Person)

    @objc(removeBuyersObject:)
    @NSManaged public func removeFromBuyers(_ value: Person)

    @objc(addBuyers:)
    @NSManaged public func addToBuyers(_ values: NSSet)

    @objc(removeBuyers:)
    @NSManaged public func removeFromBuyers(_ values: NSSet)

}

extension Item : Identifiable {

}
