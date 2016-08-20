import UIKit

protocol SetupPageViewControllerDelegate: class {
  func changePage()
}

class SetupPageViewController: UIPageViewController {
  
  // Communicate with Setup Screen Container.
  var containerDelegate: SetupScreenPVCContainerDelegate! = nil

  private(set) lazy var orderedViewControllers: [SetupScreenPage] = {
    return [
      UIStoryboard.instantiate(SetupScreenMalariaPage.self,
        fromStoryboard: Constants.Storyboards.InitialSetup),
      UIStoryboard.instantiate(SetupScreenUserProfilePage.self,
        fromStoryboard: Constants.Storyboards.InitialSetup),
      UIStoryboard.instantiate(SetupScreenPillPage.self,
        fromStoryboard: Constants.Storyboards.InitialSetup),
    ]
  }()
  
  private var currentPageIndex: Int = 0 {
    
    didSet {
      
      // Get the next View Controller.
      let viewController = orderedViewControllers[currentPageIndex]
      viewController.pageViewDelegate = self
      
      setViewControllers([viewController],
                         direction: .Forward,
                         animated: true,
                         completion: nil)
      
      // Alert the Page Control in the `SetupScreenContainerViewController`.
      containerDelegate.setPageControlIndexTo(currentPageIndex)
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    currentPageIndex = 0
  }
}

extension SetupPageViewController: SetupPageViewControllerDelegate {
  
  func changePage() {
    currentPageIndex += 1
  }
}