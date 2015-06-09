import Foundation


class MedicineRegistry {
    static let sharedInstance = MedicineRegistry()

    
    
    func registerNewMedicine(med: Medicine.Pill){
        let context = CoreDataHelper.sharedInstance.backgroundContext!
        
        let currentMedicine: Medicine? = getRegisteredMedicine()
        if let m = currentMedicine{
            
            if(m.name != med.name()){
                logger("Changing Medicine, deleting old")
                context.deleteObject(m)
            }else{
                logger("Already registered \(m.name), returning")
            }
            
            return
        }
        
        let medicine = Medicine(context: context)
        medicine.name = med.rawValue
        medicine.weekly = med.isWeekly()
        
        CoreDataHelper.sharedInstance.saveContext()
    }
    
    func clearCoreData(){
        if let m = getRegisteredMedicine(){
            let context = CoreDataHelper.sharedInstance.backgroundContext!
            context.deleteObject(m)
            CoreDataHelper.sharedInstance.saveContext()
        }else{
            logger("Nothing to delete")
        }
    }
    
    func addRegistry(date: NSDate, tookMedicine: Bool){
        let context = CoreDataHelper.sharedInstance.backgroundContext!
        
        //check if there is already a registry
        if let m = getRegisteredMedicine(){
            var registries : [Registry] = m.registries.convertToArray()
            
            //check if there is already an entry
            var found: Bool = false
            for r in registries{
                
                if (NSDate.areDatesSameDay(date, dateTwo: r.date)){
                    logger("Fount entry same date")
                    r.tookMedicine = tookMedicine
                    found = true
                }
            }
            
            if(!found){
                //logger("Inserting new entry for that date")
                var registry = Registry(context: context)
                registry.date = date
                registry.tookMedicine = tookMedicine
                
                registries.append(registry)
                m.registries = NSSet(array: registries)
            }
            
            if(tookMedicine){
                m.currentStreak += 1
            }else {
                m.currentStreak = 0
            }
            
            CoreDataHelper.sharedInstance.saveContext()
        }else{
            logger("Error! addRegistry method failed because there is no registered Medicine")
        }
    }
    
    func getRegisteredMedicine() -> Medicine?{
        let fetchRequest = NSFetchRequest(entityName: "Medicine")
        let context = CoreDataHelper.sharedInstance.backgroundContext!
        if let fetchResults = context.executeFetchRequest(fetchRequest, error: nil) as? [Medicine] {
        
            if !fetchResults.isEmpty {
                return fetchResults[0]
            }
        }
        
        return nil
    }
    
    func getRegistries(mostRecentFirst: Bool = true) -> [Registry]{
        if let m = getRegisteredMedicine(){
            let array : [Registry] = m.registries.convertToArray()
            
            return mostRecentFirst ? array.sorted({$0.date > $1.date}) : array.sorted({$0.date < $1.date})
        }
        
        return []
    }
    
    func getRegistriesInBetween(date1: NSDate, date2: NSDate, mostRecentFirst: Bool = true) -> [Registry]{
        let filteredArray = getRegistries(mostRecentFirst: mostRecentFirst)
        
        if date2 <= date1 {
            return filteredArray.filter({ $0.date >= date2 && $0.date <= date1 })
        }
        
        return filteredArray.filter({ $0.date >= date1 && $0.date <= date2 })
    }
    
    func findRegistry(date: NSDate) -> Registry?{
        let filteredArray = getRegistries().filter({ NSDate.areDatesSameDay($0.date, dateTwo: date) })
        if filteredArray.count > 1{
            logger("Error: Found too many entries with same date")
        }
        
        return filteredArray.count > 0 ? filteredArray[0] : nil
    }
}