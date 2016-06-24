extension String {
  
  func isNumber() -> Bool {
    // Check if the user copy-pastes something in the input fields
    let invalidCharacters = NSCharacterSet(charactersInString: "0123456789").invertedSet
    
    return self.rangeOfCharacterFromSet(invalidCharacters, options: [], range: self.startIndex ..< self.endIndex) == nil
  }
  
  func toReminderValue() -> PillStatusNotificationsManager.ReminderInterval {
    switch self {
    case "4 days": return .FourDays
    case "1 week": return .OneWeek
    case "2 weeks": return .TwoWeeks
    case "4 weeks": return .FourWeeks
    default: return .OneWeek
    }
  }
}