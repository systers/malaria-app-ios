import UIKit
import PickerSwift
import DoneToolbarSwift

/// `SetupViewController` where the user configures the current medicine and the notification time
class SetupScreenViewController : UIViewController{
    @IBOutlet weak var reminderTime: UITextField!
    @IBOutlet weak var medicineName: UITextField!
    @IBInspectable var reminderTimeFormat: String = "HH:mm a"
    
    //provided by pagesManagerViewController
    var delegate: PresentsModalityDelegate!
    
    //input pickers
    private var medicinePicker: MedicinePickerView!
    private var timePickerview: TimePickerView!
    
    private var toolBar: ToolbarWithDone!
    
    //mangagers
    private var viewContext: NSManagedObjectContext!
    private var medicineManager: MedicineManager!
    
    private var pillReminderNotificationTime: NSDate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        toolBar = ToolbarWithDone(viewsWithToolbar: [medicineName, reminderTime])
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        viewContext = CoreDataHelper.sharedInstance.createBackgroundContext()!
        
        medicineManager = MedicineManager(context: viewContext)
        
        pillReminderNotificationTime = getStoredReminderTime()
        
        //Setting up medicinePickerView with default Value
        medicinePicker = MedicinePickerView(context: viewContext, selectCallback: {(object: String) in
            self.medicineName.text = object
        })
        medicineName.inputView = toolBar.generateInputView(medicinePicker)
        medicineName.inputAccessoryView = toolBar
        
        //Setting up DatePickerView
        timePickerview = TimePickerView(pickerMode: .Time, startDate: pillReminderNotificationTime, selectCallback: {(date: NSDate) in
            self.pillReminderNotificationTime = date
            self.refreshDate()
        })
        reminderTime.inputView = toolBar.generateInputView(timePickerview)
        reminderTime.inputAccessoryView = toolBar
        
        medicineName.text = medicinePicker.selectedValue
        
        refreshDate()
    }
}

extension SetupScreenViewController{
    //could be called on the completion, however It is too late because it is noticible the screen being updated
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.CallOnDismiss()
    }
    
    func CallOnDismiss() {
        delegate?.OnDismiss()
    }
}

//IBActions and helpers
extension SetupScreenViewController {
    @IBAction func sendFeedback(sender: AnyObject) {
        openUrl(NSURL(string: "mailto:\(PeaceCorpsInfo.mail)"))
    }
    
    @IBAction func doneButtonHandler(){
        let med = Medicine.Pill(rawValue: self.medicineName.text!)!
        
        //avoid showing the alert view if there are no changes
        if let current = medicineManager.getCurrentMedicine(){
            if current.name == medicineName.text && current.notificationTime!.sameClockTimeAs(pillReminderNotificationTime){
                self.dismissViewControllerAnimated(true, completion: nil)
                return
            }
            
            let (title, message) = (ReplaceMedicineAlertText.title, ReplaceMedicineAlertText.message)
            let medicineAlert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
            medicineAlert.addAction(UIAlertAction(title: AlertOptions.ok, style: .Destructive, handler: { _ in
                self.setupMedicine(med)
                self.dismissViewControllerAnimated(true, completion: nil)
            }))
            
            medicineAlert.addAction(UIAlertAction(title: AlertOptions.cancel, style: .Default, handler: { _ in
                self.dismissViewControllerAnimated(true, completion: nil)
            }))
            
            presentViewController(medicineAlert, animated: true, completion: nil)
        } else {
            setupMedicine(med)
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    private func setupMedicine(med: Medicine.Pill) {
        medicineManager.registerNewMedicine(med.name(), interval: med.interval())
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
        reminderTime.text = pillReminderNotificationTime.formatWith(reminderTimeFormat)
    }
    
    private func getStoredReminderTime() -> NSDate{
        return medicineManager.getCurrentMedicine()?.notificationTime ?? NSDate()
    }
}

//alert messages
extension SetupScreenViewController {
    typealias AlertText = (title: String, message: String)
    
    //existing medicine configured
    private var ReplaceMedicineAlertText: AlertText {get {
        return ("This will change the current settings", "Your previous statistics won't be lost")
    }}
    
    //type of alerts options
    private var AlertOptions: (ok: String, cancel: String) {get {
        return ("Ok", "Cancel")
    }}
}