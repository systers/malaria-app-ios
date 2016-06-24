import Foundation

/// Manages `Medicine` core data instances
public class MedicineManager : CoreDataContextManager{
    /// Init
    override public init(context: NSManagedObjectContext){
        super.init(context: context)
    }
    
    /// Clears instance of Medicines from the CoreData
    public func clearCoreData(){
        Medicine.clear(Medicine.self, context: self.context)
        CoreDataHelper.sharedInstance.saveContext(self.context)
        UserSettingsManager.UserSetting.DidConfiguredMedicine.removeKey()
    }

    /// Register a new medicine with a name and a interval (e.g. 1 for daily and 7 for weekly)
    ///
    /// - parameter `String`:
    /// - parameter `Int`:
    /// - returns: `Bool`:  true if success. false if not.
    public func registerNewMedicine(name: String, interval: Int) -> Bool{
        if let _ = getMedicine(name){
            return false
        }
        
        let medicine = Medicine.create(Medicine.self, context: context)
        medicine.name = name
        medicine.interval = max(1, interval)
        medicine.remainingMedicine = 0
        
        CoreDataHelper.sharedInstance.saveContext(context)
        
        return true
    }
    
    /// Retuns the current medicine being tracked (if any)
    ///
    /// - returns: `Medicine?`: default medicine.
    public func getCurrentMedicine() -> Medicine? {
        let predicate = NSPredicate(format: "isCurrent == %@", true)
        return Medicine.retrieve(Medicine.self, predicate: predicate, fetchLimit: 1, context: context).first
    }
    
    /// Returns a specified medicine
    ///
    /// - parameter `String`:: name of pill, case sensitive
    /// - returns: `Medicine?`
    public func getMedicine(name: String) -> Medicine?{
        let predicate = NSPredicate(format: "name == %@", name)
        return Medicine.retrieve(Medicine.self, predicate: predicate, fetchLimit: 1, context: context).first
    }
    
    /// Retuns all medicines registered
    ///
    /// - returns: `[Medicine]`: All the medicines
    public func getRegisteredMedicines() -> [Medicine]{
        return Medicine.retrieve(Medicine.self, context: self.context)
    }
    
    /// Sets the specified pill as default
    ///
    /// - parameter `String`:: name of the pill, case sensitive
    public func setCurrentPill(name: String){
        if let m = getCurrentMedicine(){
            m.isCurrent = false
            m.notificationManager.unsheduleNotification()
        }else{
            Logger.Error("No current pill found!")
        }
        
        Logger.Info("Setting \(name) as default")
        getMedicine(name)!.isCurrent = true
        
        CoreDataHelper.sharedInstance.saveContext(context)
        NSNotificationEvents.DataUpdated(nil)
    }
}