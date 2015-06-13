import Foundation

class MedicineManager{
    static let sharedInstance = MedicineManager()
    
    func setup(medicine : Medicine.Pill, fireDate: NSDate){
        MedicineNotificationManager.sharedInstance.unsheduleNotification()
        
        logger("Storing new medicine")
        MedicineRegistry.sharedInstance.registerNewMedicine(medicine)
        MedicineRegistry.sharedInstance.setCurrentPill(medicine)
        
        
        
        logger("Setting up notification")
        MedicineNotificationManager.sharedInstance.scheduleNotification(medicine, fireTime: fireDate)
        
        UserSettingsManager.setBool(UserSetting.DidConfiguredMedicine, true)
        UserSettingsManager.syncronize()
    }
    
    
    func numberPillsTaken(registries: [Registry]) -> Int{
        var count = 0
        for r in registries{
            if (r.tookMedicine){
                count++
            }
        }
        
        return count
    }
    
    func numberSupposedPills(registries: [Registry]) -> Int{
        return registries.count
    }
    
    
    func pillAdherence(registries: [Registry]) -> Float{
        let supposedPills = numberSupposedPills(registries)
        if(supposedPills == 0){
            return 1.0
        }
        
        let pillsTaken = numberPillsTaken(registries)
        
        return Float(pillsTaken)/(Float(supposedPills))
    }
    
    func pillStreak(registries: [Registry]) -> Int{
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
    

}