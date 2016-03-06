import Foundation
import UIKit


class PostDetailedViewController : UIViewController{
    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var postDescription: UITextView!
    
    var postsArray: [Post] = []
    var currentIndex: NSInteger = 0
    
    var post: Post!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        postDescription.clipsToBounds = true
        
        var leftSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        var rightSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        
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
        if (sender.direction == .Left) {
            print("Swipe Left")
            if (currentIndex < postsArray.count-1){
                currentIndex++
                reloadView()
                
                
            }
            
            
        }
        
        if (sender.direction == .Right) {
            print("Swipe Right")
            if (currentIndex > 0){
                currentIndex--
                reloadView()
                
            }
            
        }
    }
    
    func reloadView(){
        
        
        postTitle.text = postsArray[currentIndex].title
        postDescription.text = postsArray[currentIndex].post_description
        
        postDescription.scrollRangeToVisible(NSMakeRange(0, 0))
        
        
    }
    
    @IBAction func goBackBtnHandler(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}