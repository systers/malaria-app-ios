//
//  User+CoreDataProperties.swift
//  Malaria Prevention App
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension User {

    @NSManaged var age: Int64
    @NSManaged var email: String?
    @NSManaged var firstName: String?
    @NSManaged var gender: String?
    @NSManaged var lastName: String?
    @NSManaged var location: String?
    @NSManaged var phone: String?

}
