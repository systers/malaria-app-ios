import Foundation

class TripsManager{
    static let sharedInstance = TripsManager()

    func getTrip() -> Trip?{
        let fetchRequest = NSFetchRequest(entityName: "Trip")
        let context = CoreDataHelper.sharedInstance.backgroundContext!
        let result: [Trip] = context.executeFetchRequest(fetchRequest, error: nil) as! [Trip]
        
        
        if result.count == 0{
            return nil
        }else if result.count > 1 {
            Logger.Warn("Multiple trips found, error")
        }
        
        return result[0]
    }
    
    func clearCoreData(){
        let context = CoreDataHelper.sharedInstance.backgroundContext!
        if let t = getTrip(){
            t.deleteFromContext()
        }
        
        CoreDataHelper.sharedInstance.saveContext()
    }
    
    func createTrip(location: String, medicine: Medicine.Pill, cashToBring: Int, reminderDate: NSDate) -> Trip?{
        
        if let t = getTrip(){
            Logger.Error("Already created a trip, please delete previous one")
            return nil
        }
        
        let trip = Trip.create(Trip.self)
        
        trip.location = location
        trip.medicine = medicine.name()
        trip.cashToBring = cashToBring
        trip.reminderDate = reminderDate
        
        CoreDataHelper.sharedInstance.saveContext()
        
        return trip
    }
}
