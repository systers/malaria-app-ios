import Foundation

class TripsManager{
    /// :returns: singleton
    static let sharedInstance = TripsManager()

    /// Returns the current trip if any
    /// :returns: Trip?
    func getTrip() -> Trip?{
        let result = Trip.retrieve(Trip.self)
        if result.count == 0{
            return nil
        }else if result.count > 1 {
            Logger.Warn("Multiple trips found, error")
        }
        
        return result[0]
    }
    
    /// Clears any trip from coreData
    func clearCoreData(){
        Trip.clear(Trip.self)
        CoreDataHelper.sharedInstance.saveContext()
    }
    
    /// Creates a trip.
    ///
    /// It creates an instance of the object in the CoreData, any deletion must be done explicitly.
    /// If there is already an instance of trip, it modifies it.
    ///
    /// :param: `String`: Location
    /// :param: `Medicine.Pill`: Location
    /// :param: `Int64`: caseToBring
    /// :param: `NSdate`: reminderDate
    /// :return: `Trip`: Instance of trip
    func createTrip(location: String, medicine: Medicine.Pill, cashToBring: Int64, reminderDate: NSDate) -> Trip{
        if let t = getTrip(){
            t.location = location
            t.medicine = medicine.name()
            t.cashToBring = cashToBring
            t.reminderDate = reminderDate
            
            Logger.Warn("Already created a trip: changing stored one")
            CoreDataHelper.sharedInstance.saveContext()
            return t
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
