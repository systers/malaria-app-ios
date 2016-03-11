import Foundation
import Social

/// Protocol of objects that can be shared to social media.
protocol SocialShareable {
    var message: String { get }
}

// Example of Models Conforming to SocialShareable
extension SocialShareable where Self: Stat {
    
    var message: String {
        return ("My \(self.title) is \(self.attributeValue)")
    }

}

extension MedicineLastTaken: SocialShareable {}
extension Adherence: SocialShareable {}
extension PillStreak: SocialShareable {}



