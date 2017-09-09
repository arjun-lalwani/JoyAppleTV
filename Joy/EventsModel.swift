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

final class AllEvents {
    
    static var shared = AllEvents()
    
    private var eventCodes = [EventCode]()
    
    /*
        Adds new access code to list of event codes 
     
        - Parameter accessCode: Access code to enter event
        - Returns Promise<EventCode>: Promise that contains Event Code instance to make connections
    */
    func addNewEvent(_ accessCode: String) -> Promise<EventCode> {
        
        return Promise { fulfill, reject in
        
            let permitParameters: Parameters = [
                "type": "eventSecret",
                "eventSecret": accessCode,
                "level": "member"
            ]
            
            // post request to recive json that contains token_type and id_token
            Alamofire.request("https://dev-api.withjoy.com/permits?type=events", method: .post, parameters: permitParameters, encoding: JSONEncoding.default).validate().responseJSON { response in
                
                if response.result.isSuccess {
                    let json = JSON(response.result.value!)
                    let value = "\(json["token_type"]) \(json["id_token"])"
                    let eventParameters: HTTPHeaders = [
                        "Authorization": value
                    ]
                    
                    // get request to recieve json that contains public info of event
                    Alamofire.request("https://dev-api.withjoy.com/events", headers: eventParameters).validate(statusCode: 200...409).responseJSON { response in
                        if response.result.isSuccess {
                            let eventCode = EventCode(code: accessCode)
                            self.eventCodes.append(eventCode)
                            fulfill(eventCode)
                        } else {
                            reject(response.result.error!)
                        }
                    }
                } else {
                    reject(response.result.error!)
                }
            }
        }
    }
    
    
    func removeEventAt(index: Int) {
        eventCodes.remove(at: index)
    }
    
    func getAllEvents() -> [EventCode] {
        let eventsCopy = eventCodes
        
        return eventsCopy
    }
    
    func getEvent(eventCode: String) -> EventCode? {
        for event in eventCodes {
            if event.code == eventCode {
                return event
            }
        }
        return nil
    }
}

struct EventCode {
    let code: String
    
    
    /*
       Establishes a connection to recieve event information for shared access codes
     
     - Returns Promise<EventConnection>: Promise that contains Event Connection to get event info and assets
     
     */
    func makeConnection() -> Promise<EventConnection> {
        return Promise { fulfill, reject in
            
            let permitParameters: Parameters = [
                "type": "eventSecret",
                "eventSecret": code,
                "level": "member"
            ]
            
            Alamofire.request("https://dev-api.withjoy.com/permits?type=events", method: .post, parameters: permitParameters, encoding: JSONEncoding.default).validate().responseJSON { response in
                
                if response.result.isSuccess {
                    let json = JSON(response.result.value!)
                    let value = "\(json["token_type"]) \(json["id_token"])"
                    let eventParameters: HTTPHeaders = [
                        "Authorization": value
                    ]
                    
                    Alamofire.request("https://dev-api.withjoy.com/events", headers: eventParameters).validate(statusCode: 200...409).responseJSON { response in
                        if response.result.isSuccess {
                            let eventConnection = EventConnection(JSON(response.result.value!))
                            fulfill(eventConnection)
                        } else {
                            reject(response.result.error!)
                        }
                    }
                } else {
                    reject(response.result.error!)
                }
            }
        }
    }
}

class EventConnection {
    
    private var _json: JSON
    private var url: String
    private var sasCode: String
    
    var eventInfo: EventInfo
    
    init(_ json: JSON) {
        self._json = json["events"][0]
        self.url = _json["assetConnection"]["azure"]["url"].string!
        self.sasCode = _json["assetConnection"]["azure"]["sas"].string!
        
        self.eventInfo = EventInfo(url: self.url, sasCode: self.sasCode, publicJson: _json)
    }
}

class EventInfo {
    
    private var url: String
    private var sasCode: String
    private var _publicJson: JSON

    var primaryPhoto: Asset {
        let subJson = _publicJson["info"]["primaryPhotoHorizontal"]
        return Asset(subJson, url: self.url, sasCode: self.sasCode)
    }
    
    var eventName: String {
        let ownerName = _publicJson["info"]["owner"].string!
        let fianceeName = _publicJson["info"]["fiancee"].string!
        
        return "\(ownerName) & \(fianceeName)"
    }
    
    init(url: String, sasCode: String, publicJson: JSON) {
        self.url = url
        self.sasCode = sasCode
        self._publicJson = publicJson
    }
    
    /*
       Makes a request to get all Assets for requested Event
     
     - Returns Promise<Asset>: Promise that contains all Event Assets that includes images
     
     */
    func getEventAssets() -> Promise<[Asset]> {
        // FIXME: Provide the right firebase link below
        let firebaseDatabaseLink = "Provide accurate firebase link...."
        
        return Promise { fulfill, reject in
            
            Alamofire.request(firebaseDatabaseLink).responseJSON { response in
                if response.result.isSuccess {
                    let _fbJson = JSON(response.result.value!)
                    let subJson = _fbJson["database"]["channels"]["messages"]
                    var eventAssets = [Asset]()
                    
                    for (_, subJson):(String, JSON) in subJson {
                        let newAsset = Asset(subJson["asset"], url: self.url, sasCode: self.sasCode)
                        eventAssets.append(newAsset)
                    }
                    fulfill(eventAssets)
                } else {
                    reject(response.result.error!)
                }
            }
        }
    }
}

class Asset {
    
    let subJson: JSON
    
    var assetId: String {
       return subJson["assetId"].string!
    }
    
    var mimeType: String {
        return subJson["mimetype"].string!
    }
    
    var height: Int {
        return subJson["height"].int!
    }
    
    var width: Int {
        return subJson["width"].int!
    }
    
    var size: Int {
        return subJson["size"].int!
    }

    private var url: String
    private var sasCode: String
    
    init(_ subJson: JSON, url: String, sasCode: String) {
        self.subJson = subJson
        self.url = url
        self.sasCode = sasCode
    }
    
    /*
       Makes a request to get the image of particular asset
     
     - Returns Promise<UIImage>: Promise that contains UIImage for requested Asset
     
     */
    func getImage() -> Promise<UIImage> {
        return Promise { fulfill, reject in
            let downloadUrl = "\(url)/\(assetId)?\(sasCode)"
            Alamofire.request(downloadUrl).validate().responseImage { response in
                // FIXME: Handle error case below
                fulfill(response.result.value!)
            }
        }
    }
}
