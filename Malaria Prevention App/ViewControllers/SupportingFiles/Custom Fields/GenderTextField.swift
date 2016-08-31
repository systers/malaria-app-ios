import UIKit
import PickerSwift
import DoneToolbarSwift

/// Let's the user select his gender.

class GenderTextField: UITextField {
  
  private var genderPickerProvider: PickerProvider!
  private var picker: UIPickerView!
  private let genderValues = [
    NSLocalizedString("Male", comment: "A gender"),
    NSLocalizedString("Female", comment: "A gender"),
    NSLocalizedString("Other", comment: "A gender")]
  
  private var toolBar: ToolbarWithDone!
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    picker = UIPickerView()
    inputView = picker
    
    self.addTarget(self,
                   action: #selector(clicked),
                   forControlEvents: UIControlEvents.EditingDidBegin)
  }
  
  func clicked(sender: AnyObject) {
    
    let didSelectComponentCallback = {
      (component: Int, row: Int, object: String) in
      self.text = object
    }
    
    genderPickerProvider = PickerProvider(selectedCall: didSelectComponentCallback,
                                          values: genderValues)
    
    picker.delegate = genderPickerProvider
    
    if text!.isEmpty {
      text = genderValues[0]
    } else {
      let row = genderValues.indexOf(text!)
      picker.selectRow(row!, inComponent: 0, animated: false)
    }
  }
}