import UIKit

typealias GameInfo = (name: String, rules: String)

class GamesListViewController: UIViewController {
  
  @IBOutlet weak var collectionView: UICollectionView!
  
  // New games are added just by creating them and adding an instance to this array
  private var gamesInfo: [GameInfo] = [
    (RapidFireGame.name, RapidFireGame.rules),
    (MythVsFactGame.name, MythVsFactGame.rules)
  ]
  
  var pagesManager: InfoHubPageManagerViewController!

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    pagesManager.currentViewController = self
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    let gameCellIndex = sender as! Int
    
    let gameRulesVC = segue.destinationViewController as! GameRulesViewController
    gameRulesVC.gameInfo = gamesInfo[gameCellIndex]
  }
}

// MARK: Collection View Data Source

extension GamesListViewController: UICollectionViewDataSource {
  
  func collectionView(collectionView: UICollectionView,
                      numberOfItemsInSection section: Int) -> Int {
    return gamesInfo.count
  }
  
  func collectionView(collectionView: UICollectionView,
                      cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Games Collection View Cell", forIndexPath: indexPath) as! PeaceCorpsMessageCollectionViewCell
    
    cell.postTitle.text = gamesInfo[indexPath.row].name
    
    return cell
  }
  
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
    let spacing = determineSpacing()
    return UIEdgeInsetsMake(0, spacing, 0, spacing)
  }
  
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
    return determineSpacing()
  }
  
  private func determineSpacing() -> CGFloat{
    let screenWidth = UIScreen.mainScreen().bounds.size.width
    let numberItems = min(floor(screenWidth/PeaceCorpsMessageCollectionViewCell.CellWidth), 4)
    let remainingScreen = screenWidth - numberItems*PeaceCorpsMessageCollectionViewCell.CellWidth
    
    return floor(remainingScreen/(numberItems - 1 + 2)) //left and right margin plus space between cells (numItems - 1)
  }
}

// MARK: Collection View Delegate.

extension GamesListViewController: UICollectionViewDelegate {
  
  func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    performSegueWithIdentifier("Show Game Rules", sender: indexPath.row)
  }
}

// MARK: Presents Modality Delegate.

// We need to respect this protocol in order to support the Settings button.

extension GamesListViewController: PresentsModalityDelegate {
  func onDismiss() { }
}