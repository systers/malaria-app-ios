import Foundation

extension Medicine{
    
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
    
    
    convenience init(context: NSManagedObjectContext) {
        let entityDescription = NSEntityDescription.entityForName("Medicine", inManagedObjectContext: context)!
        self.init(entity: entityDescription, insertIntoManagedObjectContext: context)
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
        logger(self.name)
        logger("   Is weekly? \(self.isWeekly())")
        logger("   currentStreak: \(self.currentStreak)")
        
        let registries: [Registry] = self.registries.convertToArray()
        logger("   Number of registries \(self.registries.count)")
        for reg in registries{
            logger("        " + reg.date.formatWith("dd/MM/yyyy") + " did took? \(reg.tookMedicine)")
        }
    
    }
}