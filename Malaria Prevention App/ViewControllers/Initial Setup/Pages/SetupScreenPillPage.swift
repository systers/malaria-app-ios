import UIKit
import PickerSwift
import DoneToolbarSwift
import Crashlytics

/**
 `SetupScreenPillPage` where the user configures the current medicine
 and the notification time.
 */

class SetupScreenPillPage: SetupScreenPage {
  
  private let DefaultMedicineStockString = "0"
  
  @IBOutlet weak var reminderTimeField: UITextField!
  @IBOutlet weak var medicineNameField: UITextField!
  @IBOutlet weak var numberOfPillsField: UITextField!
  
  @IBInspectable var reminderTimeFormat: String = "HH:mm"
  
  // Can be provided by `PagesManagerViewController`.
  var popupDelegate: PresentsModalityDelegate?
  
  // Input Pickers.
  private var medicinePicker: MedicinePickerView!
  private var timePickerview: TimePickerView!
  
  private var toolBar: ToolbarWithDone!
  
  // Managers.
  private var viewContext: NSManagedObjectContext!
  private var medicineManager: MedicineManager!
  
  private var pillReminderNotificationTime: NSDate!
  
  override func viewDidLoad() {
    
    // Change background only if we are in the initial setup.
    if pageViewDelegate != nil {
      super.viewDidLoad()
    }
    
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
    
    let currentStock = getStoredMedicineStock()
    numberOfPillsField.text = currentStock
    
    pillReminderNotificationTime = getStoredReminderTime()
    self.reminderTimeField.text = pillReminderNotificationTime.formatWith(self.reminderTimeFormat)
    
    // We need to set the fields to the saved values in the CoreData or
    // to blank fields if the medicine does not exist.
    // If the medicine does not exist, we need the medicine name to register it.
    
    let callBack = { (medicine: Medicine?, medicineName: String?) in
      
      if let medicine = medicine {
        let date: NSDate = medicine.notificationTime!
        self.reminderTimeField.text = date.formatWith(self.reminderTimeFormat)
        self.pillReminderNotificationTime = date
        self.medicineNameField.text = medicine.name
        self.numberOfPillsField.text = String(medicine.remainingMedicine)
      } else {
        self.reminderTimeField.text = NSDate().formatWith(self.reminderTimeFormat)
        
        self.medicineNameField.text = medicineName
        self.numberOfPillsField.text = self.DefaultMedicineStockString
      }
    }
    // Setting up medicinePickerView with default value.
    medicinePicker = MedicinePickerView(context: viewContext,
                                        selectCallback: callBack)
    medicineNameField.inputView = toolBar.generateInputView(medicinePicker)
    medicineNameField.inputAccessoryView = toolBar
    
    // Setting up DatePickerView.
    timePickerview = TimePickerView(pickerMode: .Time,
                                    startDate: pillReminderNotificationTime,
                                    selectCallback: {(date: NSDate) in
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

extension SetupScreenPillPage {
  
  override func viewDidDisappear(animated: Bool) {
    super.viewDidDisappear(animated)
    
    let remainingPills = Int(numberOfPillsField.text!)
    
    if remainingPills == nil || remainingPills! == 0 {
      ToastHelper.makeToast(
        NSLocalizedString("You need to refill your pill stock from the User Profile.",
          comment: "Appears when the user has zero pills on himself."), duration: 4)
    }
  }
  
  // Could be called on the completion, however It is too late because it is noticible the screen being updated.
  
  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    
    callOnDismiss()
  }
  
  func callOnDismiss() {
    popupDelegate?.onDismiss()
  }
}

// MARK: IBActions and helpers.

extension SetupScreenPillPage {
  
  @IBAction func doneButtonHandler() {
    
    let med = Medicine.Pill(rawValue: medicineNameField.text!)!
    
    let remainingPills = Int(numberOfPillsField.text!) ?? 0
    
    // Avoid showing the alert view if there are no changes
    if let current = medicineManager.getCurrentMedicine() {
      
      if current.name == medicineNameField.text
        && current.notificationTime!.sameClockTimeAs(pillReminderNotificationTime)
        && current.currentStock == remainingPills {
        dismissViewController()
        return
      }
      
      let (title, message) = (ReplaceMedicineAlertText.title,
                              ReplaceMedicineAlertText.message)
      let medicineAlert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
      medicineAlert.addAction(UIAlertAction(title: AlertOptions.ok, style: .Destructive, handler: { _ in
        
        // Send Answers (Crashlytics) log to server
        Answers.logCustomEventWithName("User changed pill.",
          customAttributes: ["Medicine Name" : current.name])
        
        self.setupMedicine(med, remainingPills: remainingPills)
        self.dismissViewController()
      }))
      
      medicineAlert.addAction(UIAlertAction(title: AlertOptions.cancel, style: .Default, handler: { _ in
        self.dismissViewController()
      }))
      
      presentViewController(medicineAlert, animated: true, completion: nil)
    } else {
      setupMedicine(med, remainingPills: remainingPills)
      dismissViewController()
    }
  }
  
  // Checks whether the initial app setup was finished or if we just dismissed the
  // pop-up version of this view controller.
  
  private func dismissViewController() {
    
    // If we are in the initial setup.
    if pageViewDelegate != nil {
      appDelegate.window?.rootViewController = UIStoryboard.instantiate(TabbedBarController.self)
      appDelegate.window?.makeKeyAndVisible()
      return
    }
    
    // If we presented this screen as a popup.
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  private func setupMedicine(med: Medicine.Pill,
                             remainingPills: Int,
                             notificationTime: NSDate = NSDate()) {
    medicineManager.registerNewMedicine(med.name(),
                                        interval: med.interval())
    medicineManager.setCurrentPill(med.name())
    
    let currentPill = medicineManager.getCurrentMedicine()!
    currentPill.currentStock = remainingPills
    currentPill.lastStockRefill = NSDate()
    
    UserSettingsManager.UserSetting.didConfigureMedicine.setBool(true)
    
    let notificationManager = currentPill.notificationManager
    
    if !UserSettingsManager.UserSetting.medicineReminderSwitch.getBool(true) {
      Logger.Error("Medicine Notifications are not enabled.")
      return
    }
    
    notificationManager.scheduleNotification(pillReminderNotificationTime)
  }
  
  private func refreshDate() {
    reminderTimeField.text = pillReminderNotificationTime.formatWith(reminderTimeFormat)
  }
  
  private func getStoredReminderTime() -> NSDate {
    return medicineManager.getCurrentMedicine()?.notificationTime ?? NSDate()
  }
  
  private func getStoredMedicineStock() -> String {
    if let medicine = medicineManager.getCurrentMedicine() {
      return String(medicine.remainingMedicine)
    } else {
      return DefaultMedicineStockString
    }
  }
}

// MARK: Alert messages.

extension SetupScreenPillPage {
  
  // Existing medicine configured.
  
  private var ReplaceMedicineAlertText: AlertText {
    return (NSLocalizedString("This will change the current settings",
      comment: "Users just pressed that he will want to change the medicine.")
      , NSLocalizedString("Your previous statistics won't be lost",
        comment: ""))
  }
  
  // Type of alerts options.
  
  private var AlertOptions: (ok: String, cancel: String) {
    return (NSLocalizedString("Ok", comment: "Users selects OK to continue."),
            NSLocalizedString("Cancel", comment: "Users selects Cancel to continue."))
  }
}