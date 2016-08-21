import Foundation

/**
 Possible endpoints for InfoHub.
 
 - `BaseUrl`: Base url
 
 - `Api`
 - `Posts`
 - `Revposts`
 - `Regions`
 - `Sectors`
 - `Ptposts`
 - `Projects`
 - `Volunteer`
 - `Cohort`
 - `Measurement`
 - `Activity`
 - `Outcomes`
 - `Outputs`
 - `Indicators`
 - `Objectives`
 - `Goals`
 */

enum EndpointType: String {
  
  #if DEBUG
  case BaseUrl = "https://systerspcweb.herokuapp.com/"
  #else
  case BaseUrl = "https://pc-web-dev.systers.org/"
  #endif
  
  case Api = "api"
  case Posts = "malaria_posts/"
  case Revposts = "revposts"
  case Regions = "regions"
  case Sectors = "sectors"
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
  case RapidFireQuestions = "rf-questions"
  case MVFStatements = "mvf-statements"
  
  /**
   Returns the full path to the endpoint.
   
   - returns: If BaseUrl returns, the BaseUrl, fthe fullpath otherwise.
   */
  
  func path() -> String {
    if self == BaseUrl {
      return self.rawValue
    } else if self == Api {
      return BaseUrl.rawValue + Api.rawValue
    }
    
    return BaseUrl.rawValue + Api.rawValue + "/" + self.rawValue
  }
}