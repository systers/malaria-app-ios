import UIKit

/**
 Class that holds a Container View with the PageViewController and a PageController
 and makes sure the PageController dots change when the PVC is changing pages.
 */

protocol SetupScreenPVCContainerDelegate {
  func setPageControlIndexTo(index: Int)
}

class SetupScreenContainerViewController: UIViewController {

  @IBOutlet weak var pageControl: UIPageControl!
  @IBOutlet weak var containerView: UIView!
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if let setupPageViewController = segue.destinationViewController as? SetupPageViewController {
      setupPageViewController.containerDelegate = self
    }
  }
}

extension SetupScreenContainerViewController: SetupScreenPVCContainerDelegate {
  
  func setPageControlIndexTo(index: Int) {
    pageControl.currentPage = index
  }
}