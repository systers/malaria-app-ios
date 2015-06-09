import UIKit

class DailyStatsViewController: UIViewController {
    
    @IBOutlet weak var medicineLastTaken: UILabel!
    @IBOutlet weak var DosesInARow: UILabel!
    @IBOutlet weak var Adherence: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logger("loaded pills daily stats")
    }
}

