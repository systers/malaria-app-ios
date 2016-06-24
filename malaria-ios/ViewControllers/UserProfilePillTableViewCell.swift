import UIKit
import DoneToolbarSwift

// MARK: - Table View Cell

class UserProfilePillTableViewCell: UITableViewCell {
  
  @IBOutlet weak var pillName: UILabel!
  @IBOutlet weak var quantityTextField: UITextField!
  
  weak var delegate : SaveRemainingPillsProtocol?
  
  var toolBar: ToolbarWithDone!
  
  func updateCellWithParameters(delegate: SaveRemainingPillsProtocol,
                                name: String,
                                remainingMedicine: String,
                                indexPath: NSIndexPath) {
    pillName.text = name
    print(remainingMedicine)
    quantityTextField.text = remainingMedicine
    quantityTextField.delegate = self
    quantityTextField.tag = indexPath.row
    toolBar = ToolbarWithDone(viewsWithToolbar: [quantityTextField])
    quantityTextField.inputAccessoryView = toolBar
  }
}

// MARK: - Text Field Delegate

extension UserProfilePillTableViewCell: UITextFieldDelegate {
  
  func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
    return string.isNumber()
  }
  
  func textFieldDidEndEditing(textField: UITextField) {
    guard textField.text!.characters.count > 0 else {
      textField.text = "0"
      return
    }
    
    delegate?.saveRemainingPills(textField)
  }
}