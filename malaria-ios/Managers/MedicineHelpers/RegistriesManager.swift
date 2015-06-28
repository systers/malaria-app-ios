import Foundation

class RegistriesManager{
    var medicine: Medicine!
    
    init(medicine: Medicine){
        self.medicine = medicine
    }

    /// Check if the pill was already taken in that day if daily pill or in that week if weekly pill
    ///
    /// :param: `NSDate`: the date
    /// :returns: `Bool`: True if there already a entry in that day/week
    func alreadyRegistered(at: NSDate) -> Bool{
        if medicine.isDaily(){
            return getRegistries(date1: at, date2: at).count != 0
        }else{
            let registries = getRegistries(date1: at - 8.day, date2: at + 8.day)
            for r in registries{
                if NSDate.areDatesSameWeek(at, dateTwo: r.date){
                    return true
                }
            }
        }
        
        return false
    }

    /// Returns the most recent entry for that pill if there is
    ///
    /// :returns: `NSDate?`
    func mostRecentEntry() -> NSDate?{
        let registries = getRegistries()
        return registries.count > 0 ? registries[0].date : nil
    }
    
    /// Returns the oldest entry for that pill if there is
    ///
    /// :returns: `NSDate?`
    func oldestEntry() -> NSDate?{
        let registries = getRegistries(mostRecentFirst: false)
        return registries.count > 0 ? registries[0].date : nil
    }

    /// Adds a new entry for that pill
    ///
    /// It will return false if trying to add entries in the future
    /// If modify flag is set to false, It will return false it there is
    /// already an entry in that day if daily pill or in that week if weekly pill
    ///
    /// :param: `NSDate`: the date of the entry
    /// :param: `Bool`: if the user took medicine
    /// :param: `Bool` optional: overwrite previous entry (by default is false)
    /// :returns: `Bool`: true if success, false if not
    func addRegistry(date: NSDate, tookMedicine: Bool, modifyEntry: Bool = false) -> Bool{
        let context = CoreDataHelper.sharedInstance.backgroundContext!
        
        if date > NSDate() {
            Logger.Error("Cannot change entries in the future")
            return false
        }
        
        if !modifyEntry && alreadyRegistered(date){
            Logger.Warn("Already registered the pill in that pill/week. Aborting")
            return false
        }
        
        //check if there is already a registry
        var registry : Registry? = findRegistry(date)
        
        if let r = registry{
            Logger.Info("Found entry same date. Modifying entry")
            r.tookMedicine = tookMedicine
        }else{
            var registry = Registry.create(Registry.self)
            registry.date = date
            registry.tookMedicine = tookMedicine
            
            medicine.registries.addObject(registry)
        }
        
        CoreDataHelper.sharedInstance.saveContext()
        
        return true
        
    }

    /// Returns entries between the two specified dates
    ///
    /// :param: `NSDate`: date1
    /// :param: `NSDate`: date2
    /// :param: `Bool` optional: if first element of result should be the most recent entry. (by default is true)
    /// :returns: `[Registry]`
    func getRegistries(date1: NSDate = NSDate.min, date2: NSDate = NSDate.max, mostRecentFirst: Bool = true) -> [Registry]{
        var array : [Registry] = medicine.registries.convertToArray()
        
        //make sure that date2 is always after date1
        if date1 > date2 {
            return getRegistries(date1: date2, date2: date1, mostRecentFirst: mostRecentFirst)
        }
        
        //sort entries chronologically
        let registries = mostRecentFirst ? array.sorted({$0.date > $1.date}) : array.sorted({$0.date < $1.date})
        
        if NSDate.areDatesSameDay(date1, dateTwo: date2){
            return registries.filter({NSDate.areDatesSameDay($0.date, dateTwo: date1)})
        }
        
        return registries.filter({$0.date >= date1 && $0.date <= date2})
    }

    /// Returns entry in the specified date if exists
    ///
    /// :param: `NSDate`: date
    /// :returns: `Registry?`
    func findRegistry(date: NSDate) -> Registry?{
        let filteredArray = getRegistries(date1: date, date2: date)
        if filteredArray.count > 1{
            Logger.Error("Error: Found too many entries with same date")
        }
        
        return filteredArray.count > 0 ? filteredArray[0] : nil
    }
}