import Foundation

class MedicineManager{
    static let sharedInstance = MedicineManager()
    
    func setup(medicine : Medicine.Pill, fireDate: NSDate){
        MedicineNotificationManager.sharedInstance.unsheduleNotification()
        
        logger("Storing new medicine")
        MedicineRegistry.sharedInstance.registerNewMedicine(medicine)
        
        logger("Setting up notification")
        MedicineNotificationManager.sharedInstance.scheduleNotification(medicine, fireTime: fireDate)
        
        UserSettingsManager.setBool(UserSetting.DidConfiguredMedicine, true)
        UserSettingsManager.syncronize()
    }
    
    func didTookPill(currentDate: NSDate = NSDate()) -> Bool{
        if let previous = lastPillDateRegistry(), let m = MedicineRegistry.sharedInstance.getRegisteredMedicine(){
            return
                m.isDaily() && NSDate.areDatesSameDay(currentDate, dateTwo: previous) ||
                m.isWeekly() && NSDate.areDatesSameWeek(currentDate, dateTwo: previous)
        }
        
        return false
    }
    
    func numberPillsTaken(registries: [Registry] = MedicineRegistry.sharedInstance.getRegistries()) -> Int{
        var count = 0
        for r in registries{
            if (r.tookMedicine){
                count++
            }
        }
        
        return count
    }
    
    func numberSupposedPills(registries: [Registry] = MedicineRegistry.sharedInstance.getRegistries()) -> Int{
        return registries.count
    }
    
    
    func pillAdherence(registries: [Registry] = MedicineRegistry.sharedInstance.getRegistries()) -> Float{
        let supposedPills = numberSupposedPills(registries: registries)
        if(supposedPills == 0){
            return 1.0
        }
        
        let pillsTaken = numberPillsTaken(registries: registries)
        
        return Float(pillsTaken)/(Float(supposedPills))
    }
    
    func pillStreak(registries: [Registry] = MedicineRegistry.sharedInstance.getRegistries(mostRecentFirst: false)) -> Int{
        var result = 0
        
        let sortOldestEntryFirst = registries.sorted({$0.date < $1.date})
        
        for r in sortOldestEntryFirst{
            if r.tookMedicine{
                result += 1
            }else{
                result = 0
            }
        }
        
        return result
    }
    
    func lastPillDateRegistry() -> NSDate?{
        let registries = MedicineRegistry.sharedInstance.getRegistries()
        
        return registries.count > 0 ? registries[0].date : nil
    }
    
}