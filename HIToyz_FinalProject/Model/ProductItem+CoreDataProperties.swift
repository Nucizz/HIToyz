//
//  ProductItem+CoreDataProperties.swift
//  HIToyz_FinalProject
//
//  Created by prk on 08/12/23.
//
//

import Foundation
import CoreData


extension ProductItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProductItem> {
        return NSFetchRequest<ProductItem>(entityName: "ProductItem")
    }

    @NSManaged public var qty: Int32
    @NSManaged public var subtotal: Float
    @NSManaged public var product: Product?
    @NSManaged public var transaction: Transaction?

}

extension ProductItem : Identifiable {

}
