import Foundation
import UIKit

class DebugViewController : UIViewController{
    
    @IBOutlet weak var dayWeek: UILabel!
    @IBOutlet weak var fullDate: UILabel!
    @IBOutlet weak var medicineLastTaken: UILabel!
    @IBOutlet weak var dosesInRow: UILabel!
    @IBOutlet weak var monthAdherence: UILabel!
    @IBOutlet weak var adherence: UILabel!
    @IBOutlet weak var graphViewStartDate: UITextField!
    @IBOutlet weak var graphViewEndDate: UITextField!
    @IBOutlet weak var graphAdherence: UILabel!
    
    @IBAction func SettingsBtnHandler(sender: AnyObject) {
        //fix delay
        dispatch_async(dispatch_get_main_queue()) {
            self.performSegueWithIdentifier("showSetupScreen", sender: nil)
        }
    }
    
    @IBAction func noBtnHandler(sender: AnyObject) {
        Logger.Info("Pressed No")
        //MedicineRegistry.sharedInstance.addRegistry(NSDate(), tookMedicine: false)
        viewDidLoad()
    }
    
    @IBAction func yesBtnHandler(sender: AnyObject) {
        //MedicineRegistry.sharedInstance.addRegistry(NSDate(), tookMedicine: true)
        Logger.Info("Pressed Yes")
        viewDidLoad()
    }
    
    @IBAction func updateAdherence(sender: AnyObject) {
        graphAdherence.text = "here"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        //let didTookPill = MedicineManager.sharedInstance.didTookPill(NSDate())
        
        /*
        didNotTookMedicineBtn.enabled = !didTookPill
        tookMedicineBtn.enabled = !didTookPill
        */
        
        
        /*
        let lastPillDate: NSDate? = MedicineManager.sharedInstance.lastPillDateRegistry()
        
        if let d = lastPillDate{
            var dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "dd/MM"
            medicineLastTaken.text = dateFormatter.stringFromDate(d)
        }else{
            medicineLastTaken.text = " -- "
        }
        */
        
        /*
        dosesInRow.text = "\(MedicineManager.sharedInstance.currentStreak())"
        adherence.text = "\(100*MedicineManager.sharedInstance.currentPillAdherence())%"
        */
    }

}