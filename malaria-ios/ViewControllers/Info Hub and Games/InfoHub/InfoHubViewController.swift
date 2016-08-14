import Foundation
import UIKit

class InfoHubViewController : UIViewController{
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let refreshControl = UIRefreshControl()
    
    private var viewContext = CoreDataHelper.sharedInstance.createBackgroundContext()!
    private var syncManager: SyncManager!
    private var posts: [Post] = []
    
    private var currentRow = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
                syncManager = SyncManager(context: viewContext)
        
        view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        
        refreshControl.tintColor = UIColor(hex: 0xE46D71)
        refreshControl.backgroundColor = UIColor.clearColor()
        refreshControl.addTarget(self, action: #selector(pullRefreshHandler), forControlEvents: UIControlEvents.ValueChanged)
        
        collectionView.addSubview(refreshControl)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        refreshScreen()
    }
    internal func pullRefreshHandler(){
        Logger.Info("Pull refresh")
        syncManager.sync(EndpointType.Posts.path(), save: true, completionHandler: {(url: String, error: NSError?) in
            if let e = error {
                self.presentViewController(self.createAlertViewError(e), animated: true, completion: nil)
            }else {
                self.refreshFromCoreData()
            }
            
            self.refreshControl.endRefreshing()
        })
    }
  
    var pagesManager: InfoHubPageManagerViewController!
    override func viewDidAppear(animated: Bool) {
      super.viewDidAppear(animated)
      pagesManager.currentViewController = self
    }
  
    private func refreshScreen() {
        func completionHandler(url: String, error: NSError?){
            if error != nil{
                delay(0.5){
                    let (title, message) = (self.NoInformationAvailableAlertText.title, self.NoInformationAvailableAlertText.message)
                    let confirmAlert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
                    confirmAlert.addAction(UIAlertAction(title: self.AlertOptions.ok, style: .Default, handler: nil))
                    
                    self.presentViewController(confirmAlert, animated: true, completion: nil)
                }
                
            } else {
                self.refreshFromCoreData()
            }
        }
        
        if !refreshFromCoreData(){
            syncManager.sync(EndpointType.Posts.path(), save: true, completionHandler: completionHandler)
        }
    }
    private func createAlertViewError(error : NSError) -> UIAlertController {
        let (title, message) = (CantUpdateFromPeaceCorpsAlertText.title, CantUpdateFromPeaceCorpsAlertText.message)
        let refreshAlert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        if error.code == -1009 {
            refreshAlert.message = NoInternetConnectionAlertText.message
            refreshAlert.addAction(UIAlertAction(title: AlertOptions.settings, style: .Default, handler: { _ in
                UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
            }))
        }
        
        refreshAlert.addAction(UIAlertAction(title: AlertOptions.ok, style: .Default, handler: nil))
        return refreshAlert
    }
    
    private func refreshFromCoreData() -> Bool{
        Logger.Info("Fetching from coreData")
        if let newPosts = Posts.retrieve(Posts.self, context: viewContext).first {
            posts = newPosts.posts.convertToArray().sort({$0.title < $1.title})
            collectionView.reloadData()
            return true
        }
        
        return false
    }
    
    @IBAction func settingsBtnHandler(sender: AnyObject) {
        //fix delay
        dispatch_async(dispatch_get_main_queue()) {
            let view = UIStoryboard.instantiate(SetupScreenPillPage.self)
            self.presentViewController(view, animated: true, completion: nil)
        }
    }
}

// MARK: PresentsModalityDelegate

extension InfoHubViewController: PresentsModalityDelegate {

  func onDismiss() {
    refreshScreen()
  }
}

extension InfoHubViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let post = posts[indexPath.row]
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("postCollectionCell", forIndexPath: indexPath) as! PeaceCorpsMessageCollectionViewCell
        
        cell.postTitle.text = post.title
        
        return cell
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath){
        let postView = UIStoryboard.instantiate(PostDetailedViewController.self, fromStoryboard: Constants.Storyboards.InfoHub)
        postView.post = posts[indexPath.row]
        
        postView.currentIndex = indexPath.row
        
        postView.postsArray = posts
        currentRow = indexPath.row
        
        dispatch_async(dispatch_get_main_queue()) {
            self.presentViewController(postView, animated: true, completion: nil)
        }
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

//alert messages
extension InfoHubViewController {
    typealias AlertText = (title: String, message: String)
    
    private var NoInformationAvailableAlertText: AlertText {get {
        return ("No available message from Peace Corps", "")
        }}
    
    private var CantUpdateFromPeaceCorpsAlertText: AlertText {get {
        return ("Couldn't update Peace Corps messages", "Please try again later")
        }}
    
    private var NoInternetConnectionAlertText: AlertText {get {
        return ("Couldn't update Peace Corps messages", "No available internet connection. Please try again later")
        }}
    
    //type of alerts options
    private var AlertOptions: (ok: String, cancel: String, settings: String) {get {
        return ("ok", "Cancel", "Settings")
        }}
    
}

class PeaceCorpsMessageCollectionViewCell : UICollectionViewCell{
    @IBOutlet weak var postTitle: UILabel!
    static let CellWidth: CGFloat = 140
}