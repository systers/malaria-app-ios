import Foundation
import UIKit
import PickerSwift

/// Medicine Picker for the trip
class MedicinePickerViewTrip : MedicinePickerView {
  
  private var tripsManager: TripsManager!
  
  /**
   Initialization
   
   - parameter `NSManagedObjectContext`:: current context
   - parameter `(object:: String) -> ()`: on selection callback. Usually to change a view element content
   */
  
  override init(context: NSManagedObjectContext, selectCallback: (object: String) -> ()){
    tripsManager = TripsManager(context: context)
    super.init(context: context, selectCallback: selectCallback)
  }
  
  /**
   Returns default medicine for the trip. If there is no trip configured returns empty string.
   
   - returns: `String`: medicine for the stored trip.
   */
  
  private func defaultMedicine() -> String{
    return tripsManager.getTrip()?.medicine ?? ""
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
}