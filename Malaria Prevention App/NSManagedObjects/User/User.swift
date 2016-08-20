import Foundation
import CoreData

class User: NSManagedObject {
  
  static private let MinimumCharacterLength = 2
  static private let MinimumVolunteerAge = 12
  static private let MaximumVolunteerAge = 90
  
  enum UserValidationError: String, ErrorType {
    case FirstNameLength = "First name must have minimum two characters."
    case LastNameLength = "Last name must have minimum two characters."
    case LocationLength = "Location must have minimum two characters."
    case PhoneLength = "Phone must have minimum two characters."
    case GenderLength = "Gender must have minimum two characters."
    
    case InvalidAge = "Please insert your real age."
    case InvalidEmail = "Please insert a valid email."
    case InvalidPhone = "Please insert a valid phone number."
  }
  
  static func isUserAlreadyCreated() -> Bool {
    let newContext = CoreDataHelper.sharedInstance.createBackgroundContext()
    return User.retrieve(User.self, context: newContext!).count > 0
  }
  
  /**
   Defines or updates current user. It makes sure only one user exists at a time.
   
   - parameters:
      - firstName: The user's first name.
      - lastName: The user's last name.
      - age: The user's age.
      - email: The User's email.
      - gender: (optional) The user's gender.
      - location: (optional) The user's current / to-be location.
      - phone: (optional) The user's phone number.
   
   - throws: A validation error if the data doesn't respect our terms.
   
   - returns: A tuple which can contain the created user or,
   if the user creation failed, the corespondent error as `String`.
   */
  
  static func define(firstName: String,
                     lastName: String,
                     age: String,
                     email: String,
                     gender: String?,
                     location: String?,
                     phone: String?) throws -> User {
    
    try validateData(firstName,
                     lastName: lastName,
                     age: age,
                     email: email,
                     gender: gender,
                     location: location,
                     phone: phone)
    
    let newContext = CoreDataHelper.sharedInstance.createBackgroundContext()
    
    User.clear(User.self, context: newContext!)
    
    let user = User.create(User.self, context: newContext!)
    
    user.firstName = firstName
    user.lastName  = lastName
    user.age = Int64(age)!
    user.email = email
    
    user.location = location!
    user.gender = gender!
    user.phone = phone!
    
    CoreDataHelper.sharedInstance.saveContext(newContext!)
    
    Logger.Info("User created.")
    
    return user
  }
  
  /**
   Validates the user's information.
   
   - parameters:
      - firstName: The user's first name.
      - lastName: The user's last name.
      - age: The user's age.
      - email: The User's email.
      - gender: (optional) The user's gender.
      - location: (optional) The user's current / to-be location.
      - phone: (optional) The user's phone number.
   
   - throws: A validation error if the data doesn't respect our terms.
   
   - returns: A tuple which can contain the created user or,
   if the user creation failed, the corespondent error as `String`.
   */
  
  static private func validateData(firstName: String,
                                   lastName: String,
                                   age: String,
                                   email: String,
                                   gender: String?,
                                   location: String?,
                                   phone: String?) throws -> Bool {
      
      if firstName.characters.count < MinimumCharacterLength {
        throw UserValidationError.FirstNameLength
      }
      
      if lastName.characters.count < MinimumCharacterLength {
        throw UserValidationError.LastNameLength
      }
      
      guard let age = Int(age) else {
        throw UserValidationError.InvalidAge
      }
      
      if age < MinimumVolunteerAge || age > MaximumVolunteerAge  {
        throw UserValidationError.InvalidAge
      }
      
      if !email.isValidEmail() {
        throw UserValidationError.InvalidEmail
      }
      
      if !location!.isEmpty {
        if location!.characters.count < MinimumCharacterLength {
          throw UserValidationError.LocationLength
        }
      }
      
      if !phone!.isEmpty {
        if phone!.characters.count < MinimumCharacterLength {
          throw UserValidationError.PhoneLength
        }
        
        if !phone!.isNumber() {
          throw UserValidationError.InvalidPhone
        }
      }
      
      return true
  }
}