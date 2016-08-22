import UIKit
import DoneToolbarSwift

// MARK: Table View Cell

class UserProfilePillTableViewCell: UITableViewCell {
  
  private let DefaultStockValueString = "0"
  
  @IBOutlet weak var pillName: UILabel!
  @IBOutlet weak var quantityTextField: UITextField!
  
  weak var delegate : SaveRemainingPillsProtocol?
  
  var toolBar: ToolbarWithDone!
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    guard quantityTextField != nil else {
      return
    }
    
    if toolBar == nil {
      toolBar = ToolbarWithDone(viewsWithToolbar: [quantityTextField])
    }
    
    quantityTextField.inputAccessoryView = toolBar
    quantityTextField.delegate = self
  }
  
  func updateCell(delegate: SaveRemainingPillsProtocol,
                                name: String,
                                remainingMedicine: Int,
                                indexPath: NSIndexPath) {
    pillName.text = name
    quantityTextField.text = String(remainingMedicine)
    quantityTextField.tag = indexPath.row
  }
}

// MARK: Text Field Delegate

extension UserProfilePillTableViewCell: UITextFieldDelegate {
  
  func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
    return string.isNumber()
  }
  
  func textFieldDidEndEditing(textField: UITextField) {
    guard textField.text!.characters.count > 0 else {
      textField.text = DefaultStockValueString
      return
    }
    
    delegate?.getRemainingPillsValueFrom(textField)
  }
}