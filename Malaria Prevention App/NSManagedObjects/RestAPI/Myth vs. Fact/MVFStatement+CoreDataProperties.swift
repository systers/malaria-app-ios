//
//  MVFStatement+CoreDataProperties.swift
//  Malaria Prevention App
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension MVFStatement {

    @NSManaged var correctAnswer: Bool
    @NSManaged var title: String?
    @NSManaged var contained_in: CollectionMVFStatements?

}
