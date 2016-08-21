//
//  Trip+CoreDataProperties.swift
//  Malaria Prevention App
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Trip {

    @NSManaged var internalArrival: NSTimeInterval
    @NSManaged var internalDeparture: NSTimeInterval
    @NSManaged var location: String
    @NSManaged var medicine: String
    @NSManaged var internalReminderTime: NSTimeInterval
    @NSManaged var items: NSSet

}
