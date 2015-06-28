import Foundation

class MedicineManager{
    static let sharedInstance = MedicineManager()
    
    func setup(medicine : Medicine.Pill, fireDate: NSDate){
        
        //unregister previous medicines
        if let currentMed = getCurrentMedicine(){
            currentMed.notificationManager.unsheduleNotification()
        }
        
        Logger.Info("Storing new medicine")
        registerNewMedicine(medicine)
        setCurrentPill(medicine)
        
        Logger.Info("Setting up notification")
        let newMed = getCurrentMedicine()!
        
        newMed.notificationManager.scheduleNotification(fireDate)

        UserSettingsManager.setBool(UserSetting.DidConfiguredMedicine, true)
        UserSettingsManager.syncronize()
    }
    
    func clearCoreData(){
        getRegisteredMedicines().map({$0.deleteFromContext()})
        CoreDataHelper.sharedInstance.saveContext()
    }
    
    /*
    *   Medicine queries and setters
    *
    */
    
    func registerNewMedicine(med: Medicine.Pill) -> Bool{
        let registed: Medicine? = findMedicine(med)
        if let m = registed{
            Logger.Warn("Already registered \(m.name), returning")
            
            return false
        }
        
        let medicine = Medicine.create(Medicine.self)
        medicine.name = med.name()
        medicine.weekly = med.isWeekly()
        
        CoreDataHelper.sharedInstance.saveContext()
        
        return true
    }
    
    func getCurrentMedicine() -> Medicine?{
        let medicines: [Medicine] = getRegisteredMedicines()
        let result = medicines.filter({ return $0.isCurrent == true})
        
        if result.count > 1{
            Logger.Error("Multiple current medicines found. Inconsistency found")
        }
        
        return result.count == 1 ? result[0] : nil
    }
    
    func getMedicine(pill: Medicine.Pill) -> Medicine?{
        let medicines: [Medicine] = getRegisteredMedicines()
        let result = medicines.filter({ return $0.name == pill.name()})
        
        return result.count == 0 ? nil : result[0]
    }
    
    func getRegisteredMedicines() -> [Medicine]{
        let fetchRequest = NSFetchRequest(entityName: "Medicine")
        let context = CoreDataHelper.sharedInstance.backgroundContext!
        let result: [Medicine] = context.executeFetchRequest(fetchRequest, error: nil) as! [Medicine]
        
        return result
    }
    
    func setCurrentPill(med: Medicine.Pill){
        if let m = findMedicine(med){
            
            for med in getRegisteredMedicines(){
                med.notificationManager.unsheduleNotification()
                med.isCurrent = false
            }
            
            m.isCurrent = true
            CoreDataHelper.sharedInstance.saveContext()
        }else{
            Logger.Error("pill not found!")
        }
    }
    
    func findMedicine(med: Medicine.Pill) -> Medicine?{
        let registedMedicine : [Medicine] = getRegisteredMedicines()
        let filter = registedMedicine.filter({$0.name == med.rawValue})
        
        return filter.count == 0 ? nil : filter[0]
    }
    
}