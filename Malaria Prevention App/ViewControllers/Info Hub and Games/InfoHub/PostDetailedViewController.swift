import UIKit

class PostDetailedViewController : UIViewController {
    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var postDescription: UITextView!
  
    var postsArray: [Post] = []
    var currentIndex = 0
    var post: Post!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        postDescription.clipsToBounds = true
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes))
        leftSwipe.direction = .Left
        rightSwipe.direction = .Right
        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(rightSwipe)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        postTitle.text = post.title
        postDescription.text = post.post_description
        postDescription.scrollRangeToVisible(NSMakeRange(0, 0))
    }
    
    func handleSwipes(sender:UISwipeGestureRecognizer) {
        if (sender.direction == .Left && currentIndex < postsArray.count-1) {
            currentIndex += 1
            reloadView()
        }
        if (sender.direction == .Right && currentIndex > 0) {
            currentIndex -= 1
            reloadView()
        }
    }
    
    func reloadView() {
        postTitle.text = postsArray[currentIndex].title
        postDescription.text = postsArray[currentIndex].post_description
        postDescription.scrollRangeToVisible(NSMakeRange(0, 0))
        
    }
    
    @IBAction func goBackBtnHandler(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}