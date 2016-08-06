import UIKit
import PickerSwift
import DoneToolbarSwift
import Crashlytics

/// `SetupViewController` where the user configures the current medicine and the notification time

class SetupScreenViewController: UIViewController {
  @IBOutlet weak var reminderTimeField: UITextField!
  @IBOutlet weak var medicineNameField: UITextField!
  @IBOutlet weak var numberOfPillsField: UITextField!
  
  @IBInspectable var reminderTimeFormat: String = "HH:mm"
  
  // Provided by `PagesManagerViewController`.
  var delegate: PresentsModalityDelegate!
  
  // Input Pickers.
  private var medicinePicker: MedicinePickerView!
  private var timePickerview: TimePickerView!
  
  private var toolBar: ToolbarWithDone!
  
  // Managers.
  private var viewContext: NSManagedObjectContext!
  private var medicineManager: MedicineManager!
  
  private var pillReminderNotificationTime: NSDate!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    toolBar = ToolbarWithDone(viewsWithToolbar: [
      medicineNameField,
      reminderTimeField,
      numberOfPillsField
      ]
    )
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    viewContext = CoreDataHelper.sharedInstance.createBackgroundContext()!
    medicineManager = MedicineManager(context: viewContext)
    
    // Set current stock number.
    if let medicine = medicineManager.getCurrentMedicine() {
      let numberOfPills = medicine.remainingMedicine
      numberOfPillsField.text = String(numberOfPills)
    } else {
      numberOfPillsField.text = "0"
    }
    
    pillReminderNotificationTime = getStoredReminderTime()
    
    // Setting up medicinePickerView with default value.
    medicinePicker = MedicinePickerView(context: viewContext,
                                        selectCallback: {(object: String) in
                                          self.medicineNameField.text = object
    })
    medicineNameField.inputView = toolBar.generateInputView(medicinePicker)
    medicineNameField.inputAccessoryView = toolBar
    
    // Setting up DatePickerView.
    timePickerview = TimePickerView(pickerMode: .Time, startDate: pillReminderNotificationTime, selectCallback: {(date: NSDate) in
      self.pillReminderNotificationTime = date
      self.refreshDate()
    })
    reminderTimeField.inputView = toolBar.generateInputView(timePickerview)
    reminderTimeField.inputAccessoryView = toolBar
    
    numberOfPillsField.inputAccessoryView = toolBar
    
    medicineNameField.text = medicinePicker.selectedValue
    
    refreshDate()
  }
}

// MARK: Setup Screen Protocol.

extension SetupScreenViewController {
  
  // Could be called on the completion, however It is too late because it is noticible the screen being updated.
  
  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    callOnDismiss()
  }
  
  func callOnDismiss() {
    delegate?.onDismiss()
  }
}

// MARK: IBActions and helpers.

extension SetupScreenViewController {
  
  @IBAction func sendFeedback(sender: AnyObject) {
    openUrl(NSURL(string: "mailto:\(PeaceCorpsInfo.mail)"))
  }
  
  @IBAction func doneButtonHandler() {
    let med = Medicine.Pill(rawValue: medicineNameField.text!)!
    let remainingPills = Int(self.numberOfPillsField.text!)
    
    if remainingPills == 0 {
      ToastHelper.makeToast("You need to refill your pill stock from the User Profile.", duration: 4)
    }
    
    // Avoid showing the alert view if there are no changes
    if let current = medicineManager.getCurrentMedicine() {
      
      // Check if the medicine stock changed.
      if current.remainingMedicine != Int64(remainingPills!) {
        current.medicineStockManager.updateStock(remainingPills!)
      }
      
      if current.name == medicineNameField.text
        && current.notificationTime!.sameClockTimeAs(pillReminderNotificationTime) {
        self.dismissViewControllerAnimated(true, completion: nil)
        return
      }
      
      let (title, message) = (ReplaceMedicineAlertText.title, ReplaceMedicineAlertText.message)
      let medicineAlert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
      medicineAlert.addAction(UIAlertAction(title: AlertOptions.ok, style: .Destructive, handler: { _ in
        
        // Send Answers (Crashlytics) log to server
        Answers.logCustomEventWithName("User changed pill.", customAttributes: ["Medicine Name" : current.name])
        
        self.setupMedicine(med, remainingPills: remainingPills!)
        self.dismissViewControllerAnimated(true, completion: nil)
      }))
      
      medicineAlert.addAction(UIAlertAction(title: AlertOptions.cancel, style: .Default, handler: { _ in
        self.dismissViewControllerAnimated(true, completion: nil)
      }))
      
      presentViewController(medicineAlert, animated: true, completion: nil)
    } else {
      setupMedicine(med, remainingPills: remainingPills!)
      self.dismissViewControllerAnimated(true, completion: nil)
    }
  }
  
  private func setupMedicine(med: Medicine.Pill, remainingPills: Int) {
    medicineManager.registerNewMedicine(med.name(), interval: med.interval(), remainingMedicine: remainingPills)
    medicineManager.setCurrentPill(med.name())
    UserSettingsManager.UserSetting.DidConfiguredMedicine.setBool(true)
    
    let notificationManager = medicineManager.getCurrentMedicine()!.notificationManager
    
    if !UserSettingsManager.UserSetting.MedicineReminderSwitch.getBool(true){
      Logger.Error("Medicine Notifications are not enabled")
      return
    }
    
    notificationManager.scheduleNotification(pillReminderNotificationTime)
  }
  
  private func refreshDate(){
    reminderTimeField.text = pillReminderNotificationTime.formatWith(reminderTimeFormat)
  }
  
  private func getStoredReminderTime() -> NSDate{
    return medicineManager.getCurrentMedicine()?.notificationTime ?? NSDate()
  }
}

// MARK: Alert messages.

extension SetupScreenViewController {
  
  typealias AlertText = (title: String, message: String)
  
  // Existing medicine configured
  
  private var ReplaceMedicineAlertText: AlertText {get {
    return ("This will change the current settings", "Your previous statistics won't be lost")
    }
  }
  
  // Type of alerts options
  
  private var AlertOptions: (ok: String, cancel: String) {get {
    return ("Ok", "Cancel")
    }
  }
}