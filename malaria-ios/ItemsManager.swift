//
//  ItemsManager.swift
//  malaria-ios
//
//  Created by Bruno Henriques on 23/06/15.
//  Copyright (c) 2015 Bruno Henriques. All rights reserved.
//

import Foundation

class ItemsManager{

    var trip: Trip!
    
    init(trip: Trip){
        self.trip = trip
    }
    
    func addItem(name: String, quantity: Int){
        if let i = findItem(name){
            Logger.Info("Updating quantity for an existing item")
            i.add(quantity)
        }else{
            var item = Item.create(Item.self)
            item.name = name
            item.number = quantity
            
            trip.items.addObject(item)
        }
        
        CoreDataHelper.sharedInstance.saveContext()
    }
    
    func findItem(name: String) -> Item?{
        var currentItems = getItems()
        
        currentItems = currentItems.filter({$0.name.lowercaseString == name.lowercaseString})
        
        return currentItems.count == 0 ? nil : currentItems[0]
    }
    
    
    func removeItem(name: String, quantity: Int = Int.max){
        if let i = findItem(name){
            
            i.remove(quantity)
            if i.number == 0{
                trip.items.removeObject(i)
                i.deleteFromContext()
            }
            
            CoreDataHelper.sharedInstance.saveContext()
            return
        }
        
        Logger.Error("Item not found")
    }
    
    func getItems() -> [Item]{
        return trip.items.convertToArray()
    }
}