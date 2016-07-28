//
//  Achievement+CoreDataProperties.swift
//  malaria-ios
//
//  Created by Teodor Ciuraru on 7/28/16.
//  Copyright © 2016 Bruno Henriques. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Achievement {

    @NSManaged var desc: String?
    @NSManaged var isUnlocked: NSNumber?
    @NSManaged var name: String?
    @NSManaged var tag: String?

}
