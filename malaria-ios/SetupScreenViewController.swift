import UIKit

class SetupScreenViewController : UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    @IBOutlet weak var reminderTime: UITextField!
    @IBOutlet weak var medicineName: UITextField!
    
    //private var pills : [String] = [Pill.Doxycycline.rawValue, Pill.Malarone.rawValue, Pill.Mefloquine.rawValue];
    
    var pillReminderNotificationTime = NSDate()
    let DoneButtonWidth: CGFloat = 100.0
    let DoneButtonHeight: CGFloat = 40.0
    let TimePickerHeight: CGFloat = 200.0
    let InputMedicineHeight: CGFloat = 200.0
    
    let DismissTimePickerBtnTitle = "Set"
    let BackgroundImageId = "background"
    
    private var picker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(patternImage: UIImage(named: BackgroundImageId)!)
        
        //generate medicineName Value Picker View
        medicineName.inputView = generateInputMedicineView()
        
        //generate medicineName Value Picker View
        pillReminderNotificationTime = getStoredReminderTime()
        reminderTime.inputView = generateInputTimeView(pillReminderNotificationTime)
        
        refreshPage()
    }
    
    @IBAction func medicineEditingBegin(sender: AnyObject) {
        picker.reloadAllComponents()
        
        var index = 0
        
        let currentMedicine = MedicineRegistry.sharedInstance.getRegisteredMedicine()
        
        if let m = currentMedicine{
            index = find(Medicine.Pill.allValues, Medicine.Pill(rawValue: m.name)!) ?? 0
        }
        
        picker.selectRow(index, inComponent: 0, animated: false)
    }
    
    private func refreshPage(){
        var dateformatter = NSDateFormatter()
        dateformatter.dateStyle = NSDateFormatterStyle.MediumStyle
        dateformatter.dateFormat = "HH:mm a"
        reminderTime.text = dateformatter.stringFromDate(pillReminderNotificationTime)
        medicineName.text = getStoredMedicineName()
    }
    
    @IBAction func doneButtonHandler(){
        //show next view
        if(UserSettingsManager.getBool(UserSetting.DidConfiguredMedicine)){
            dismissViewControllerAnimated(true, completion: nil)
        }else{
            
            
            //var view = ExistingViewsControllers.PagesManagerViewController.instanciateViewController() as! PagesManagerViewController
            var view = ExistingViewsControllers.DebugViewController.instanciateViewController() as! DebugViewController
            presentViewController(
                view,
                animated: true,
                completion: nil
            )
        }
        
        //setup notifications
        MedicineManager.sharedInstance.setup(Medicine.Pill(rawValue: medicineName.text)!, fireDate: pillReminderNotificationTime)
    }
    
    private func getStoredReminderTime() -> NSDate{
        let reminder: NSDate? = MedicineNotificationManager.sharedInstance.getFireDate()
        
        if let r = reminder{
            return r
        }
        
        return NSDate()
    }
    
    private func getStoredMedicineName() -> String{
        let currentMedicine = MedicineRegistry.sharedInstance.getRegisteredMedicine()
        if let m = currentMedicine{
            return m.name
        }
        
        return Medicine.Pill.allValues[0].name()
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int
    {
        return 1;
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return Medicine.Pill.allValues.count;
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String!
    {
        let pill = Medicine.Pill.allValues[row]
        
        return pill.name() + " (" + (pill.isWeekly() ? "Weekly" : "Daily") + ")"
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        self.medicineName.text = Medicine.Pill.allValues[row].name();
    }
    
    //create the view for input time
    private func generateInputTimeView(startDate: NSDate) -> UIView{
        
        let inputView = UIView(frame: CGRectMake(0, 0, self.view.frame.width, TimePickerHeight + DoneButtonHeight))
        
        var datePickerView = UIDatePicker(frame: CGRectMake(0, DoneButtonHeight, 0, 0))
        datePickerView.datePickerMode = UIDatePickerMode.Time
        datePickerView.date = startDate
        datePickerView.addTarget(self, action: "timePickerValueChanged:", forControlEvents: UIControlEvents.AllEvents)
        
        inputView.addSubview(datePickerView) // add date picker to UIView
        inputView.addSubview(generateDoneButtonView("doneChoosingTimeButton:")) // add Button to UIView
        
        return inputView
    }
    
    //create the view for input medicine view
    private func generateInputMedicineView() -> UIView{
        let inputView = UIView(frame: CGRectMake(0, 0, self.view.frame.width, InputMedicineHeight + DoneButtonHeight))
        
        picker = UIPickerView()
        picker.delegate   = self
        picker.dataSource = self
        
        inputView.addSubview(picker) // add date picker to UIView
        inputView.addSubview(generateDoneButtonView("doneChoosingMedicineButton:")) // add Button to UIView
        
        return inputView
    }
    
    //create view for done button
    private func generateDoneButtonView(action: Selector) -> UIView{
        let doneButton = UIButton(frame: CGRectMake(self.view.frame.size.width-1.75*(DoneButtonWidth/2), 0, DoneButtonWidth, DoneButtonHeight))
        doneButton.setTitle(DismissTimePickerBtnTitle, forState: UIControlState.Normal)
        doneButton.setTitle(DismissTimePickerBtnTitle, forState: UIControlState.Highlighted)
        doneButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        doneButton.setTitleColor(UIColor.grayColor(), forState: UIControlState.Highlighted)
        doneButton.addTarget(self, action: action, forControlEvents: UIControlEvents.TouchUpInside) // set button click event
        
        return doneButton
    }
    
    //Selectors
    func doneChoosingMedicineButton(sender: UIButton){
        self.medicineName.endEditing(true)
    }
    
    func doneChoosingTimeButton(sender: UIButton)
    {
        reminderTime.resignFirstResponder() // To resign the inputView on clicking done.
    }
    
    func timePickerValueChanged (sender: UIDatePicker){
        pillReminderNotificationTime = sender.date
        refreshPage()
    }
    
}