import UIKit

class GamesListViewController: UIViewController {
  @IBOutlet weak var collectionView: UICollectionView!
  
  // New games are added just by creating them and adding an instance to this array
  private var games: [Game] = [RapidFireGame()]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    let gameCellIndex: Int = sender as! Int
    
    let gameRulesVC = segue.destinationViewController as! GameRulesViewController
    gameRulesVC.game = games[gameCellIndex]
  }
}

extension GamesListViewController: UICollectionViewDataSource {
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return games.count
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Games Collection View Cell", forIndexPath: indexPath) as! PeaceCorpsMessageCollectionViewCell
    
    cell.postTitle.text = games[indexPath.row].name
    
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

extension GamesListViewController: UICollectionViewDelegate {
  
  func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    performSegueWithIdentifier("Show Game Rules", sender: indexPath.row)
  }
}