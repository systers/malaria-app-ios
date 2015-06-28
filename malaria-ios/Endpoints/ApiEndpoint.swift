import Foundation
import UIKit
import SwiftyJSON

class ApiEndpoint : Endpoint{
    override var path: String { get { return EndpointType.Api.path() } }
    
    override func retrieveJSONObject(data: JSON) -> NSManagedObject?{
        if  let users = data["users"].string,
            let posts = data["posts"].string,
            let revposts = data["revposts"].string,
            let regions = data["regions"].string,
            let sectors = data["sectors"].string,
            let ptposts = data["ptposts"].string,
            let projects = data["projects"].string,
            let goals = data["goals"].string,
            let objectives = data["objectives"].string,
            let indicators = data["indicators"].string,
            let outputs = data["outputs"].string,
            let outcomes = data["outcomes"].string,
            let activity = data["activity"].string,
            let measurement = data["measurement"].string,
            let cohort = data["cohort"].string,
            let volunteer = data["volunteer"].string{
                
                
                let api = Api.create(Api.self)
                api.users = users
                api.posts = posts
                api.revposts = revposts
                api.regions = regions
                api.sectors = sectors
                api.ptposts = ptposts
                api.projects = projects
                api.goals = goals
                api.outcomes = outcomes
                api.objectives = objectives
                api.indicators = indicators
                api.outputs = outputs
                api.activity = activity
                api.measurement = measurement
                api.cohort = cohort
                api.volunteer = volunteer
                
                return api
        }
        
        return nil
    }
    
    override func clearFromDatabase(){
        Api.clear(Api.self)
    }

}