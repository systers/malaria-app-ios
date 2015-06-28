import Foundation
import UIKit

extension RKEntityMapping{
    
    //simplifies general cases of mapping by providing array of atributes (with same name as the name of the variables), and a array of that maps relationships
    class func mapDirectAtributesAndRelationships(name: String, attributes: [String] = [], relationships: [String: RKEntityMapping] = [:]) -> RKEntityMapping{
        let managedObjectStore: RKManagedObjectStore = CoreDataStore.sharedInstance.persistentStoreCoordinator!
        
        let rootMap = RKEntityMapping(forEntityForName: name, inManagedObjectStore: managedObjectStore)
        
        
        for childKey in attributes{
            let attMap = RKAttributeMapping(fromKeyPath: childKey, toKeyPath: childKey)
            rootMap.addPropertyMapping(attMap)
        }
        
        for (childKey, childMap) in relationships{
            let relMap = RKRelationshipMapping(fromKeyPath: childKey, toKeyPath: childKey, withMapping: childMap)
            rootMap.addPropertyMapping(relMap)
        }
        return rootMap
    }
    
    class func mapAtributesAndRelationships(name: String, attributes: [String: String] = [:], relationships: [String: RKEntityMapping] = [:]) -> RKEntityMapping{
        let managedObjectStore: RKManagedObjectStore = CoreDataStore.sharedInstance.persistentStoreCoordinator!
        
        let rootMap = RKEntityMapping(forEntityForName: name, inManagedObjectStore: managedObjectStore)
        
        for (childKey, destKey) in attributes{
            let attMap = RKAttributeMapping(fromKeyPath: childKey, toKeyPath: destKey)
            rootMap.addPropertyMapping(attMap)
        }
        
        for (childKey, childMap) in relationships{
            let relMap = RKRelationshipMapping(fromKeyPath: childKey, toKeyPath: childKey, withMapping: childMap)
            rootMap.addPropertyMapping(relMap)
        }
        return rootMap
    }
}