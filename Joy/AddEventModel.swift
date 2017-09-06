//
//  AddEventModel.swift
//  Joy
//
//  Created by Arjun Lalwani on 8/29/17.
//  Copyright © 2017 Arjun Lalwani. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage
import SwiftyJSON

struct AddEventModel {
    
    static func verifyEventCode(_ code: String) -> Bool {
        if code == "abc" {
            return true
        } else {
            return false
        }
    }
}

class MomentsAPI {
    
    static func verifyEventCode(_ code: String, completion: @escaping () -> Void, imagez: UIImageView) {
        
        // FIXME: Verify code here. Currently hard coded code is passed in.
        Alamofire.request("https://dev-api.withjoy.com/events/e88d7f71eb8b2c688c3266b7df9b946adefd4e2b965e406fd/publicInfo").responseJSON { response in
            if let status = response.response?.statusCode {
                switch status {
                case 200, 201:
                    print("example success")
                default:
                    print("error with resonpse status: \(status)")
                }
            }
            
            if let json = response.result.value {
                let json = JSON(json)
                
                print("JSON: \(json)")
                
                let url = json["assetConnection"]["azure"]["url"].string!
                let sasCode = json["assetConnection"]["azure"]["sas"].string!
                let primaryPhoto = json["database"]["info"]["primaryPhoto"]["assetId"].string!
                
                let downloadURL = "\(url)/\(primaryPhoto)?\(sasCode)"
                print(downloadURL)
                
                Alamofire.request(downloadURL).responseImage{ response in
                    guard let image = response.result.value else {
                        return
                    }
                    ViewController.temporaryImages.append(image)
                    print(image)
                    imagez.image = image
                    completion()
                }
            }
        }
    }
}
