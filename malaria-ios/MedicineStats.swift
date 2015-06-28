import Foundation

class MedicineStats{
    var medicine: Medicine!
    
    init(medicine: Medicine){
        self.medicine = medicine
    }
    
    func numberPillsTaken(date1: NSDate = NSDate.min, date2: NSDate = NSDate.max) -> Int{
        var count = 0
        for r in medicine.registriesManager.getRegistries(date1: date1, date2: date2){
            if (r.tookMedicine){
                count++
            }
        }
        
        return count
    }
    
    func numberSupposedPills(date1: NSDate = NSDate.min, date2: NSDate = NSDate.max) -> Int{
        
        if (medicine.registriesManager.getRegistries(date1: date1, date2: date2).count == 0){
            return 0
        }
        
        if date1 > date2 {
            return numberSupposedPills(date1: date2, date2: date1)
        }
        
        
        var d1: NSDate = date1
        if NSDate.areDatesSameDay(d1, dateTwo: NSDate.min) {
            d1 = medicine.registriesManager.oldestEntry()!
        }
        
        var d2: NSDate = date2
        if NSDate.areDatesSameDay(d2, dateTwo: NSDate.max) {
            d2 = medicine.registriesManager.mostRecentEntry()!
        }
        
        //+1 to include d1
        let numDays = (d2 - d1).day + 1
        
        Logger.Info("--> \(numDays)")
        
        return  medicine.isDaily() ?  numDays : Int(ceil(Float(numDays)/7))
    }
    
    func pillAdherence(date1: NSDate = NSDate.min, date2: NSDate = NSDate.max) -> Float{
        let supposedPills = numberSupposedPills(date1: date1, date2: date2)
        
        if(supposedPills == 0){
            return 1.0
        }
        
        let pillsTaken = numberPillsTaken(date1: date1, date2: date2)
        
        return Float(pillsTaken)/(Float(supposedPills))
    }
    
    func pillStreak(date1: NSDate = NSDate.min, date2: NSDate = NSDate.max) -> Int{
        var result = 0
        
        let isDaily = medicine.isDaily()
        var previousDate: NSDate?
        for r in medicine.registriesManager.getRegistries(date1: date1, date2: date2, mostRecentFirst: false){
            
            //check for missing entries
            if let previousD = previousDate{
                if isDaily && !NSDate.areDatesSameDay(previousD + 1.day, dateTwo: r.date){
                    result = 0
                }else if !isDaily && !NSDate.areDatesSameWeek(previousD + 7.day, dateTwo: r.date){
                    result = 0
                }
            }
            
            
            if r.tookMedicine{
                result += 1
            }else{
                result = 0
            }
            
            previousDate = r.date
        }
        
        return result
    }
}