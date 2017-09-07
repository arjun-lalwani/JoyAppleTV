//
//  EventsModel.swift
//  Joy
//
//  Created by Arjun Lalwani on 9/5/17.
//  Copyright © 2017 Arjun Lalwani. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import Alamofire
import AlamofireImage
import PromiseKit

class Event {
    
    private var _json: JSON
    private var url: String
    private var sasCode: String
    
    var moments: [UIImage]!
    
    var primaryImageHorizontal: UIImage!
    
    // THERE SHOULD BE 2 JSONs PASSED HERE
    // ONE for event info
    // TWO for moments
    init(json: JSON) {
        self._json = json
        self.url = _json["assetConnection"]["azure"]["url"].string!
        self.sasCode = _json["assetConnection"]["azure"]["sas"].string!
        
        populateEventPrimaryImage()
        populateMoments()
    }

    var eventName: String? {
        let ownerName = _json["database"]["info"]["owner"].string!
        let fianceeName = _json["database"]["info"]["fiancee"].string!
        
        return "\(ownerName) & \(fianceeName)"
    }
    
    var eventId: String? {
        let eventId = _json["database"]["eventId"].string!
        return eventId
    }

    func populateEventPrimaryImage() {
        let primaryPhoto = _json["database"]["info"]["primaryPhotoHorizontal"]["assetId"].string!
        let downloadURL = "\(url)/\(primaryPhoto)?\(sasCode)"
        
        Alamofire.request(downloadURL).responseImage { response in
            self.primaryImageHorizontal = response.result.value!
        }
    }
    
    func populateMoments() {
        let subJson = _json["channels"]["messages"].dictionary!

        for (_, momentsJson):(String, JSON) in subJson {
            let momentImage = momentsJson["asset"]["assetId"].string!
            let downloadURL = "\(url)/\(momentImage)?\(sasCode)"
            Alamofire.request(downloadURL).responseImage { response in
                self.moments.append(response.result.value!)
            }
        }
    }
}


final class AllEvents {
    
    static var shared = AllEvents()
    
    private var events = [Event]()
    
    // PROMISES Play and figure out
    func addNewEvent(_ accessCode: String) -> Promise<Any> {
        
        return Promise { fulfill, reject in
            Alamofire.request("https://dev-api.withjoy.com/events/e88d7f71eb8b2c688c3266b7df9b946adefd4e2b965e406fd/publicInfo").validate().responseJSON { response in
                switch response.result {
                case .success:
                    print("example success")
                case .failure(let error):
                    reject(error)
                }
                
                if let json = response.result.value {
                    self.events.append(Event(json: (json as! JSON)))
                    fulfill(Any)
                }
            }
        }
    }
    
    func removeEventAt(index: Int) {
        events.remove(at: index)
    }
    
    func getAllEvents() -> [Event] {
        let eventsCopy = events
        return eventsCopy
    }
    
    func getEvent(eventId: String) -> Event? {
        for event in events {
            if event.eventId == eventId {
                return event
            }
        }
        return nil
    }
}
