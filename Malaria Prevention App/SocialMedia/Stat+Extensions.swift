extension SocialShareable where Self: Stat {
  var message: String {
    return ("My \(self.title) is \(self.attributeValue).")
  }
}

extension MedicineLastTaken: SocialShareable {}
extension Adherence: SocialShareable {}
extension PillStreak: SocialShareable {}

