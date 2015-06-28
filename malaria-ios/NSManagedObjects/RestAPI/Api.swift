//
//  Api.swift
//  malaria-ios
//
//  Created by Bruno Henriques on 21/06/15.
//  Copyright (c) 2015 Bruno Henriques. All rights reserved.
//

import Foundation
import CoreData

class Api: NSManagedObject {

    @NSManaged var users: String
    @NSManaged var posts: String
    @NSManaged var revposts: String
    @NSManaged var regions: String
    @NSManaged var sectors: String
    @NSManaged var ptposts: String
    @NSManaged var projects: String
    @NSManaged var goals: String
    @NSManaged var objectives: String
    @NSManaged var indicators: String
    @NSManaged var outputs: String
    @NSManaged var outcomes: String
    @NSManaged var activity: String
    @NSManaged var measurement: String
    @NSManaged var cohort: String
    @NSManaged var volunteer: String
}
