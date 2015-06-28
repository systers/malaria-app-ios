import Foundation
import SwiftyJSON

class CollectionPostsEndpoint : Endpoint{
    /// subCollectionClassType: Specify the subclass of CollectionPosts
    var subCollectionsPostsType: CollectionPosts.Type { get { fatalError("Please specify collection type") } }
    
    override func retrieveJSONObject(data: JSON) -> NSManagedObject?{
        if let results = data["results"].array{
            let collectionPosts = subCollectionsPostsType.create(subCollectionsPostsType.self)
            
            if results.count == 0{
                return collectionPosts
            }
            
            if let posts = getPosts(results){
                collectionPosts.posts.addObjectsFromArray(posts)
                return collectionPosts
            }else{
                Logger.Error("Error parsing results")
            }
        }
        
        return nil
    }
    
    /// Parses posts
    ///
    /// If parse fails at any instance, it will be return nil
    /// Every intermediary object created will be deleted
    ///
    /// :param: `[JSON]`: array of posts to be parsed
    /// :returns: `[Post]`: array of posts or nil if parse failed
    func getPosts(data: [JSON]) -> [Post]?{
        var result: [Post] = []
        
        for json in data{
            if  let owner = json["owner"].int64,
                let title = json["title_post"].string,
                let desc = json["description_post"].string,
                let created = json["created"].string,
                let updated = json["updated"].string,
                let id = json["id"].int64{
                    
                    let post = Post.create(Post.self)
                    
                    post.owner = owner
                    post.title = title
                    post.post_description = desc
                    post.created_at = created
                    post.updated_at = updated
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
        subCollectionsPostsType.clear(subCollectionsPostsType.self)
    }
    
}