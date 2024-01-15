//
//  Product+CoreDataProperties.swift
//  HIToyz_FinalProject
//
//  Created by prk on 04/12/23.
//
//

import Foundation
import CoreData


extension Product {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Product> {
        return NSFetchRequest<Product>(entityName: "Product")
    }

    @NSManaged public var desc: String?
    @NSManaged public var imageUrl: String?
    @NSManaged public var name: String?
    @NSManaged public var price: Float
    @NSManaged public var stock: Int32
    @NSManaged public var category: String?

}

extension Product : Identifiable {

}
