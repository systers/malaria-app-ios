import Foundation
import SwiftyJSON

class CollectionRevPostsEndpoint : Endpoint{
    /// subCollectionClassType: Specify the subclass of CollectionRevPosts
    var subCollectionsRevPostsType: CollectionRevPosts.Type { get { fatalError("Please specify collection type") } }
    
    override func retrieveJSONObject(data: JSON) -> NSManagedObject?{
        if let results = data["results"].array{
            let collectionRevPosts = subCollectionsRevPostsType.create(subCollectionsRevPostsType.self)
            
            if results.count == 0{
                return collectionRevPosts
            }
            
            if let posts = getRevPosts(results){
                collectionRevPosts.rev_posts.addObjectsFromArray(posts)
                return collectionRevPosts
            }else{
                Logger.Error("Error parsing results")
            }
        }
        
        return nil
    }
    
    /// Parses RevPosts
    ///
    /// If parse fails at any instance, it will be return nil
    /// Every intermediary object created will be deleted
    ///
    /// :param: `[JSON]`: array of revPosts to be parsed
    /// :returns: `[RevPost]`: array of revPosts or nil if parse failed
    func getRevPosts(data: [JSON]) -> [RevPost]?{
        var result: [RevPost] = []
        
        for json in data{
            if  let owner_rev_post = json["owner_rev_post"].int64,
                let owner_rev = json["owner_rev"].int64,
                let title = json["title_post_rev"].string,
                let desc = json["description_post_rev"].string,
                let created = json["created"].string,
                let title_change = json["title_change"].bool,
                let description_change = json["description_change"].bool,
                let id = json["id"].int64{
                    
                    let post = RevPost.create(RevPost.self)
                    post.owner_post = owner_rev_post
                    post.owner = owner_rev
                    post.title = title
                    post.post_description = desc
                    post.created_at = created
                    post.title_change = title_change
                    post.description_change = description_change
                    post.id = id
                    
                    result.append(post)
            }else{
                Logger.Error("Error parsing post")
                
                //delete
                for r in result{
                    r.deleteFromContext()
                }
                
                return nil
            }
        }
        
        return result
    }
    
    override func clearFromDatabase(){
        subCollectionsRevPostsType.clear(subCollectionsRevPostsType.self)
    }
    
}