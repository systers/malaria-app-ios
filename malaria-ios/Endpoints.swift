import Foundation

enum Endpoints : String{
    case BaseUrl = "http://pc-web-dev.systers.org/"
    
    case Api = "api"
    case Posts = "posts"
    case Revposts = "revposts"
    case Regions = "regions"
    case Sectors = "ectors"
    case Ptposts = "ptposts"
    case Projects = "projects"
    case Volunteer = "volunteer"
    case Cohort = "cohort"
    case Measurement = "measurement"
    case Activity = "activity"
    case Outcomes = "outcomes"
    case Outputs = "outputs"
    case Indicators = "indicators"
    case Objectives = "objectives"
    case Goals = "goals"
    
    func path() -> String{
        
        if (self == Endpoints.Api){
            return self.rawValue
        }
        
        // eg. BaseUrl/api/posts
        return "\(Endpoints.Api.rawValue)/\(self.rawValue)"
    }
}