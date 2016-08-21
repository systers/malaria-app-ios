//
//  Medicine+CoreDataProperties.swift
//  Malaria Prevention App
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Medicine {

    @NSManaged var internalInterval: Int64
    @NSManaged var isCurrent: Bool
    @NSManaged var internalLastStockRefill: NSTimeInterval
    @NSManaged var name: String
    @NSManaged var internalNotificationTime: NSTimeInterval
    @NSManaged var remainingMedicine: Int64
    @NSManaged var registries: NSSet

}
