import UIKit

class GamesViewController: UIViewController {
  @IBOutlet weak var collectionView: UICollectionView!
  
  private var games: [Game] = [RapidFireGame()]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "Show Rapid Fire" {
      let gameVC = segue.destinationViewController as! RapidFireViewController
      gameVC.rapidFireGame = games[0] as? RapidFireGame
    }
  }
}

extension GamesViewController: UICollectionViewDataSource {
  
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

extension GamesViewController: UICollectionViewDelegate {
  
  func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    switch indexPath.row {
    case 0: fallthrough
    default: performSegueWithIdentifier("Show Rapid Fire", sender: self)
    }
  }
}