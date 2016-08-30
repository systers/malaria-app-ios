import UIKit
import DoneToolbarSwift

class SetupScreenUserProfilePage: SetupScreenPage {
  
  @IBOutlet weak var firstNameField: UITextField!
  @IBOutlet weak var lastNameField: UITextField!
  @IBOutlet weak var genderField: UITextField!
  @IBOutlet weak var ageField: UITextField!
  @IBOutlet weak var locationField: UITextField!
  @IBOutlet weak var emailField: UITextField!
  @IBOutlet weak var phoneField: UITextField!
  
  @IBOutlet weak var scrollView: UIScrollView!
  
  override func viewDidLoad() {
    super.viewDidLoad()

    let toolBar = ToolbarWithDone(viewsWithToolbar: [
      firstNameField,
      lastNameField,
      genderField,
      ageField,
      locationField,
      emailField,
      phoneField])

    firstNameField.inputAccessoryView = toolBar
    lastNameField.inputAccessoryView = toolBar
    genderField.inputAccessoryView = toolBar
    ageField.inputAccessoryView = toolBar
    locationField.inputAccessoryView = toolBar
    emailField.inputAccessoryView = toolBar
    phoneField.inputAccessoryView = toolBar
  }
  
  @IBAction func nextPressed(sender: UIButton) {
    let firstName = firstNameField.text
    let lastName = lastNameField.text
    let age = ageField.text
    let phone = phoneField.text
    let gender = genderField.text
    let email = emailField.text
    let location = locationField.text
    
    // Try to create the user.
    do {
      try User.define(firstName!,
                      lastName: lastName!,
                      age: age!,
                      email: email!,
                      gender: gender,
                      location: location,
                      phone: phone)
    }
    catch let error as User.UserValidationError {
      ToastHelper.makeToast(NSLocalizedString(error.rawValue,
        comment: "An error when the user writes something invalid in the user profile fields."))
      return
    }
    catch {
      Logger.Error("Undefined error when trying to validate user.")
      return
    }
    
    pageViewDelegate!.changePage()
  }
}

// MARK: Text Field Delegate

extension SetupScreenUserProfilePage: UITextFieldDelegate {
  
  func textFieldDidBeginEditing(textField: UITextField) {
    
    if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
      return
    }
    
    let newOffset = CGPointMake(0, textField.frame.origin.y - 30)
    scrollView.setContentOffset(newOffset, animated: true)
  }
  
  func textFieldDidEndEditing(textField: UITextField) {
    let newOffset = CGPointMake(0, 0)
    scrollView.setContentOffset(newOffset, animated: true)
  }
}