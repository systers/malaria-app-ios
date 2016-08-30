import UIKit
import PickerSwift

/**
 Medicine Picker View, containing all possible medicines and by default is the on selected by the user in the setup screen.
 */

class MedicinePickerView : UIPickerView {
  private var medicinePickerProvider: PickerProvider!
  private var medicines = [String]()
  
  /// Selected value.
  var selectedValue = ""
  
  private var medicineManager: MedicineManager!
  
  /** Initialization.
   
   - parameter context: The current context.
   - parameter selectCallback: The "on selection" callback.
   Usually to change a view element content.
   */
  
  init(context: NSManagedObjectContext, selectCallback: (medicine: Medicine?,
    medicineName: String?) -> ()) {
    medicineManager = MedicineManager(context: context)
    super.init(frame: CGRectZero)
    
    // Setting up medicine value picker.
    var values = [String]()
    for m in Medicine.Pill.allValues {
      medicines.append(m.name())
      values.append(generateMedicineString(m))
    }
    
    medicinePickerProvider = PickerProvider(
      selectedCall: {(component: Int, row: Int, object: String) in
        let result = self.medicines[row]
        
        // If we have already registered a medicine, we pass it as parameter.
        // Else, we pass only the medicine name so that the user can register it.
        
        if let medicine = self.medicineManager.getMedicine(result) {
          selectCallback(medicine: medicine, medicineName: nil)
        } else {
          selectCallback(medicine: nil, medicineName: result)
        }
        
        self.selectedValue = result
      }, values: values)
    
    delegate = medicinePickerProvider
    dataSource = medicinePickerProvider
    
    let defaultMedicineName = defaultMedicine()
    if defaultMedicineName == "" {
      selectRow(0, inComponent: 0, animated: false)
      selectedValue = medicines[0]
    } else {
      let row = Medicine.Pill.allValues.indexOf(Medicine.Pill(rawValue: defaultMedicineName)!)!
      selectRow(row, inComponent: 0, animated: false)
      selectedValue = medicines[row]
    }
  }
  
  /**
   Returns the default medicine. If there is nothing configured, returns empty string.
   
   - returns: The default medicine's name.
   */
  private func defaultMedicine() -> String {
    return medicineManager.getCurrentMedicine()?.name.capitalizedString ?? ""
  }
  
  /**
   Generates a string for the medicine by following the rule:
   name + (weekly if interval is 7) OR (daily if interval is 1).
   
   - returns: The string.
   */
  
  private func generateMedicineString(medicine: Medicine.Pill) -> String {
    return medicine.name() + " (" + (medicine.interval() == 7
      ? NSLocalizedString("Weekly", comment: "")
      : NSLocalizedString("Daily", comment: "")) + ")"
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
}