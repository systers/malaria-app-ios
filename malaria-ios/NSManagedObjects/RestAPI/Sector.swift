//
//  Sector.swift
//  malaria-ios
//
//  Created by Bruno Henriques on 28/06/15.
//  Copyright (c) 2015 Bruno Henriques. All rights reserved.
//

import Foundation
import CoreData

class Sector: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var desc: String
    @NSManaged var code: String
    @NSManaged var id: Int64
    @NSManaged var containedIn: Sectors

}
