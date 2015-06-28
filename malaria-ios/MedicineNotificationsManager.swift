import Foundation
import UIKit

class MedicineNotificationsManager : NotificationManager{
    override var category: String { get{ return "PillReminder"} }

    var medicine: Medicine!
    
    init(medicine: Medicine){
        self.medicine = medicine
    }
    
    func scheduleNotification(fireTime: NSDate){
        unsheduleNotification()
        
        let notification: UILocalNotification = createNotification(fireTime, alertBody: "hello", alertAction: "double")
        super.scheduleNotification(notification)
        
        medicine.notificationTime = fireTime
    }
    
    override func unsheduleNotification(){
        super.unsheduleNotification()
        CoreDataHelper.sharedInstance.saveContext()
    }

    func reshedule(){
        if var nextTime = medicine.notificationTime{
            nextTime += medicine.isDaily() ? 1.day : 7.day
            medicine.notificationTime = nextTime
        }
        
        if medicine.isCurrent{
            Logger.Error("Error: there should be already a fire date")
        }
    }
    
    /*
    If the user fails to take their medication mid-way through a week, and a full 7 days goes by without the medication being recorded, on DayX+7 the system will start again and allow the user to enter new data for that week. So if the user is supposed to take medications on Mondays, and next Monday arrives with no data entry, the day and date at the top will go back to black text, and the system will now record data for that new week and consider the previous week a missed week.
    */
    func checkIfShouldReset(currentDate: NSDate = NSDate()) -> Bool{
        if let mostRecent = medicine.registriesManager.mostRecentEntry(){
            //get ellaped days
            return (currentDate - mostRecent).day > 7
        }
        
        Logger.Warn("There is no registry yet registred")
        return false
    }
}