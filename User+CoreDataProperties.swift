//
//  User+CoreDataProperties.swift
//  HIToyz_FinalProject
//
//  Created by prk on 24/11/23.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var email: String?
    @NSManaged public var isAdmin: Bool
    @NSManaged public var password: String?
    @NSManaged public var username: String?

}

extension User : Identifiable {

}
