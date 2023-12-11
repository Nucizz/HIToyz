//
//  Transaction+CoreDataProperties.swift
//  HIToyz_FinalProject
//
//  Created by prk on 08/12/23.
//
//

import Foundation
import CoreData


extension Transaction {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Transaction> {
        return NSFetchRequest<Transaction>(entityName: "Transaction")
    }

    @NSManaged public var total: Float
    @NSManaged public var date: String?
    @NSManaged public var user: User?
    @NSManaged public var productItems: NSSet?

}

// MARK: Generated accessors for productItems
extension Transaction {

    @objc(addProductItemsObject:)
    @NSManaged public func addToProductItems(_ value: ProductItem)

    @objc(removeProductItemsObject:)
    @NSManaged public func removeFromProductItems(_ value: ProductItem)

    @objc(addProductItems:)
    @NSManaged public func addToProductItems(_ values: NSSet)

    @objc(removeProductItems:)
    @NSManaged public func removeFromProductItems(_ values: NSSet)

}

extension Transaction : Identifiable {

}
