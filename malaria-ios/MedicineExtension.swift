import Foundation

extension Medicine{
    var stats: MedicineStats {get { return MedicineStats(medicine: self) }}
    var registriesManager: RegistriesManager { get { return RegistriesManager(medicine: self) }}
    var notificationManager: MedicineNotificationsManager { get { return MedicineNotificationsManager(medicine: self) }}
    
    enum Pill : String{
        static let allValues = [Pill.Doxycycline, Pill.Malarone, Pill.Mefloquine]
        
        case Doxycycline = "Doxycycline"
        case Malarone = "Malarone"
        case Mefloquine = "Mefloquine"
        
        func isWeekly() -> Bool{
            return self == Medicine.Pill.Mefloquine
        }
        
        func isDaily() -> Bool{
            return self != Medicine.Pill.Mefloquine
        }
        
        func name() -> String{
            return self.rawValue
        }
    }
    
    class func PillTypeFromString(type: String) -> Pill?{
        return Medicine.Pill(rawValue: type)
    }
    
    func isWeekly() -> Bool{
        return weekly
    }
    
    func isDaily() -> Bool{
        return !weekly
    }
    
    func print(){
        Logger.Info(self.name)
        Logger.Info("   Is weekly? \(self.isWeekly())")
        
        let registries: [Registry] = self.registries.convertToArray()
        Logger.Info("   Number of registries \(self.registries.count)")
        for reg in registries{
            Logger.Info("        " + reg.date.formatWith("dd/MM/yyyy") + " did took? \(reg.tookMedicine)")
        }
    }
}