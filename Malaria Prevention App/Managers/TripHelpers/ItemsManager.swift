import Foundation

/// Manages trip items.

class ItemsManager : CoreDataContextManager {
  let trip: Trip
  
  init(trip: Trip) {
    self.trip = trip
    super.init(context: trip.managedObjectContext!)
  }
  
  /**
   Adds a new item to the trip.
   
   - parameter name: name of the item.
   - parameter quantity: It will be always at least 1.
   */
  
  func addItem(name: String, quantity: Int64) {
    let quant = max(quantity, 1)
    
    if let i = findItem(name) {
      Logger.Info("Updating quantity for an existing item")
      i.add(quant)
    } else {
      let item = Item.create(Item.self, context: self.context)
      item.name = name
      item.quantity = quant
      
      var newArray = getItems()
      newArray.append(item)
      trip.items = NSSet(array: newArray)
    }
    
    CoreDataHelper.sharedInstance.saveContext(self.context)
  }
  
  /**
   Returns an item from the trip if exists.
   
   - parameter name: name of the item (case insensitive).
   - parameter listItems: optional cached list of items.
   
   - returns: The item.
   */
  
  func findItem(name: String, listItems: [Item]? = nil) -> Item? {
    let items = listItems != nil ? listItems! : getItems()
    return items.filter({$0.name.lowercaseString == name.lowercaseString}).first
  }
  
  /**
   Checkmarks the items.
   
   - parameter names: names of the items (case insensitive).
   */
  
  func checkItem(names: [String]) {
    let listItems = getItems()
    names.foreach({ self.findItem($0, listItems: listItems)?.check = true })
    CoreDataHelper.sharedInstance.saveContext(self.context)
  }
  
  /**
   Removes the checkmark.
   
   - parameter names: names of the items (case insensitive).
   */
  
  func uncheckItem(names: [String]) {
    let listItems = getItems()
    names.foreach({ self.findItem($0, listItems: listItems)?.check = false })
    CoreDataHelper.sharedInstance.saveContext(self.context)
  }
  
  /**
   Toggles the checkmark.
   
   - parameter names: name of the items (case insensitive).
   */
  
  func toggleCheckItem(names: [String]) {
    let listItems = getItems()
    names.foreach({ self.findItem($0, listItems: listItems)?.toogle() })
    CoreDataHelper.sharedInstance.saveContext(self.context)
  }
  
  /**
   Removes a item from the trip.
   
   If quantity is specified, it only removes the specified number,
   if not, removes the item completly.
   
   - parameter name: The name of the item.
   - parameter quantity: the quantity.
   */
  
  func removeItem(name: String, quantity: Int64 = Int64.max) {
    if let i = findItem(name) {
      i.remove(quantity)
      if i.quantity == 0{
        var array: [Item] = trip.items.convertToArray()
        array.removeAtIndex(array.indexOf(i)!)
        trip.items = NSSet(array: array)
        i.deleteFromContext(self.context)
      }
      
      CoreDataHelper.sharedInstance.saveContext(self.context)
    } else {
      Logger.Error("Item not found")
    }
  }
  
  /**.
   Returns all items from the trip
   
   - returns: The array of items.
   */
  
  func getItems() -> [Item] {
    return trip.items.convertToArray()
  }
}