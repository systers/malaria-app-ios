import UIKit
import DoneToolbarSwift

// MARK: - Protocol

protocol SaveRemainingPillsProtocol: class {
  func saveRemainingPills(textField: UITextField)
}

/// A class that stores all the user information and sets up the Pill Taking mechanism.

// MARK: - Table View controller

class UserProfileViewController: UIViewController {
  
  // We found a problem that didn't allow us to click on the table view's cell if we only set the cell
  // height (60) and not add ~30-50 offset to it
  let CellHeightAndOffset: CGFloat = 60 + 30
  let CellReuseIdentifier = "User Profile Pill Cell Identifier"
  
  @IBOutlet weak var remindMeWeeksButton: UIButton!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var remainingLabel: UILabel!
  
  private var medicine: [Medicine] = []
  private var reminderValue: PillStatusNotificationsManager.ReminderInterval = .OneWeek {
    didSet {
      remindMeWeeksButton.setTitle(reminderValue.toString(), forState: .Normal)
    }
  }
  
  private var medicineStock: Int?
  private var timeMeasuringUnit: String?
  
  // Core Data
  
  private var context: NSManagedObjectContext?
  private var medicineManager: MedicineManager?
  private var psnm: PillStatusNotificationsManager?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Set background image
    view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
    
    // Get the last reminder value from the User Defaults
    let value = UserSettingsManager.UserSetting.PillReminderValue.getString()
    
    remindMeWeeksButton.setTitle(value, forState: .Normal)
    
    self.reminderValue = value.toReminderValue()
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    context = CoreDataHelper.sharedInstance.createBackgroundContext()!
    medicineManager = MedicineManager(context: context!)
    psnm = PillStatusNotificationsManager(context: context!)
    
    getRegisteredMedicine()
    calculateMedicineLeft()
    saveRemainingPillStatusForTheWidget()
    recalculateTableHeight()
    refreshScreen(checkIfWeNeedToPresentNotification())
  }
  
  func dismissKeyboard() {
    view.endEditing(true)
  }
  
  /// Gets the current medicine the user uses.
  /// To get a list of all the medicine use:
  /// medicine = medicineManager!.getRegisteredMedicines()

  func getRegisteredMedicine() {
    guard let currentMedicine = medicineManager!.getCurrentMedicine() else {
      return
    }
    
    medicine = [currentMedicine]
  }
  
  /// Calculates and sets medicineStock and timeMeasuringUnit values.
  
  func calculateMedicineLeft() {
    guard let currentMedicine = medicineManager!.getCurrentMedicine() else {
      remainingLabel.text = ""
      return
    }
    
    // The result if floored.
    medicineStock = Int(currentMedicine.remainingMedicine)
    
    if medicineStock == 1 {
      timeMeasuringUnit = (currentMedicine.interval == 7) ? "week" : "day"
    }
    else {
      timeMeasuringUnit = (currentMedicine.interval == 7) ? "weeks" : "days"
    }
  }
  
  // Refreshes all elements of the UI that can change, based on the current medicine stock.
  
  func refreshScreen(shouldPresentNotification: Bool) {
    tableView.reloadData()
    
    guard let currentMedicine = medicineManager!.getCurrentMedicine() else {
      remainingLabel.text = ""
      return
    }
    
    remainingLabel.text = "You have \(medicineStock!) \(timeMeasuringUnit!) of \(currentMedicine.name) left."
    
    let defaultBrownTint = self.remindMeWeeksButton.titleLabel?.textColor
    self.remainingLabel.textColor = shouldPresentNotification ? UIColor.redColor() : defaultBrownTint
    
    shouldPresentNotification ? psnm!.scheduleNotification(NSDate()) : psnm!.unsheduleNotification()
  }
  
  /// Save medicine stock status to show be shown in the widget.
  
  func saveRemainingPillStatusForTheWidget() {
    WidgetSettingsManager.WidgetSetting.RemainingPills.setObject(medicineStock ?? 0)
    WidgetSettingsManager.WidgetSetting.RemainingPillsMeasuringUnit.setObject(timeMeasuringUnit ?? "days")
  }
  
  func checkIfWeNeedToPresentNotification() -> Bool {
    guard let currentMedicine = medicineManager!.getCurrentMedicine() else {
      return false
    }
    
    let remainingPillsBasedOnTheirInterval = medicineStock! * currentMedicine.interval
    let shouldPresentNotification: Bool = psnm!.shouldPresentNotification(remainingPillsBasedOnTheirInterval, reminderValue: reminderValue.rawValue)
    
    return shouldPresentNotification
  }
  
  /// Calculates a new table height that will be as tall as the number of cells in the table.
  
  func recalculateTableHeight() {
    tableViewHeightConstraint.constant = CGFloat(medicine.count) * CellHeightAndOffset
  }
}

// MARK: IBActions and helpers

extension UserProfileViewController {
  
  @IBAction func settingsBtnHandler(sender: AnyObject) {
    dispatch_async(dispatch_get_main_queue()) {
      let view = UIStoryboard.instantiate(viewControllerClass: SetupScreenViewController.self)
      view.delegate = self
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
                                  UserSettingsManager.UserSetting.PillReminderValue.setString(self.reminderValue.toString())
                                  
                                  self.calculateMedicineLeft()
                                  self.saveRemainingPillStatusForTheWidget()
                                  self.refreshScreen(self.checkIfWeNeedToPresentNotification())
      })
      
      alertController.addAction(action)
    }
    
    presentViewController(alertController, animated: true, completion: nil)
  }
}

// MARK: Table View Data Source

extension UserProfileViewController: UITableViewDataSource {
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return medicine.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(CellReuseIdentifier, forIndexPath: indexPath) as! UserProfilePillTableViewCell
    
    let name = medicine[indexPath.row].name
    let remainingMedicine = medicine[indexPath.row].remainingMedicine
    
    cell.updateCell(self, name: name,
                    remainingMedicine: remainingMedicine,
                    indexPath: indexPath)
    cell.delegate = self
    
    return cell
  }
}

// MARK: Table View Delegate

extension UserProfileViewController: UITableViewDelegate {
  
  // Solves iPad white cells bug:
  // http://stackoverflow.com/questions/24977047/tableview-cell-on-ipad-refusing-to-accept-clear-color
  
  func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
    cell.backgroundColor = UIColor.clearColor()
  }
}

// MARK: Setup Screen Dismiss Delegate

extension UserProfileViewController: PresentsModalityDelegate {
  
  /// Method called when the Setup screen is dismissed.
  func OnDismiss() {
    getRegisteredMedicine()
    recalculateTableHeight()
    calculateMedicineLeft()
    saveRemainingPillStatusForTheWidget()
    refreshScreen(checkIfWeNeedToPresentNotification())  }
}

// MARK: Save Remaining Pills Protocol

extension UserProfileViewController: SaveRemainingPillsProtocol {
  
  func saveRemainingPills(textField: UITextField) {
    // Save new value in Core Data
    medicine[textField.tag].remainingMedicine = Int64(textField.text!)!
    medicine[textField.tag].lastStockRefill = NSDate()
    
    CoreDataHelper.sharedInstance.saveContext(context!)
    
    // Recalculate medicine left
    calculateMedicineLeft()
    saveRemainingPillStatusForTheWidget()
    refreshScreen(checkIfWeNeedToPresentNotification())
  }
}

// MARK: Messages

extension UserProfileViewController {
  typealias AlertText = (title: String, message: String)

  // Set reminder
  private var SetReminderText: AlertText {
    get {
      return ("Set reminder for:", "")
    }
  }
}