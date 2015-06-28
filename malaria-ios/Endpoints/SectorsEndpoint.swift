import Foundation
import UIKit
import SwiftyJSON

class SectorsEndpoint : Endpoint{
    override var path: String { get { return EndpointType.Sectors.path() } }
    
    override func retrieveJSONObject(data: JSON) -> NSManagedObject?{
        if let results = data["results"].array{
            let sectors = Sectors.create(Sectors.self)
            
            if results.count == 0{
                return sectors
            }
            
            if let posts = getSectors(results){
                sectors.sectors.addObjectsFromArray(posts)
                return sectors
            }else{
                Logger.Error("Error parsing results")
            }
        }
        
        return nil
    }
    
    /// Parses sectors
    ///
    /// If parse fails at any instance, it will be return nil
    /// Every intermediary object created will be deleted
    ///
    /// :param: `[JSON]`: array of sectors to be parsed
    /// :returns: `[Post]`: array of sectors or nil if parse failed
    func getSectors(data: [JSON]) -> [Sector]?{
        var result: [Sector] = []
        
        for json in data{
            if  let name = json["sector_name"].string,
                let desc = json["sector_desc"].string,
                let code = json["sector_code"].string,
                let id = json["id"].int64{
                    
                    let sector = Sector.create(Sector.self)
                    sector.name = name
                    sector.desc = desc
                    sector.code = code
                    sector.id = id
                    
                    result.append(sector)
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
        Sectors.clear(Sectors.self)
    }
}