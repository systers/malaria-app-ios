import Foundation
import UIKit
import CVCalendar

/**
 `MonthlyViewController`: shows the calendar view.
 
 Using variation of CVCalendar by changing CVCalendarMonthContentViewController
 and commenting the lines calling the methods responsible for making the transitioning.
 
 This was done because, for e.g., August 30 and 31 2015 were impossible to select due to the automatic transition.
 */

class MonthlyViewController: UIViewController {
  
  @IBOutlet weak var calendarView: CVCalendarView!
  @IBOutlet weak var menuView: CVCalendarMenuView!
  @IBOutlet weak var monthLabel: UILabel!
  @IBOutlet weak var calendarFrame: UIView!
  
  @IBInspectable var TitleDateFormat: String = "MMMM, yyyy"
  @IBInspectable var DidNotTakeMedicineColor: UIColor = UIColor(red: 0.894, green: 0.429, blue: 0.442, alpha: 1.0)
  @IBInspectable var TookMedicineColorColor: UIColor = UIColor(red: 0.374, green: 0.609, blue: 0.574, alpha: 1.0)
  @IBInspectable var SelectedBackgroundColor: UIColor = UIColor(hex: 0xE3C79B)
  @IBInspectable var SelectedTodayBackgroundColor: UIColor = UIColor(hex: 0xE3C79B)
  @IBInspectable var UnselectedTextColor: UIColor = UIColor(hex: 0x444444)
  @IBInspectable var UnselectedTodayTextColor: UIColor = UIColor.blackColor()
  @IBInspectable var DayWeekTextColor: UIColor = UIColor(hex: 0x444444)
  @IBInspectable var CurrentDayUnselectedCircleFillColor: UIColor = UIColor(hex: 0xA1D4E2)
  @IBInspectable var SelectedDayDotMarkerColor: UIColor = UIColor.blackColor()
  @IBInspectable var InsideMonthTextColor: UIColor = UIColor(hex: 0x444444)
  @IBInspectable var OutSideMonthTextColor: UIColor = UIColor(hex: 0x999999)
  @IBInspectable var SelectedTextBackgroundColor: UIColor = UIColor.blackColor()
  
  // Provided by previous View Controller.
  var startDay: NSDate!
  var callback: (() -> ())?
  
  // Helpers.
  private var firstRun = true
  private var previouslySelect: NSDate?
  private var currentMonth: NSDate?
  private var animationFinished = true
  
  // Hack because CVCalendar doesn't support updates yet.
  private var dayViews = [NSDate : Set<DayView>]()
  private let RingViewTag = 123
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    previouslySelect = startDay
    currentMonth = startDay
    monthLabel.text = generateMonthLabel(startDay)
    calendarView.toggleViewWithDate(startDay)
  }
  
  private func generateMonthLabel(date: NSDate) -> String {
    return date.formatWith(TitleDateFormat).capitalizedString
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    calendarView.commitCalendarViewUpdate()
    menuView.commitMenuViewUpdate()
    firstRun = false
  }
  
  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    callback?()
  }
}

/// MARK: IBActions.

extension MonthlyViewController {
  
  @IBAction func previousMonthToggle(sender: AnyObject) {
    calendarView.loadPreviousView()
  }
  
  @IBAction func nextMonthToggle(sender: AnyObject) {
    calendarView.loadNextView()
  }
  
  @IBAction func todayMonthView() {
    calendarView.toggleCurrentDayView()
  }
  
  @IBAction func closeBtnHandler(sender: AnyObject) {
    dismissViewControllerAnimated(true, completion: nil)
  }
}

extension MonthlyViewController: CVCalendarViewDelegate {
  func preliminaryView(viewOnDayView dayView: DayView) -> UIView {
    let circleView = CVAuxiliaryView(dayView: dayView, rect: dayView.bounds, shape: CVShape.Circle)
    circleView.fillColor = CurrentDayUnselectedCircleFillColor
    return circleView
  }
  
  func preliminaryView(shouldDisplayOnDayView dayView: DayView) -> Bool {
    return dayView.isCurrentDay
  }
  
  func createRingView(dayView: DayView, tookMedicine: Bool) -> CVAuxiliaryView {
    let ringView = CVAuxiliaryView(dayView: dayView, rect: dayView.bounds, shape: CVShape.Circle)
    ringView.fillColor = UIColor.clearColor()
    ringView.strokeColor = tookMedicine ? TookMedicineColorColor : DidNotTakeMedicineColor
    ringView.tag = RingViewTag
    return ringView
  }
  
  func supplementaryView(viewOnDayView dayView: DayView) -> UIView {
    if let  date = dayView.date,
      registryDate = date.convertedDate(),
      tookMedicine = CachedStatistics.sharedInstance.tookMedicine[registryDate.startOfDay]{
      return createRingView(dayView, tookMedicine: tookMedicine)
    }
    
    return UIView()
  }
  
  func supplementaryView(shouldDisplayOnDayView dayView: DayView) -> Bool {
    if let  date = dayView.date,
      registryDate = date.convertedDate() {
      
      //hack
      if let d = dayView.date.convertedDate() {
        if dayViews[d.startOfDay] == nil {
          dayViews[d.startOfDay] = Set<DayView>()
        }
        dayViews[d.startOfDay]!.insert(dayView)
      }
      
      return CachedStatistics.sharedInstance.tookMedicine[registryDate.startOfDay] != nil
    }
    
    return false
  }
}

extension MonthlyViewController {
  
  func didSelectDayView(dayView: DayView, animationDidFinish: Bool) {
    
    let selected = dayView.date.convertedDate()!
    if let previous = previouslySelect {
      
      //avoids appearing when switching months
      let selectedSameMonth = previous.sameMonthAs(selected)
      
      if !firstRun && selectedSameMonth {
        if let registryDate = dayView.date.convertedDate() {
          popup(registryDate.startOfDay, dayView: dayView)
        }
      }
    }
    
    previouslySelect = selected
  }
  
  private func popup(date: NSDate, dayView: CVCalendarDayView) {
    if date > NSDate() {
      let (title, message) = (SelectedFutureDateAlertText.title, SelectedFutureDateAlertText.message)
      
      let failAlert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
      failAlert.addAction(UIAlertAction(title: AlertOptions.ok, style: .Default, handler: nil))
      presentViewController(failAlert, animated: true, completion: nil)
      
      return
    }
    
    let (title, message) = generateTookMedicineActionSheetText(date)
    
    let tookPillActionSheet: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .ActionSheet)
    tookPillActionSheet.addAction(UIAlertAction(title: TookMedicineAlertActionText.did, style: .Default, handler: { _ in
      if CachedStatistics.sharedInstance.medicineStockManager.addRegistry(date, tookMedicine: true, modifyEntry: true) {
        CachedStatistics.sharedInstance.updateTookMedicineStats(date, progress: self.updateDayView)
      }
    }))
    
    tookPillActionSheet.addAction(UIAlertAction(title: TookMedicineAlertActionText.didNot, style: .Default, handler: { _ in
      if CachedStatistics.sharedInstance.medicineStockManager.addRegistry(date, tookMedicine: false, modifyEntry: true) {
        CachedStatistics.sharedInstance.updateTookMedicineStats(date, progress: self.updateDayView)
      }
    }))
    tookPillActionSheet.addAction(UIAlertAction(title: AlertOptions.cancel, style: .Cancel, handler: nil))
    
    
    // For iPad.
    if let popoverController = tookPillActionSheet.popoverPresentationController {
      popoverController.sourceView = dayView
      popoverController.sourceRect = dayView.bounds
    }
    presentViewController(tookPillActionSheet, animated: true, completion: nil)
  }
  
  /// Hack until library offers what we need.
  func updateDayView(day: NSDate, remove: Bool) {
    if let dViews = dayViews[day] {
      
      if remove {
        for dView in dViews {
          dView.viewWithTag(RingViewTag)?.removeFromSuperview()
        }
      } else {
        for dView in dViews {
          let tookMedicine = CachedStatistics.sharedInstance.tookMedicine[day] ?? false
          if let ringView = dView.viewWithTag(RingViewTag) {
            (ringView as? CVAuxiliaryView)!.strokeColor = tookMedicine ? TookMedicineColorColor : DidNotTakeMedicineColor
          } else {
            dView.insertSubview(createRingView(dView, tookMedicine: tookMedicine), atIndex: 0)
          }
        }
      }
    }
  }
  
  func presentedDateUpdated(date: CVDate) {
    let convertedDate = date.convertedDate()!
    if !currentMonth!.sameMonthAs(convertedDate) && self.animationFinished {
      currentMonth = convertedDate
      let updatedMonthLabel = UILabel()
      updatedMonthLabel.text = generateMonthLabel(convertedDate)
      
      updatedMonthLabel.textColor = monthLabel.textColor
      updatedMonthLabel.font = monthLabel.font
      updatedMonthLabel.textAlignment = .Center
      updatedMonthLabel.sizeToFit()
      updatedMonthLabel.alpha = 0
      updatedMonthLabel.center = self.monthLabel.center
      
      let offset = CGFloat(48)
      updatedMonthLabel.transform = CGAffineTransformMakeTranslation(0, offset)
      updatedMonthLabel.transform = CGAffineTransformMakeScale(1, 0.1)
      
      UIView.animateWithDuration(0.35, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
        self.animationFinished = false
        self.monthLabel.transform = CGAffineTransformMakeTranslation(0, -offset)
        self.monthLabel.transform = CGAffineTransformMakeScale(1, 0.1)
        self.monthLabel.alpha = 0
        
        updatedMonthLabel.alpha = 1
        updatedMonthLabel.transform = CGAffineTransformIdentity
        
      }) { _ in
        
        self.animationFinished = true
        self.monthLabel.frame = updatedMonthLabel.frame
        self.monthLabel.text = updatedMonthLabel.text
        self.monthLabel.transform = CGAffineTransformIdentity
        self.monthLabel.alpha = 1
        updatedMonthLabel.removeFromSuperview()
      }
      
      self.view.insertSubview(updatedMonthLabel, aboveSubview: self.monthLabel)
    }
  }
}

/// MARK: Alert messages.

extension MonthlyViewController {
  
  // Selected future entry.
  private var SelectedFutureDateAlertText: AlertText {
    return (NSLocalizedString("Not possible to change entries in the future", comment: ""), "")
  }
  
  private func generateTookMedicineActionSheetText(date: NSDate) -> AlertText {
    let isWeekly = CachedStatistics.sharedInstance.medicine.interval == 7
    let tookMedicine = CachedStatistics.sharedInstance.registriesManager.tookMedicine(date)
    
    let weeklyLocalizedString = NSLocalizedString("weekly", comment: "Every week")
    let dailyLocalizedString = NSLocalizedString("daily", comment: "Every day")
    
    let intervalRegularity = isWeekly ? weeklyLocalizedString : dailyLocalizedString
    let dateString = date.formatWith("MMMM d yyyy")
    
    let firstLocalizedStringWithFormat = String.localizedStringWithFormat(NSLocalizedString("You already took your %@ pill",
      comment: "When the user already took the pill."), intervalRegularity)
    
    let secondLocalizedStringWithFormat = String.localizedStringWithFormat(NSLocalizedString("Did you take your medicine on %@ ?",
      comment: "Asks if the user took his medicine on a respective date."), dateString)
    
    let thirdLocalizedStringWithFormat = String.localizedStringWithFormat(NSLocalizedString("You didn't take your %@ pill",
      comment: "When the user didn't take the pill."), intervalRegularity)
    
    if tookMedicine != nil {
      return (firstLocalizedStringWithFormat, secondLocalizedStringWithFormat)
    } else {
      return (thirdLocalizedStringWithFormat, secondLocalizedStringWithFormat)
    }
  }
  
  // Did take pill alert text.
  private var TookMedicineAlertActionText: (did: String, didNot: String) {
    return (NSLocalizedString("Yes, I did", comment: ""),
            NSLocalizedString("No, I didn't", comment: ""))
  }
  
  // Type of alerts options.
  private var AlertOptions: (ok: String, cancel: String, dismiss: String) {
    return (NSLocalizedString("Ok", comment: ""),
            NSLocalizedString("Cancel", comment: ""),
            NSLocalizedString("Dismiss", comment: ""))
  }
}