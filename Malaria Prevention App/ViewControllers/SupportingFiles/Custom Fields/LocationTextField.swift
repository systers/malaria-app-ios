import UIKit
import GoogleMaps
/**
 `UITextField` that pops a Google Places search VC.
 
 Requires internet connection and an iOS version greater than 9.0.
 */

class LocationTextField: UITextField {
  
  let rootViewController = UIApplication.sharedApplication().keyWindow?.rootViewController
    
  /*
   If this view is inside a VC that is presented, we need to keep track of the
   presentedVC, in order to dismiss the VC that we will be presenting from it.
   */
  
  var presentedViewController: UIViewController?
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    self.addTarget(self,
                   action: #selector(clicked),
                   forControlEvents: UIControlEvents.EditingDidBegin)
  }
  
  func clicked(sender: AnyObject) {
    
    if Global.SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO("9.0")
      && Reachability.isConnectedToNetwork() {
      
      let autocompleteController = GMSAutocompleteViewController()
      autocompleteController.delegate = self
      
      // Check if we already have something presented.
      if rootViewController?.presentedViewController != nil {
        presentedViewController = rootViewController?.presentedViewController
        presentedViewController!.presentViewController(autocompleteController,
                                                       animated: true,
                                                       completion: nil)
      } else {
        rootViewController!.presentViewController(autocompleteController,
                                                  animated: true,
                                                  completion: nil)
      }
    }
  }
  
  func dismissTopViewController() {
    
    if presentedViewController != nil {
      presentedViewController!.dismissViewControllerAnimated(true, completion: nil)
    } else {
      rootViewController!.dismissViewControllerAnimated(true, completion: nil)
    }
  }
}

// MARK: Autocomplete View Controller Delegate.

extension LocationTextField: GMSAutocompleteViewControllerDelegate {
  
  // Handle the user's selection.
  
  func viewController(viewController: GMSAutocompleteViewController,
                      didAutocompleteWithPlace place: GMSPlace) {
    text = place.name
    dismissTopViewController()
  }
  
  func viewController(viewController: GMSAutocompleteViewController,
                      didFailAutocompleteWithError error: NSError) {
    Logger.Error(error.description)
  }
  
  func wasCancelled(viewController: GMSAutocompleteViewController) {
    dismissTopViewController()
    Logger.Info("User canceled the operation.")
  }
  
  func didRequestAutocompletePredictions(viewController: GMSAutocompleteViewController) {
    UIApplication.sharedApplication().networkActivityIndicatorVisible = true
  }
  
  func didUpdateAutocompletePredictions(viewController: GMSAutocompleteViewController) {
    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
  }
}