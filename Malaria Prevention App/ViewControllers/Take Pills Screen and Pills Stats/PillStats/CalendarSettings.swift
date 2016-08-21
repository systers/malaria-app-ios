import Foundation
import UIKit
import CVCalendar

extension MonthlyViewController {
  
    func firstWeekday() -> Weekday {
        switch (NSCalendar.currentCalendar().firstWeekday % 7) {
        case 0:
            return .Saturday
        case 1:
            return .Sunday
        case 2:
            return .Monday
        case 3:
            return .Tuesday
        case 4:
            return .Wednesday
        case 5:
            return .Thursday
        case 6:
            return .Friday
        default:
            return .Sunday
        }
    }
    
    func shouldShowWeekdaysOut() -> Bool { return true }                                        /// show all days
    func topMarker(shouldDisplayOnDayView dayView: DayView) -> Bool { return false }            /// hide line above day
}

extension MonthlyViewController {
    func dotMarker(shouldShowOnDayView dayView: DayView) -> Bool { return false }
}

extension MonthlyViewController: CVCalendarViewAppearanceDelegate {
    private var WeekDayFont: UIFont { return UIFont(name: "AmericanTypewriter", size: 14)! }
    private var WeekDaySelectedFont: UIFont { return UIFont(name: "AmericanTypewriter", size: 14)! }
    private var DayWeekTextFont: UIFont { return UIFont(name: "AmericanTypewriter", size: 12)! }

    func dayLabelPresentWeekdayInitallyBold() -> Bool { return false }
    
    /// Generic days settings.
    func dayLabelWeekdaySelectedBackgroundColor() -> UIColor { return SelectedBackgroundColor }
    func dayLabelWeekdaySelectedBackgroundAlpha() -> CGFloat { return 1.0 }
    func dayLabelWeekdayInTextColor() -> UIColor { return UnselectedTextColor }
    func dayLabelWeekdayOutTextColor() -> UIColor { return OutSideMonthTextColor }
    func dayLabelWeekdaySelectedTextColor() -> UIColor { return SelectedTextBackgroundColor }
    func dayLabelWeekdayFont() -> UIFont { return WeekDayFont }
    func dayLabelWeekdaySelectedFont() -> UIFont { return WeekDaySelectedFont }
    
    /// Current day settings.
    func dayLabelPresentWeekdaySelectedBackgroundColor() -> UIColor { return SelectedTodayBackgroundColor }
    func dayLabelPresentWeekdaySelectedBackgroundAlpha() -> CGFloat { return 1.0 }
    func dayLabelPresentWeekdaySelectedTextColor() -> UIColor { return SelectedTextBackgroundColor }
    func dayLabelPresentWeekdayTextColor() -> UIColor{ return UnselectedTodayTextColor }
    func dayLabelPresentWeekdayFont() -> UIFont { return WeekDayFont }
    func dayLabelPresentWeekdaySelectedFont() -> UIFont { return WeekDaySelectedFont }
}

extension MonthlyViewController: CVCalendarMenuViewDelegate {
    func presentationMode() -> CalendarMode { return .MonthView }
    func dayOfWeekTextColor() -> UIColor { return DayWeekTextColor }
    func dayOfWeekTextUppercase() -> Bool { return true }
    func dayOfWeekFont() -> UIFont { return DayWeekTextFont }
}
