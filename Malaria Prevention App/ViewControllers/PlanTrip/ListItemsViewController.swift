import Foundation
import UIKit

/// `ListItemsViewController` manages trip items.

class ListItemsViewController : UIViewController{
  @IBOutlet weak var tableView: UITableView!
  @IBInspectable var DeleteButtonColor: UIColor = UIColor(hex: 0xA9504A)
  
  // Provided by previous viewController.
  var departure: NSDate!
  var arrival: NSDate!
  var listItems: [(String, Bool)] = []
  var completionHandler: ((Medicine.Pill, [(String, Bool)]) -> ())!
  
  // Internal.
  private var medicine: Medicine.Pill!
  private var medicineManager: MedicineManager!
  private var viewContext = CoreDataHelper.sharedInstance.createBackgroundContext()!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressHandler))
    longPressGestureRecognizer.minimumPressDuration = 0.75
    longPressGestureRecognizer.delegate = self
    tableView.addGestureRecognizer(longPressGestureRecognizer)
  }
  
  @IBAction func cancelBtnHandler(sender: AnyObject) {
    view.endEditing(true)
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  @IBAction func doneBtnHandler(sender: AnyObject) {
    completionHandler(medicine, listItems)
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  @IBAction func addNewItem(sender: AnyObject) {
    generateAddItemAlert()
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    viewContext = CoreDataHelper.sharedInstance.createBackgroundContext()!
    medicineManager = MedicineManager(context: viewContext)
    
    if let trip = TripsManager(context: viewContext).getTrip() {
      medicine = Medicine.Pill(rawValue: trip.medicine)!
    }else {
      medicine = Medicine.Pill(rawValue: medicineManager.getCurrentMedicine()!.name)!
    }
    
    self.listItems.sortInPlace({ $0.0.lowercaseString < $1.0.lowercaseString })
    tableView.reloadData()
  }
}

extension ListItemsViewController : UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate {
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return listItems.count
  }
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return 50.0
  }
  
  func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
    let deleteButton = UITableViewRowAction(style: .Default,
                                            title: NSLocalizedString("Delete", comment: ""),
                                            handler: { (action, indexPath) in
                                              self.listItems.removeAtIndex(indexPath.row)
                                              tableView.reloadData()
    })
    deleteButton.backgroundColor = DeleteButtonColor
    return [deleteButton]
  }
  
  func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    return true
  }
  
  func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if (editingStyle == UITableViewCellEditingStyle.Delete) {
      listItems.removeAtIndex(indexPath.row)
      tableView.reloadData()
    }
  }
  
  internal func longPressHandler(gestureRecognizer:UIGestureRecognizer) {
    let point = gestureRecognizer.locationInView(tableView)
    
    if let indexPath = tableView.indexPathForRowAtPoint(point) {
      if gestureRecognizer.state == UIGestureRecognizerState.Began {
        generateModifyItemAlert(indexPath)
      }
    }
  }
  
  func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let cell = (tableView.dequeueReusableCellWithIdentifier("MedicineHeaderCell") as! MedicineHeaderCell)
    cell.name.setTitle(medicine.name(), forState: .Normal)
    
    let neededPills = MedicineStats.numberNeededPills(departure, date2: arrival, interval: self.medicine.interval())
    cell.quantity.text = NSString.localizedStringWithFormat(NSLocalizedString("%i pills", comment: "The number of pills taken in the trip"), neededPills) as String
    
    cell.name.titleLabel?.adjustsFontSizeToFitWidth = true
    return cell.contentView
  }
  
  func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 78.0
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let item = listItems[indexPath.row]
    
    TripsManager(context: viewContext).getTrip()?.itemsManager.toggleCheckItem([item.0])
    
    let isSelected = item.1
    listItems[indexPath.row].1 = !isSelected
    tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let item = listItems[indexPath.row]
    let cell = tableView.dequeueReusableCellWithIdentifier("ItemCell") as! ItemCell
    return cell.configureCell(item.0, broughtItem: item.1)
  }
  
  @IBAction func medicineBtn(sender: AnyObject) {
    let (title, message) = (PickMedicineAlertText.title, PickMedicineAlertText.message)
    let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
    
    let medicines = Medicine.Pill.allValues.map({$0.name()})
    for m in medicines {
      alert.addAction(UIAlertAction(title: m, style: .Default) { _ in
        self.medicine = Medicine.Pill(rawValue: m)!
        self.tableView.reloadData()
        })
    }
    alert.addAction(UIAlertAction(title: AlertOptions.cancel, style: .Cancel, handler: nil))
    
    self.presentViewController(alert, animated: true, completion: nil)
  }
}

// MARK: Alerts generators.

extension ListItemsViewController {
  
  private func generateAddItemAlert() {
    let alert = UIAlertController(title: CreateEntryAlertText.title, message: CreateEntryAlertText.message, preferredStyle: .Alert)
    
    alert.addAction(UIAlertAction(title: AlertOptions.done, style: .Default) { _ in
      let textFieldText = (alert.textFields![0] ).text!
      
      if !textFieldText.isEmpty && self.listItems.filter({$0.0.lowercaseString == textFieldText.lowercaseString}).isEmpty {
        let tuple = (textFieldText, false)
        self.listItems.append(tuple)
        
        self.listItems.sortInPlace({ $0.0.lowercaseString < $1.0.lowercaseString })
        self.tableView.reloadData()
      }
      })
    
    alert.addTextFieldWithConfigurationHandler { (textField: UITextField!) -> Void in
      textField.placeholder = NSLocalizedString("Name", comment: "")
      textField.text = ""
      textField.clearButtonMode = .WhileEditing
    }
    alert.addAction(UIAlertAction(title: AlertOptions.cancel, style: .Cancel, handler: nil))
    
    
    self.presentViewController(alert, animated: true, completion: nil)
    
  }
  
  private func generateModifyItemAlert(indexPath: NSIndexPath) {
    let (title, message) = (ModifyEntryAlertText.title, ModifyEntryAlertText.message)
    let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
    
    alert.addAction(UIAlertAction(title: AlertOptions.done, style: .Default) { _ in
      let textField = alert.textFields![0]
      
      self.listItems[indexPath.row].0 = textField.text!
      self.listItems[indexPath.row].1 = false
      self.listItems.sortInPlace({ $0.0.lowercaseString < $1.0.lowercaseString })
      self.tableView.reloadData()
      })
    
    alert.addTextFieldWithConfigurationHandler { (textField: UITextField!) -> Void in
      textField.placeholder = NSLocalizedString("Name", comment: "")
      textField.text = self.listItems[indexPath.row].0
    }
    alert.addAction(UIAlertAction(title: AlertOptions.cancel, style: .Cancel, handler: nil))
    
    self.presentViewController(alert, animated: true, completion: nil)
  }
}

// MARK: Messages.

extension ListItemsViewController {
  
  // Pick medicine.
  private var PickMedicineAlertText: AlertText {
    return (
      NSLocalizedString("What do you want to bring to the trip?", comment: ""),
      NSLocalizedString("Pick one medicine", comment: "When the user needs to choose between medicines."))
  }
  
  // Change entry.
  private var ModifyEntryAlertText: AlertText {
    return (NSLocalizedString("Change item", comment: "Changing an item in the trip."), "")
  }
  
  // New entry.
  private var CreateEntryAlertText: AlertText {
    return (NSLocalizedString("What do you want to bring to the trip?", comment: ""), "")
  }
  
  // Type of alerts options.
  private var AlertOptions: (done: String, cancel: String) {
    return (
      NSLocalizedString("Done", comment: ""),
      NSLocalizedString("Cancel", comment: ""))
  }
}

class ItemCell : UITableViewCell {
  @IBOutlet weak var name: UILabel!
  @IBOutlet weak var hasItem: UIView!
  
  @IBInspectable var BroughtItemColor: UIColor = UIColor(hex: 0x96C262)
  @IBInspectable var DidNotBringItemColor: UIColor = UIColor(hex: 0xDF8782)
  
  func configureCell(name: String, broughtItem: Bool) -> ItemCell {
    self.name.text = name
    hasItem.borderColor = broughtItem ? BroughtItemColor : DidNotBringItemColor
    
    // Necessary on ipad, something related on contentView.background
    // not the same as the cell.
    self.backgroundColor = self.backgroundColor
    return self
  }
}

class MedicineHeaderCell: UITableViewCell {
  @IBOutlet weak var name: UIButton!
  @IBOutlet weak var quantity: UILabel!
}