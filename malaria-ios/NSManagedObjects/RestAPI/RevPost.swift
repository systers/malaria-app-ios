//
//  RevPost.swift
//  malaria-ios
//
//  Created by Bruno Henriques on 26/06/15.
//  Copyright (c) 2015 Bruno Henriques. All rights reserved.
//

import Foundation
import CoreData

class RevPost: NSManagedObject {

    @NSManaged var owner_post: Int64
    @NSManaged var owner: Int64
    @NSManaged var title: String
    @NSManaged var post_description: String
    @NSManaged var created_at: String
    @NSManaged var id: Int64
    @NSManaged var title_change: Bool
    @NSManaged var description_change: Bool
    @NSManaged var contained_in: CollectionRevPosts

}
