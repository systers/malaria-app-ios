import Foundation
import UIKit
import PickerSwift
import DoneToolbarSwift
import GoogleMaps

/// `PlanTripViewController` manages trips.

class PlanTripViewController: UIViewController {
  
  // MARK: Outlets.
  
  @IBOutlet weak var location: UITextField!
  @IBOutlet weak var departure: UITextField!
  @IBOutlet weak var arrival: UITextField!
  @IBOutlet weak var packingList: UITextField!
  @IBOutlet weak var generateTripBtn: UIButton!
  @IBOutlet weak var historyBtn: UIButton!
  @IBOutlet weak var historyTextField: UITextField!
  @IBOutlet weak var reminderTime: UITextField!
  
  @IBInspectable var textFieldsDateFormat: String = "M / d / yyyy"
  
  // MARK: Properties.
  
  // Input fields.
  private var medicinePicker: MedicinePickerViewTrip!
  private var departureDatePickerview: TimePickerView!
  private var arrivalDatePickerview: TimePickerView!
  private var tripLocationHistoryPickerViewer : TripLocationHistoryPickerViewer!
  private var timePickerView : TimePickerView!
  
  // Context and manager.
  private var viewContext: NSManagedObjectContext!
  private var tripsManager: TripsManager!
  
  // Notification options.
  
  private enum NotificationOption: String {
    case frequent = "Frequent"
    case normal = "Normal"
    case minimal = "Minimal"
    case none = "None"
  }
  
  // Trip information.
  var tripLocation: String = ""
  var medicine: Medicine.Pill!
  var departureDay = NSDate()
  var arrivalDay = NSDate()
  var items = [(String, Bool)]()
  var reminder = NSDate().startOfDay + 9.hour // 9:00
  
  private var toolBar: ToolbarWithDone!
  
  // MARK: Methods.
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
    
    toolBar = ToolbarWithDone(viewsWithToolbar: [location, packingList, arrival, departure, historyTextField, reminderTime])
    
    location.inputAccessoryView = toolBar
    historyTextField.inputAccessoryView = toolBar
    
    // Setting up departure.
    departureDatePickerview = TimePickerView(pickerMode: .Date, startDate: departureDay, selectCallback: {(date: NSDate) in
      self.updateDeparture(date)
    })
    departure.inputAccessoryView = toolBar
    
    // Setting up arrival date picker.
    arrivalDatePickerview = TimePickerView(pickerMode: .Date, startDate: arrivalDay, selectCallback: {(date: NSDate) in
      self.updateArrival(date)
    })
    arrival.inputAccessoryView = toolBar
    
    timePickerView = TimePickerView(pickerMode: .Time, startDate: reminder, selectCallback: {(date: NSDate) in
      self.updateReminder(date)
    })
    reminderTime.inputAccessoryView = toolBar
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    // Refresh context.
    viewContext = CoreDataHelper.sharedInstance.createBackgroundContext()!
    tripsManager = TripsManager(context: viewContext)
    
    // Get stored information.
    (departureDay, arrivalDay) = getStoredPlanTripDates()
    (items, tripLocation) = (getStoredPlanTripItems(), getStoredLocation())
    medicine = Medicine.Pill(rawValue: MedicineManager(context: viewContext).getCurrentMedicine()!.name)!
    reminder = getStoredReminderTime()
    
    updateItemsTextField(items)
    updateArrival(arrivalDay)
    updateDeparture(departureDay)
    updateReminder(reminder)
    
    // Update input views.
    arrival.inputView = toolBar.generateInputView(arrivalDatePickerview)
    departure.inputView = toolBar.generateInputView(departureDatePickerview)
    reminderTime.inputView = toolBar.generateInputView(timePickerView)
    
    // Update history.
    prepareHistoryValuePicker()
  }
  
  func prepareHistoryValuePicker() {
    tripLocationHistoryPickerViewer = TripLocationHistoryPickerViewer(context: viewContext, selectCallback: {(object: String) in
      self.generateTripBtn.enabled = !object.isEmpty
      
      self.tripLocation = object
      self.location.text = object
    })
    
    historyTextField.inputView = toolBar.generateInputView(tripLocationHistoryPickerViewer)
  }
  
  func selectItemsCallback(medicine: Medicine.Pill, listItems: [(String, Bool)]) {
    updateMedicine(medicine)
    updateItemsTextField(listItems)
  }
}

// MARK: IBActions and helpers.

extension PlanTripViewController {
  
  @IBAction func settingsBtnHandler(sender: AnyObject) {
    
    // Fixes delay.
    dispatch_async(dispatch_get_main_queue()) {
      let view = UIStoryboard.instantiate(SetupScreenPillPage.self)
      self.presentViewController(view, animated: true, completion: nil)
    }
  }
  
  @IBAction func itemListBtnHandler(sender: AnyObject) {
    
    // Fixes delay.
    dispatch_async(dispatch_get_main_queue()) {
      let view = UIStoryboard.instantiate(ListItemsViewController.self)
      view.arrival = self.arrivalDay
      view.departure = self.departureDay
      view.listItems = self.items
      view.completionHandler = self.selectItemsCallback
      self.presentViewController(view, animated: true, completion: nil)
    }
  }
  
  @IBAction func generateTrip(sender: AnyObject) {
    if location.text?.characters.count == 0 {
      // Show alert message.
      ToastHelper.makeToast(NSLocalizedString("Location text can't be empty.",
        comment: "Appears when user forgets to write down his trip location"))
      return
    }
    
    if tripsManager.getTrip() != nil {
      let (title, message) = (UpdateTripAlertText.title, UpdateTripAlertText.message)
      let refreshAlert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
      refreshAlert.addAction(UIAlertAction(title: AlertOptions.ok, style: .Destructive, handler: { _ in
        self.storeTrip()
      }))
      refreshAlert.addAction(UIAlertAction(title: AlertOptions.cancel, style: .Default, handler: nil))
      
      presentViewController(refreshAlert, animated: true, completion: nil)
    } else {
      self.storeTrip()
      
      let (title, message) = (SuccessAlertText.title, SuccessAlertText.message)
      let successAlert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
      successAlert.addAction(UIAlertAction(title: AlertOptions.ok, style: .Default, handler: nil))
      
      presentViewController(successAlert, animated: true, completion: nil)
      
      delay(3.0) {
        successAlert.dismissViewControllerAnimated(true, completion: nil)
      }
    }
  }
  
  private func storeTrip() {
    let trip = tripsManager.createTrip(location.text!, medicine: medicine.name(), departure: departureDay, arrival: arrivalDay, timeReminder: reminder)
    let itemManager = trip.itemsManager
    items.foreach({ itemManager.addItem($0.0, quantity: 1) })
    itemManager.toggleCheckItem( items.filter({ $0.1 }).map({ $0.0 }))
    
    scheduleNotifications(trip)
    prepareHistoryValuePicker()
  }
  
  private func scheduleNotifications(trip: Trip) {
    let notificationManager = trip.notificationManager
    
    let notificationTime = departureDay.startOfDay + reminder.hour.hour + reminder.minutes.minute
    
    switch UserSettingsManager.UserSetting.tripReminderOption.getString(NotificationOption.frequent.rawValue) {
      
    case NotificationOption.frequent.rawValue:
      
      Logger.Info("Scheduling frequent notifications for plan my trip.")
      notificationManager.scheduleNotification(notificationTime)
      notificationManager.scheduleNotification(notificationTime - 1.day)
      notificationManager.scheduleNotification(notificationTime - 1.week)
      
    case NotificationOption.normal.rawValue:
      
      Logger.Info("Scheduling normal notifications for plan my trip.")
      notificationManager.scheduleNotification(notificationTime - 1.day)
      notificationManager.scheduleNotification(notificationTime - 1.week)
      
    case NotificationOption.minimal.rawValue:
      
      Logger.Info("Scheduling minimal notifications for plan my trip.")
      notificationManager.scheduleNotification(notificationTime - 1.day)
      
    case NotificationOption.none.rawValue:
      
      Logger.Warn("Trip Reminder is turned off.")
      
    default:
      Logger.Warn("Incorrect value set for tripReminderOption.")
    }
  }
  
  @IBAction func historyButtonHandler(sender: AnyObject) {
    if tripLocationHistoryPickerViewer.locations.isEmpty {
      let (title, message) = (EmptyHistoryAlertText.title, EmptyHistoryAlertText.message)
      let successAlert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
      successAlert.addAction(UIAlertAction(title: AlertOptions.ok, style: .Default, handler: nil))
      
      presentViewController(successAlert, animated: true, completion: nil)
    } else {
      historyTextField.becomeFirstResponder()
    }
  }
}

// MARK: Local variables updaters.

extension PlanTripViewController {
  private func updateDeparture(date: NSDate) {
    if date.startOfDay > arrivalDay.startOfDay {
      let (title, message) = (InvalidDepartureAlertText.title, InvalidDepartureAlertText.message)
      let refreshAlert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
      refreshAlert.addAction(UIAlertAction(title: AlertOptions.ok, style: .Default, handler: nil))
      
      presentViewController(refreshAlert, animated: true, completion: nil)
    } else {
      departureDay = date
      departure.text = date.formatWith(textFieldsDateFormat)
    }
  }
  
  private func updateArrival(date: NSDate) {
    if date.startOfDay < departureDay.startOfDay {
      let (title, message) = (InvalidArrivalAlertText.title, InvalidArrivalAlertText.message)
      let refreshAlert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
      refreshAlert.addAction(UIAlertAction(title: AlertOptions.ok, style: .Default, handler: nil))
      
      presentViewController(refreshAlert, animated: true, completion: nil)
    }else {
      arrivalDay = date
      arrival.text = date.formatWith(textFieldsDateFormat)
    }
  }
  
  private func updateReminder(time: NSDate) {
    reminder = time
    reminderTime.text = time.formatWith("hh:mm a")
  }
  
  private func updateLocation(loc: String) {
    generateTripBtn.enabled = !loc.isEmpty
    tripLocation = loc
  }
  
  private func updateMedicine(medicine: Medicine.Pill) {
    self.medicine = medicine
  }
  
  private func getStoredLocation() -> String {
    return tripsManager.getTrip()?.location ?? ""
  }
  
  private func getStoredReminderTime() -> NSDate {
    return tripsManager.getTrip()?.reminderTime ?? NSDate().startOfDay + 9.hour //9:00
  }
  
  private func updateItemsTextField(items: [(String, Bool)]) {
    self.items = items
    
    let firstLocalizedString =
      NSLocalizedString("Only medicine",
                        comment: "Means that the user is only taking medicine with himself on a trip")
    let secondLocalizedString = NSString.localizedStringWithFormat(NSLocalizedString("%i items",
      comment: "The number of items taken in the trip."), items.count + 1) as String
    
    packingList.text = items.count == 0 ? firstLocalizedString : secondLocalizedString
  }
  
  private func getStoredPlanTripItems() -> [(String, Bool)] {
    return tripsManager.getTrip()?.itemsManager.getItems().map({ ($0.name, $0.check) }) ?? []
  }
  
  func getStoredPlanTripDates() -> (departure: NSDate, arrival: NSDate) {
    if let trip = tripsManager.getTrip() {
      return (trip.departure, trip.arrival)
    }
    
    return (NSDate(), NSDate() + 1.week)
  }
}

// MARK: Messages.

extension PlanTripViewController {
  
  // Update trip.
  private var UpdateTripAlertText: AlertText {
    return (
      NSLocalizedString("Update Trip",
        comment: "Alert Option that lets the user update the trip options."),
      NSLocalizedString("All data will be lost",
        comment: "Tells the user that the trip data will be lost"))
  }
  
  // Succesfully update trip.
  private var SuccessAlertText: AlertText {
    return (NSLocalizedString("Success", comment: ""), "")
  }
  
  // Empty history.
  private var EmptyHistoryAlertText: AlertText {
    return (NSLocalizedString("History is empty", comment: "Shows that the trip history is empty"), "")
  }
  
  // Departure day error.
  private var InvalidDepartureAlertText: AlertText {
    return (
      NSLocalizedString("Error",
        comment: "There was an error when creating the trip."),
      NSLocalizedString("Departure day must be before arrival", comment: ""))
  }
  
  // Arrival day error.
  private var InvalidArrivalAlertText: AlertText {
    return (
      NSLocalizedString("Error",
        comment: "There was an error when creating the trip."),
      NSLocalizedString("Arrival day must be after departure",
        comment: "User selected an arrival date before the departure date."))
  }
  
  // Type of alerts options.
  private var AlertOptions: (ok: String, cancel: String) {
    return (NSLocalizedString("Ok", comment: ""),
            NSLocalizedString("Cancel", comment: ""))
  }
}