//
//  TripHistory+CoreDataProperties.swift
//  Malaria Prevention App
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension TripHistory {

    @NSManaged var location: String
    @NSManaged var internalTimestamp: NSTimeInterval

}
