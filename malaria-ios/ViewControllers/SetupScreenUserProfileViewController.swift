import UIKit

class SetupScreenUserProfileViewController: UIViewController {
  
  @IBOutlet weak var firstNameField: UITextField!
  @IBOutlet weak var lastNameField: UITextField!
  @IBOutlet weak var genderField: UITextField!
  @IBOutlet weak var ageField: UITextField!
  @IBOutlet weak var locationField: UITextField!
  @IBOutlet weak var emailField: UITextField!
  @IBOutlet weak var phoneField: UITextField!
  
  @IBOutlet weak var scrollView: UIScrollView!
  
  // Provided by `PagesManagerViewController`
  var delegate: PresentsModalityDelegate!
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
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
    
    // Try to create the user
    let userCreationResult = User.define(firstName,
                                         lastName: lastName,
                                         age: age,
                                         email: email,
                                         gender: gender,
                                         location: location,
                                         phone: phone)
    
    if let error = userCreationResult.error {
      ToastHelper.makeToast(error.rawValue, viewController: self)
      return
    }
    
    presentNextSetupScreen()
  }
  
  @IBAction func sendFeedback(sender: UIButton) {
    openUrl(NSURL(string: "mailto:\(PeaceCorpsInfo.mail)"))
  }
  
}

extension SetupScreenUserProfileViewController: UITextFieldDelegate {
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    self.view.endEditing(true)
    return false
  }
  
  func textFieldDidBeginEditing(textField: UITextField) {
    let newOffset = CGPointMake(0, textField.frame.origin.y - 30)
    scrollView.setContentOffset(newOffset, animated: true)
  }
  
  func textFieldDidEndEditing(textField: UITextField) {
    let newOffset = CGPointMake(0, 0)
    scrollView.setContentOffset(newOffset, animated: true)
  }
}