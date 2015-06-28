import UIKit

class DidTakePillsViewController: UIViewController {
    
    //next pill day
    @IBOutlet weak var weekDay: UILabel!
    @IBOutlet weak var currentDay: UILabel!
    @IBOutlet weak var didNotTookMedicineBtn: UIButton!
    @IBOutlet weak var tookMedicineBtn: UIButton!
    
    @IBAction func didNotTookMedicineBtnHandler(sender: AnyObject) {
        Logger.Info("didNotTookMedicineBtnHandler")
        
        //MedicineRegistry.sharedInstance.addRegistry(NSDate(), tookMedicine: false)
    }
    
    @IBAction func tookMedicineBtnHandler(sender: AnyObject) {
        Logger.Info("tookMedicineBtnHandler")
        //MedicineRegistry.sharedInstance.addRegistry(NSDate(), tookMedicine: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Logger.Info("loaded didTakePills")
        
        //let didTookPill = MedicineManager.sharedInstance.didTookPill(NSDate())
     
        /*
        didNotTookMedicineBtn.enabled = !didTookPill
        tookMedicineBtn.enabled = !didTookPill
        */
    }
}