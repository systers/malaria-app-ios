import UIKit
import DoneToolbarSwift

class SetupScreenUserProfileViewController: UIViewController {
  
  @IBOutlet weak var firstNameField: UITextField!
  @IBOutlet weak var lastNameField: UITextField!
  @IBOutlet weak var genderField: UITextField!
  @IBOutlet weak var ageField: UITextField!
  @IBOutlet weak var locationField: UITextField!
  @IBOutlet weak var emailField: UITextField!
  @IBOutlet weak var phoneField: UITextField!
  
  @IBOutlet weak var scrollView: UIScrollView!
  
  // Provided by `PagesManagerViewController`.
  var delegate: PresentsModalityDelegate!
  
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
    
    if User.isUserAlreadyCreated() {
      presentNextSetupScreen()
    }
  }
  
  func presentNextSetupScreen() {
    appDelegate.presentSetupScreen(withDelegate: delegate)
    dismissViewControllerAnimated(true, completion: nil)
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
      ToastHelper.makeToast(error.rawValue, viewController: self)
      return
    }
    catch {
      Logger.Error("Undefined error when trying to validate user.")
      return
    }
    
    presentNextSetupScreen()
  }
  
  @IBAction func sendFeedback(sender: UIButton) {
    openUrl(NSURL(string: "mailto:\(PeaceCorpsInfo.mail)"))
  }
}

// MARK: Text Field Delegate

extension SetupScreenUserProfileViewController: UITextFieldDelegate {
  
  func textFieldDidBeginEditing(textField: UITextField) {
    let newOffset = CGPointMake(0, textField.frame.origin.y - 30)
    scrollView.setContentOffset(newOffset, animated: true)
  }
  
  func textFieldDidEndEditing(textField: UITextField) {
    let newOffset = CGPointMake(0, 0)
    scrollView.setContentOffset(newOffset, animated: true)
  }
}