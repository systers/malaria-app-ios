//
//  Registry+CoreDataProperties.swift
//  Malaria Prevention App
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Registry {

    @NSManaged var internalDate: NSTimeInterval
    @NSManaged var tookMedicine: Bool
    @NSManaged var medicine: Medicine?

}
