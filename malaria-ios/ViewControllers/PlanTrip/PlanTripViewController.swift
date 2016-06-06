import Foundation
import UIKit
import PickerSwift
import DoneToolbarSwift
import GoogleMaps

/// `PlanTripViewController` manages trips
class PlanTripViewController: UIViewController {
    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var departure: UITextField!
    @IBOutlet weak var arrival: UITextField!
    @IBOutlet weak var packingList: UITextField!
    @IBOutlet weak var generateTripBtn: UIButton!
    @IBOutlet weak var historyBtn: UIButton!
    @IBOutlet weak var historyTextField: UITextField!
    @IBOutlet weak var reminderTime: UITextField!

    @IBInspectable var textFieldsDateFormat: String = "M / d / yyyy"
    
    //input fields
    private var medicinePicker: MedicinePickerViewTrip!
    private var departureDatePickerview: TimePickerView!
    private var arrivalDatePickerview: TimePickerView!
    private var tripLocationHistoryPickerViewer : TripLocationHistoryPickerViewer!
    private var timePickerView : TimePickerView!
    
    //context and manager
    private var viewContext: NSManagedObjectContext!
    private var tripsManager: TripsManager!

    //Notification options
    private let FrequentReminderOption = "Frequent"
    private let NormalReminderOption = "Normal"
    private let MinimalReminderOption = "Minimal"
    private let OffReminderOption = "None"
    
    //trip information
    var tripLocation: String = ""
    var medicine: Medicine.Pill!
    var departureDay = NSDate()
    var arrivalDay = NSDate()
    var items = [(String, Bool)]()
    var reminder = NSDate().startOfDay + 9.hour //9:00
    
    private var toolBar: ToolbarWithDone!

    //AutoComplete Varibales
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        
        toolBar = ToolbarWithDone(viewsWithToolbar: [location, packingList, arrival, departure, historyTextField, reminderTime])
        
        location.inputAccessoryView = toolBar
        historyTextField.inputAccessoryView = toolBar
        
        //Setting up departure
        departureDatePickerview = TimePickerView(pickerMode: .Date, startDate: departureDay, selectCallback: {(date: NSDate) in
            self.updateDeparture(date)
        })
        departure.inputAccessoryView = toolBar
        
        // Setting up arrival date picker
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
        
        //refresh context
        viewContext = CoreDataHelper.sharedInstance.createBackgroundContext()!
        tripsManager = TripsManager(context: viewContext)
        
        //get stored information
        (departureDay, arrivalDay) = getStoredPlanTripDates()
        (items, tripLocation) = (getStoredPlanTripItems(), getStoredLocation())
        medicine = Medicine.Pill(rawValue: MedicineManager(context: viewContext).getCurrentMedicine()!.name)!
        reminder = getStoredReminderTime()
        
        updateItemsTextField(items)
        updateArrival(arrivalDay)
        updateDeparture(departureDay)
        updateReminder(reminder)
        
        //update input views
        arrival.inputView = toolBar.generateInputView(arrivalDatePickerview)
        departure.inputView = toolBar.generateInputView(departureDatePickerview)
        reminderTime.inputView = toolBar.generateInputView(timePickerView)
        
        //update history
        prepareHistoryValuePicker()
    }
    
    func prepareHistoryValuePicker(){
        tripLocationHistoryPickerViewer = TripLocationHistoryPickerViewer(context: viewContext, selectCallback: {(object: String) in
            self.generateTripBtn.enabled = !object.isEmpty
            
            self.tripLocation = object
            self.location.text = object
        })
        
        historyTextField.inputView = toolBar.generateInputView(tripLocationHistoryPickerViewer)
    }
    
    func selectItemsCallback(medicine: Medicine.Pill, listItems: [(String, Bool)]){
        updateMedicine(medicine)
        updateItemsTextField(listItems)
    }
}

/// IBActions and helpers
extension PlanTripViewController{
    @IBAction func settingsBtnHandler(sender: AnyObject) {
        //fix delay
        dispatch_async(dispatch_get_main_queue()) {
            let view = UIStoryboard.instantiate(viewControllerClass: SetupScreenViewController.self)
            self.presentViewController(view, animated: true, completion: nil)
        }
    }
    
    @IBAction func locationEditingChangedHandler(sender: AnyObject) {
        if let loc = location.text {
            generateTripBtn.enabled = !loc.isEmpty
            tripLocation = loc
        }
    }
    
    @IBAction func itemListBtnHandler(sender: AnyObject) {
        //fix delay
        dispatch_async(dispatch_get_main_queue()) {
            let view = UIStoryboard.instantiate(viewControllerClass: ListItemsViewController.self)
            view.arrival = self.arrivalDay
            view.departure = self.departureDay
            view.listItems = self.items
            view.completionHandler = self.selectItemsCallback
            self.presentViewController(view, animated: true, completion: nil)
        }
    }
    
    @IBAction func generateTrip(sender: AnyObject) {
        if tripsManager.getTrip() != nil {
            let (title, message) = (UpdateTripAlertText.title, UpdateTripAlertText.message)
            let refreshAlert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
            refreshAlert.addAction(UIAlertAction(title: AlertOptions.ok, style: .Destructive, handler: { _ in
                self.storeTrip()
            }))
            refreshAlert.addAction(UIAlertAction(title: AlertOptions.cancel, style: .Default, handler: nil))
            
            presentViewController(refreshAlert, animated: true, completion: nil)
        }else{
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
    
    private func storeTrip(){
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
        
        switch (UserSettingsManager.UserSetting.TripReminderOption.getString(FrequentReminderOption)){
        case FrequentReminderOption:
            Logger.Info("Scheduling frequent notifications for plan my trip")
            notificationManager.scheduleNotification(notificationTime)
            notificationManager.scheduleNotification(notificationTime - 1.day)
            notificationManager.scheduleNotification(notificationTime - 1.week)
        case NormalReminderOption:
            Logger.Info("Scheduling normal notifications for plan my trip")
            notificationManager.scheduleNotification(notificationTime - 1.day)
            notificationManager.scheduleNotification(notificationTime - 1.week)
        case MinimalReminderOption:
            Logger.Info("Scheduling minimal notifications for plan my trip")
            notificationManager.scheduleNotification(notificationTime - 1.day)
        case OffReminderOption:
            Logger.Warn("Trip Reminder is turned off")
        default:
            Logger.Warn("Incorrect value set for TripReminderOption")
        }
    }
    
    @IBAction func historyButtonHandler(sender: AnyObject) {
        if tripLocationHistoryPickerViewer.locations.isEmpty {
            let (title, message) = (EmptyHistoryAlertText.title, EmptyHistoryAlertText.message)
            let successAlert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
            successAlert.addAction(UIAlertAction(title: AlertOptions.ok, style: .Default, handler: nil))
            
            presentViewController(successAlert, animated: true, completion: nil)
        } else{
            historyTextField.becomeFirstResponder()
        }
    }
    
    
    @IBAction func autocompleteClicked(sender: AnyObject) {
        if Global.SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO("9.0") {
            let autocompleteController = GMSAutocompleteViewController()
            autocompleteController.delegate = self
            self.presentViewController(autocompleteController, animated: true, completion: nil)
        }
    }

}

/// local variables updaters
extension PlanTripViewController {
    private func updateDeparture(date: NSDate){
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
    
    private func updateArrival(date: NSDate){
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
    
    private func updateLocation(loc: String){
        generateTripBtn.enabled = !loc.isEmpty
        tripLocation = loc
    }
    
    private func updateMedicine(medicine: Medicine.Pill){
        self.medicine = medicine
    }
    
    private func getStoredLocation() -> String {
        return tripsManager.getTrip()?.location ?? ""
    }
    
    private func getStoredReminderTime() -> NSDate {
        return tripsManager.getTrip()?.reminderTime ?? NSDate().startOfDay + 9.hour //9:00
    }
    
    private func updateItemsTextField(items: [(String, Bool)]){
        self.items = items
        packingList.text = items.count == 0 ? "Only medicine" : "\(items.count + 1) items"
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

//messages
extension PlanTripViewController {
    typealias AlertText = (title: String, message: String)
    
    //update trip
    private var UpdateTripAlertText: AlertText {get {
        return ("Update Trip", "All data will be lost")
        }}
    
    //update trip
    private var SuccessAlertText: AlertText {get {
        return ("Success", "")
        }}
    
    //empty history
    private var EmptyHistoryAlertText: AlertText {get {
        return ("History is empty", "")
        }}
    
    //departure day error
    private var InvalidDepartureAlertText: AlertText {get {
        return ("Error", "Departure day must be before arrival")
        }}
    
    //arrival day error
    private var InvalidArrivalAlertText: AlertText {get {
        return ("Error", "Arrival day must be after departure")
        }}
    
    //type of alerts options
    private var AlertOptions: (ok: String, cancel: String) {get {
        return ("Ok", "Cancel")
        }}
}

// MARK: Autocomplete View Controller Delegate
extension PlanTripViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(viewController: GMSAutocompleteViewController, didAutocompleteWithPlace place: GMSPlace) {
        generateTripBtn.enabled = true
        tripLocation = "value"
        if let loc:String = "\(place.name)" {
            location.text = loc
            tripLocation = loc
            generateTripBtn.enabled = true
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func viewController(viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: NSError) {
        Logger.Error(error.description)
    }
    
    func wasCancelled(viewController: GMSAutocompleteViewController) {
        self.dismissViewControllerAnimated(true, completion: nil)
        Logger.Info("User canceled the operation.")
    }
    
    func didRequestAutocompletePredictions(viewController: GMSAutocompleteViewController) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        Logger.Info("Turn the network activity indicator on and off again.")
    }
    
    func didUpdateAutocompletePredictions(viewController: GMSAutocompleteViewController) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
}

// MARK: Autocomplete Results View Controller Delegate
extension PlanTripViewController: GMSAutocompleteResultsViewControllerDelegate {
    func resultsController(resultsController: GMSAutocompleteResultsViewController,
        didAutocompleteWithPlace place: GMSPlace) {
            searchController?.active = false
    }
    
    func resultsController(resultsController: GMSAutocompleteResultsViewController,
        didFailAutocompleteWithError error: NSError){
            Logger.Error(error.description)
    }
    
    func didRequestAutocompletePredictionsForResultsController(resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        Logger.Info("Turn the network activity indicator on and off again.")
    }
    
    func didUpdateAutocompletePredictionsForResultsController(resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
}