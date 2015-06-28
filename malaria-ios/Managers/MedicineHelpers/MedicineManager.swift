import Foundation

class MedicineManager{
    static let sharedInstance = MedicineManager()
    
    
    
    /// Setups a new pill and sets it as default
    ///
    /// If there is already a pill registed as default, it will no longer be the default pill
    ///
    /// :param: `Medicine.Pill`: the pill
    /// :param: `NSDate`: fireDate
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
    
    /// Clears instance of Medicines from the CoreData
    func clearCoreData(){
        Medicine.clear(Medicine.self)
        CoreDataHelper.sharedInstance.saveContext()
    }
    

    /// Registers a new medicine (not as default)
    ///
    /// :param: `Medicine.Pill`: The medicine to be registered
    /// :returns: `Bool`:  If registry was success. False if not.
    func registerNewMedicine(med: Medicine.Pill) -> Bool{
        let registed: Medicine? = getMedicine(med)
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
    
    /// Retuns the default medicine (if any)
    ///
    /// :returns: `Medicine?`: The default medicine.
    func getCurrentMedicine() -> Medicine?{
        let medicines: [Medicine] = getRegisteredMedicines()
        let result = medicines.filter({ return $0.isCurrent == true})
        
        if result.count > 1{
            Logger.Error("Multiple current medicines found. Inconsistency found")
        }
        
        return result.count == 1 ? result[0] : nil
    }
    
    /// Retuns a specified medicine
    ///
    /// :param: `Medicine.Pill`: The type of the pill
    /// :returns: `Medicine?`: The default medicine.
    func getMedicine(pill: Medicine.Pill) -> Medicine?{
        let medicines: [Medicine] = getRegisteredMedicines()
        let result = medicines.filter({ return $0.name == pill.name()})
        
        return result.count == 0 ? nil : result[0]
    }
    
    /// Retuns all medicines registered
    ///
    /// :returns: `[Medicine]`: All the medicines
    func getRegisteredMedicines() -> [Medicine]{
        return Medicine.retrieve(Medicine.self)
    }
    
    /// Sets the specified pill as default
    ///
    /// :param: `Medicine.Pill`: The type of the pill
    func setCurrentPill(med: Medicine.Pill){
        if let m = getMedicine(med){
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
}