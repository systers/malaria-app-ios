//
//  Post.swift
//  malaria-ios
//
//  Created by Bruno Henriques on 26/06/15.
//  Copyright (c) 2015 Bruno Henriques. All rights reserved.
//

import Foundation
import CoreData

class Post: NSManagedObject {

    @NSManaged var created_at: String
    @NSManaged var id: Int64
    @NSManaged var owner: Int64
    @NSManaged var post_description: String
    @NSManaged var title: String
    @NSManaged var updated_at: String
    @NSManaged var contained_in: CollectionPosts

}
