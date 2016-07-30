//
//  Achievement+CoreDataProperties.swift
//  malaria-ios
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Achievement {

    @NSManaged var desc: String?
    @NSManaged var isUnlocked: Bool
    @NSManaged var name: String?
    @NSManaged var tag: String?

}
