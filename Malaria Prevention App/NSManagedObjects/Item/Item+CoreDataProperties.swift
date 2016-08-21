//
//  Item+CoreDataProperties.swift
//  Malaria Prevention App
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Item {

    @NSManaged var check: Bool
    @NSManaged var name: String
    @NSManaged var quantity: Int64
    @NSManaged var associated_with: Trip?

}
