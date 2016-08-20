import UIKit
import DoneToolbarSwift

// MARK: Protocol.

protocol SaveRemainingPillsProtocol: class {
  func saveRemainingPills(textField: UITextField)
}

/// A class that stores all the user information and sets up the Pill Taking mechanism.

class UserProfileViewController: UIViewController {
  
  // MARK: Properties.

  /*
   We found a problem that didn't allow us to click on the table view's cell
   if we only set the cell height (60) and not add ~30-50 offset to it.
   */
  
  private let CellHeightAndOffset: CGFloat = 60 + 30
  private let CellReuseIdentifier = "User Profile Pill Cell Identifier"
  private let ViewEnabledAlpha: CGFloat = 1
  private let ViewDisabledAlpha: CGFloat = 0.8
  
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var remindMeWeeksButton: UIButton!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var remainingLabel: UILabel!
  @IBOutlet weak var editProfileButton: UIButton!
  
  // User Profile.
  
  @IBOutlet weak var firstNameField: UITextField!
  @IBOutlet weak var lastNameField: UITextField!
  @IBOutlet weak var genderField: UITextField!
  @IBOutlet weak var ageField: UITextField!
  @IBOutlet weak var locationField: UITextField!
  @IBOutlet weak var emailField: UITextField!
  @IBOutlet weak var phoneField: UITextField!
  
  @IBOutlet var textFieldsArray: [UITextField]!
  
  private var user: User! {
    
    didSet {
      // Refresh the user info
      firstNameField.text = user.firstName
      lastNameField.text = user.lastName
      ageField.text = String(user.age)
      genderField.text = user.gender
      emailField.text = user.email
      locationField.text = user.location
      phoneField.text = user.phone
    }
  }
  
  private var reminderValue: PillStatusNotificationsManager.ReminderInterval = .oneWeek {
    
    didSet {
      remindMeWeeksButton.setTitle(reminderValue.toString(), forState: .Normal)
    }
  }
  
  // It's an array for letting the Table View to support multiple medicines.
  private var medicines: [Medicine] = []
  
  private var medicineStock: Int?
  private var timeMeasuringUnit: String?
  
  private var didComeBackFromLocationAutocomplete: Bool = false
  
  // Core Data
  
  private var context: NSManagedObjectContext?
  private var medicineManager: MedicineManager?
  private var psnm: PillStatusNotificationsManager?
  private var currentMedicine: Medicine?
  
  // MARK: Methods.
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Set background image
    view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
    
    // Get the last reminder value from the User Defaults
    let value = UserSettingsManager.UserSetting.pillReminderValue.getString()
    
    remindMeWeeksButton.setTitle(value, forState: .Normal)
    
    reminderValue = value.toReminderValue()
    
    let toolBar = ToolbarWithDone(viewsWithToolbar: [
      firstNameField,
      lastNameField,
      genderField,
      ageField,
      locationField,
      emailField,
      phoneField])
    
    for textField in textFieldsArray {
      textField.inputAccessoryView = toolBar
    }
    
    locationField.addTarget(self,
                            action: #selector(locationAutocompleteCallback),
                            forControlEvents: UIControlEvents.EditingDidEnd)
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    /*
     We want not to refresh the screen when the user gets back from the Google Places
     search when pressing on the location field.
     */
    
    if didComeBackFromLocationAutocomplete {
      didComeBackFromLocationAutocomplete = false
      return
    }
    
    editProfileButton.selected = false
    toggleUserInteraction(enableFields: editProfileButton.selected)
    
    refreshData()
    refreshUI()
  }
  
  func refreshUI() {
    
    // Recalculate Table View Height.
    tableViewHeightConstraint.constant = CGFloat(medicines.count) * CellHeightAndOffset
    
    tableView.reloadData()
    
    remainingLabel.text = "You have \(medicineStock!) \(timeMeasuringUnit!) of \(currentMedicine!.name) left."
    
    // Check if we need to refresh notification
    let remainingPillsBasedOnTheirInterval = medicineStock! * currentMedicine!.interval
    
    let shouldPresentNotification: Bool = psnm!.shouldPresentNotification(remainingPillsBasedOnTheirInterval, reminderValue: reminderValue.rawValue)
    
    self.remainingLabel.textColor = shouldPresentNotification ? UIColor.redColor() : Constants.DefaultBrownTint
    
    if shouldPresentNotification {
      psnm!.scheduleNotification(NSDate())
    } else {
      psnm!.unsheduleNotification()
    }
  }
  
  func refreshData() {
    context = CoreDataHelper.sharedInstance.createBackgroundContext()!
    medicineManager = MedicineManager(context: context!)
    psnm = PillStatusNotificationsManager(context: context!)
    
    // Get the current medicine stock.
    guard let medicine = medicineManager!.getCurrentMedicine() else {
      return
    }
    
    currentMedicine = medicine
    medicines = [currentMedicine!]
    
    // The result if floored.
    medicineStock = Int(currentMedicine!.remainingMedicine)
    
    if medicineStock == 1 {
      timeMeasuringUnit = (currentMedicine!.interval == 7) ? "week" : "day"
    } else {
      timeMeasuringUnit = (currentMedicine!.interval == 7) ? "weeks" : "days"
    }
    
    // Get the current user from Core Data.
    let results = User.retrieve(User.self, context: context!)
    user = results.first
    
    // TODO: Save the results for the widget.
    WidgetSettingsManager.WidgetSetting.remainingPills.setObject(medicineStock ?? 0)
    WidgetSettingsManager.WidgetSetting.remainingPillsMeasuringUnit.setObject(timeMeasuringUnit ?? "days")
  }
  
  /*
   Enabling or disabling editing on views in order to know when the user really
   wants to save the changes
   */
  
  @IBAction func editPressed(sender: UIButton) {
    
    // If the user presses the button to save the data.
    if sender.selected {
      
      // Try to update the user.
      let firstName = firstNameField.text
      let lastName = lastNameField.text
      let age = ageField.text
      let phone = phoneField.text
      let gender = genderField.text
      let email = emailField.text
      let location = locationField.text
      
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
        ToastHelper.makeToast(error.rawValue)
        return
      }
      catch {
        Logger.Error("Undefined error when trying to validate user.")
        return
      }
    }
    
    editProfileButton.selected = !editProfileButton.selected
    
    toggleUserInteraction(enableFields: sender.selected)
  }
  
  func toggleUserInteraction(enableFields value: Bool) {
    
    for textField in textFieldsArray {
      textField.userInteractionEnabled = value
    }
    
    tableView.userInteractionEnabled = value
    
    remindMeWeeksButton.userInteractionEnabled = value
    
    // Change views alpha.
    
    for textField in textFieldsArray {
      textField.alpha = value ? ViewEnabledAlpha : ViewDisabledAlpha
    }
    
    tableView.alpha = value ? ViewEnabledAlpha : ViewDisabledAlpha
    remindMeWeeksButton.alpha = value ? ViewEnabledAlpha : ViewDisabledAlpha
  }
  
  func locationAutocompleteCallback() {
    didComeBackFromLocationAutocomplete = true
  }
}

// MARK: IBActions and helpers.

extension UserProfileViewController {
  
  @IBAction func settingsBtnHandler(sender: AnyObject) {
    dispatch_async(dispatch_get_main_queue()) {
      let view = UIStoryboard.instantiate(SetupScreenPillPage.self)
      view.popupDelegate = self
      self.presentViewController(view, animated: true, completion: nil)
    }
  }
  
  @IBAction func remindMeWeeksPressed(sender: UIButton) {
    let (title, message) = (SetReminderText.title, SetReminderText.message)
    
    let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
    
    for intervalValue in PillStatusNotificationsManager.ReminderInterval.allValues {
      let action = UIAlertAction(title: intervalValue.toString(),
                                 style: UIAlertActionStyle.Default,
                                 handler: {
                                  (alert: UIAlertAction!) in
                                  
                                  self.reminderValue = intervalValue
                                  
                                  // Save the reminder value internally
                                  UserSettingsManager.UserSetting.pillReminderValue.setString(self.reminderValue.toString())
                                  
                                  self.refreshData()
                                  self.refreshUI()
      })
      
      alertController.addAction(action)
    }
    
    presentViewController(alertController, animated: true, completion: nil)
  }
}

// MARK: Table View Data Source.

extension UserProfileViewController: UITableViewDataSource {
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return medicines.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(CellReuseIdentifier, forIndexPath: indexPath) as! UserProfilePillTableViewCell
    
    let name = medicines[indexPath.row].name
    let remainingMedicine = medicines[indexPath.row].remainingMedicine
    
    cell.updateCell(self, name: name,
                    remainingMedicine: remainingMedicine,
                    indexPath: indexPath)
    cell.delegate = self
    
    return cell
  }
}

// MARK: Table View Delegate.

extension UserProfileViewController: UITableViewDelegate {
  
  // Solves iPad white cells bug:
  // http://stackoverflow.com/questions/24977047/tableview-cell-on-ipad-refusing-to-accept-clear-color
  
  func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
    cell.backgroundColor = UIColor.clearColor()
  }
}

// MARK: Setup Screen Dismiss Delegate.

extension UserProfileViewController: PresentsModalityDelegate {
  
  /// Method called when the Setup screen is dismissed.
  func onDismiss() {
    refreshData()
    refreshUI()
  }
}

// MARK: Save Remaining Pills Protocol.

extension UserProfileViewController: SaveRemainingPillsProtocol {
  
  func saveRemainingPills(textField: UITextField) {
    
    // Save new value in Core Data
    medicines[textField.tag].currentStock = Int(textField.text!)!
    medicines[textField.tag].lastStockRefill = NSDate()
    
    CoreDataHelper.sharedInstance.saveContext(context!)
    
    refreshData()
    refreshUI()
  }
}

// MARK: Text Field Delegate.

extension UserProfileViewController: UITextFieldDelegate {
  
  func textFieldDidBeginEditing(textField: UITextField) {
    let newOffset = CGPointMake(0, textField.frame.origin.y - 30)
    scrollView.setContentOffset(newOffset, animated: true)
  }
  
  func textFieldDidEndEditing(textField: UITextField) {
    let newOffset = CGPointMake(0, 0)
    scrollView.setContentOffset(newOffset, animated: true)
  }
}

// MARK: Messages.

extension UserProfileViewController {
  
  // Set reminder.
  private var SetReminderText: AlertText {
    return ("Set reminder for:", "")
  }
}