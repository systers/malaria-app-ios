import UIKit
import PickerSwift

/// Medicine Picker for the trip.

class MedicinePickerViewTrip : MedicinePickerView {
  
  private var tripsManager: TripsManager!
  
  /**
   Initialization.
   
   - parameter context: The current context.
   - parameter selectCallback: The 'on selection' callback.
   Usually to change a view element content
   */
  
  override init(context: NSManagedObjectContext,
                selectCallback: (object: Medicine?, medicineName: String?) -> ()) {
    tripsManager = TripsManager(context: context)
    super.init(context: context, selectCallback: selectCallback)
  }
  
  /**
   Returns default medicine for the trip. If there is no trip configured returns empty string.
   
   - returns: The medicine's name for the stored trip.
   */
  
  private func defaultMedicine() -> String {
    return tripsManager.getTrip()?.medicine ?? ""
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
}