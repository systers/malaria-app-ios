//
//  Post+CoreDataProperties.swift
//  Malaria Prevention App
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Post {

    @NSManaged var created_at: String?
    @NSManaged var id: Int64
    @NSManaged var owner: Int64
    @NSManaged var post_description: String?
    @NSManaged var title: String?
    @NSManaged var updated_at: String?
    @NSManaged var contained_in: CollectionPosts?

}
