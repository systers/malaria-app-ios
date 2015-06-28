//
//  Item.swift
//  malaria-ios
//
//  Created by Bruno Henriques on 22/06/15.
//  Copyright (c) 2015 Bruno Henriques. All rights reserved.
//

import Foundation
import CoreData

class Item: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var number: Int
    @NSManaged var associated_with: Trip

}
