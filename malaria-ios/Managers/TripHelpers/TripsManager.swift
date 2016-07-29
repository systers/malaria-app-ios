import Foundation

/// Manages `Trip` core data instances
class TripsManager : CoreDataContextManager {
  
  /// Init
  override init(context: NSManagedObjectContext){
    super.init(context: context)
  }
  
  /// Returns the current trip if any
  ///
  /// - returns: `Trip?`
  func getTrip() -> Trip?{
    return Trip.retrieve(Trip.self, fetchLimit: 1, context: context).first
  }
  
  /// Clears any trip from Core Data
  func clearCoreData(){
    Trip.clear(Trip.self, context: context)
    TripHistory.clear(TripHistory.self, context: context)
    CoreDataHelper.sharedInstance.saveContext(context)
  }
  
  /// Returns the location history of the trips sorted by most recent first
  ///
  /// - parameter `Int: optional`: number of intended items, default is 15
  ///
  /// - returns: `[TripHistory]`: history
  func getHistory(limit: Int = 15) -> [TripHistory] {
    return TripHistory.retrieve(TripHistory.self, fetchLimit: limit, context: context).sort({ $0.timestamp > $1.timestamp})
  }
  
  /// Appends the trip to the history
  ///
  /// - parameter `Trip`:: the trip
  private func createHistory(trip: Trip){
    let previousHistory = getHistory(Int.max)
    if previousHistory.count >= 15 {
      Logger.Warn("Deleting history to have more space")
      
      //delete oldest entry
      previousHistory.last!.deleteFromContext(context)
    }
    
    if previousHistory.filter({ $0.location.lowercaseString == trip.location.lowercaseString }).count == 0 {
      let hist = TripHistory.create(TripHistory.self, context: context)
      hist.location = trip.location
      hist.timestamp = trip.departure
    }
    
    CoreDataHelper.sharedInstance.saveContext(context)
  }
  
  /// Creates a trip.
  ///
  /// It creates an instance of the object in the CoreData, any deletion must be done explicitly.
  /// If there is already an instance of trip, it modifies it.
  ///
  /// - parameter `String`:: Location
  /// - parameter `String`:: Medicine name
  /// - parameter `Int64`:: caseToBring
  /// - parameter `NSdate`:: reminderDate
  ///
  /// :return: `Trip`: Instance of trip
  func createTrip(location: String, medicine: String, departure: NSDate, arrival: NSDate, timeReminder: NSDate) -> Trip{
    func create(t: Trip) -> Trip {
      t.location = location
      t.medicine = medicine
      t.departure = departure
      t.arrival = arrival
      t.reminderTime = timeReminder
      
      t.itemsManager.getItems().foreach({$0.deleteFromContext(self.context)})
      
      createHistory(t)
      
      NSNotificationEvents.TripPlanned()
      
      CoreDataHelper.sharedInstance.saveContext(context)
      
      return t
    }
    
    if let t = getTrip(){
      Logger.Warn("Already created a trip: changing stored one")
      return create(t)
    }
    
    return create(Trip.create(Trip.self, context: context))
  }
}
