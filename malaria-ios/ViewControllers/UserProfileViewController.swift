import UIKit
import DoneToolbarSwift

// MARK: - Protocol

protocol SaveRemainingPillsProtocol: class {
  func saveRemainingPills(textField: UITextField)
}

// MARK: - Table View controller

class UserProfileViewController: UIViewController {
  
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
    recalculateTableHeight()
  }
  
  func dismissKeyboard() {
    view.endEditing(true)
  }
  
  func getRegisteredMedicine() {
    medicine = []
    medicine.append(medicineManager!.getCurrentMedicine()!)
    
    // To get all medicine use only:
    // medicine = medicineManager!.getRegisteredMedicines()
  }
  
  func calculateMedicineLeft() {
    guard let currentMedicine = medicineManager!.getCurrentMedicine() else {
      remainingLabel.text = ""
      return
    }
    
    tableView.reloadData()

    // remaining value is floored (opposed to ceiled)
    let remaining = Int(currentMedicine.remainingMedicine) / currentMedicine.interval
    
    let timeMeasuringUnit = (currentMedicine.interval == 7) ? "weeks" : "days"
    
    remainingLabel.text = "You have \(remaining) \(timeMeasuringUnit) of \(currentMedicine.name) left."
    
    // Save pill status to show it in the widget
    WidgetSettingsManager.WidgetSetting.RemainingPills.setObject(remaining)
    WidgetSettingsManager.WidgetSetting.RemainingPillsMeasuringUnit.setObject(timeMeasuringUnit)
    
    let shouldPresentNotification: Bool = psnm!.shouldPresentNotification(remaining, reminderValue: reminderValue.rawValue)
    
    shouldPresentNotification ? psnm!.scheduleNotification(NSDate()) : psnm!.unsheduleNotification()
    
    let defaultBrownTint = self.remindMeWeeksButton.titleLabel?.textColor
    self.remainingLabel.textColor = shouldPresentNotification ? UIColor.redColor() : defaultBrownTint
  }
  
  func recalculateTableHeight() {
    tableViewHeightConstraint.constant = CGFloat(medicine.count) * Constants.UserProfile.CellHeightAndOffset
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
    let alertController = UIAlertController(title: "Set reminder for:", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
    
    for intervalValue in PillStatusNotificationsManager.ReminderInterval.allValues {
      let action = UIAlertAction(title: intervalValue.toString(),
                                 style: UIAlertActionStyle.Default,
                                 handler: {
                                  (alert: UIAlertAction!) in
                                  
                                  self.reminderValue = intervalValue
                                  
                                  // Save the reminder value internally
                                  UserSettingsManager.UserSetting.PillReminderValue.setString(self.reminderValue.toString())
                                  
                                  // Recalculate medicine left
                                  self.calculateMedicineLeft()
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
    let cell = tableView.dequeueReusableCellWithIdentifier(Constants.UserProfile.CellReuseIdentifier, forIndexPath: indexPath) as! UserProfilePillTableViewCell
    
    let name = medicine[indexPath.row].name
    let remainingMedicine = medicine[indexPath.row].remainingMedicine
    
    cell.updateCellWithParameters(self,
                                  name: name,
                                  remainingMedicine: String(remainingMedicine),
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
  
  func OnDismiss() {
    getRegisteredMedicine()
    recalculateTableHeight()
    tableView.reloadData()
  }
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
  }
}