import Foundation
import UIKit

class PostsEndpoint : Endpoint{
    override var entityName: String { get { return "Posts" } }
    override var path: String { get { return Endpoints.Posts.path() } }
    override var mapping: RKEntityMapping {
        get {
            
            let postAttrs = [
                "owner" : "owner",
                "title_post" : "title",
                "description_post" : "post_description",
                "created" : "created_at",
                "updated" : "updated_at",
                "id" : "id"
            ]
            let postMapping = RKEntityMapping.mapAtributesAndRelationships("Post", attributes: postAttrs)
            
            let postCollectionMapping = RKEntityMapping.mapAtributesAndRelationships("CollectionPosts", relationships: ["posts" : postMapping])
            
            return postCollectionMapping
        }}
}