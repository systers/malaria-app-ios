import Foundation
import UIKit

/// `InfoHubPageManagerViewController` encapsulates a paged view controller.

class InfoHubPageManagerViewController : UIViewController {
  
  @IBOutlet weak var settingsBtn: UIButton!
  @IBOutlet weak var content: UIView!
  
  @IBInspectable var PageIndicatorTintColor: UIColor = UIColor(hex: 0xB2BFAF)
  @IBInspectable var PageIndicatorCurrentColor: UIColor = UIColor(hex: 0x9EB598)
  
  private var homePageEnum: InfoHubPagesVCHomePage = InfoHubPagesVCHomePage()
  private var pageViewController : UIPageViewController!
  private var _dict: [UIViewController: InfoHubPagesVCHomePage] = [:]
  
  var currentViewController: PresentsModalityDelegate!
    
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
    
    pageViewController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
    pageViewController!.dataSource = self
    pageViewController.view.frame = CGRectMake(0, content.frame.origin.y, view.frame.width, view.frame.height - content.frame.origin.y - 50)
    
    let defaultPage = getController(homePageEnum)!
    currentViewController = defaultPage as! PresentsModalityDelegate
    pageViewController!.setViewControllers([defaultPage], direction: .Forward, animated: false, completion: nil)
    
    setupUIPageControl()
    
    // Add pretended view to the hierarchy.
    pageViewController.view.backgroundColor = UIColor.clearColor()
    pageViewController.willMoveToParentViewController(self)
    addChildViewController(pageViewController)
    view.addSubview(pageViewController.view)
    pageViewController.didMoveToParentViewController(self)
    
    view.bringSubviewToFront(settingsBtn)
  }
  
  private func setupUIPageControl() {
    let appearance = UIPageControl.appearance()
    appearance.pageIndicatorTintColor = PageIndicatorTintColor
    appearance.currentPageIndicatorTintColor = PageIndicatorCurrentColor
    appearance.backgroundColor = UIColor.clearColor()
  }
  
  @IBAction func settingsButtonHandler() {
    appDelegate.presentSetupPillScreen(withDelegate: currentViewController)
  }
}

extension InfoHubPageManagerViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
  
  func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
    return InfoHubPagesVCHomePage.allValues.count
  }
  
  func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
    return homePageEnum.rawValue
  }
  
  func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
    return getController(_dict[viewController]!.previousIndex())
  }
  
  func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
    return getController(_dict[viewController]!.nextIndex())
  }
  
  private func getController(value: InfoHubPagesVCHomePage) -> UIViewController? {
    var vc: UIViewController?
    
    switch value {
    case .InfoHub:
      let view = UIStoryboard.instantiate(InfoHubViewController.self,
                                          fromStoryboard: Constants.Storyboards.InfoHub) as InfoHubViewController
      view.pagesManager = self
      vc = view
      
    case .Games:
      let view = UIStoryboard.instantiate(GamesListViewController.self,
                                          fromStoryboard: Constants.Storyboards.InfoHub) as GamesListViewController
      view.pagesManager = self
      vc = view
    case .Achievements:
      let view = UIStoryboard.instantiate(AchievementsViewController.self,
                                          fromStoryboard: Constants.Storyboards.InfoHub) as AchievementsViewController
      view.pagesManager = self
      vc = view
    default: return nil
    }
    
    // Store relative enum to view controller.
    _dict[vc!] = value
    return vc!
  }
}

enum InfoHubPagesVCHomePage: Int {
  
  static let allValues = [InfoHub, Games, Achievements]
  
  case Nil = -1, InfoHub, Games, Achievements
  
  init() {
    self = .InfoHub
  }
  
  func previousIndex() -> InfoHubPagesVCHomePage {
    return InfoHubPagesVCHomePage(rawValue: rawValue - 1)!
  }
  
  func nextIndex() -> InfoHubPagesVCHomePage {
    var value = rawValue + 1
    if value > InfoHubPagesVCHomePage.allValues.count - 1 { value = Nil.rawValue }
    return InfoHubPagesVCHomePage(rawValue: value)!
  }
}