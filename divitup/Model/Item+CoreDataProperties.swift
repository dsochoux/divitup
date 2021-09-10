//
//  Item+CoreDataProperties.swift
//  divitup
//
//  Created by danny sochoux on 9/9/21.
//
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    @NSManaged public var name: String?
    @NSManaged public var price: Double
    @NSManaged public var quantity: Int64
    @NSManaged public var buyers: [String]?
    @NSManaged public var receipt: Receipt?

}

extension Item : Identifiable {

}
