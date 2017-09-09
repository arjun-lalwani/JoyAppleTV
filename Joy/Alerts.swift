//
//  Alerts.swift
//  Joy
//
//  Created by Arjun Lalwani on 8/29/17.
//  Copyright © 2017 Arjun Lalwani. All rights reserved.
//

import Foundation
import UIKit

struct AlertActions {
    static let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
}


struct Alert {
    
    static var enterCode: UIAlertController {
        let alert = UIAlertController(title: "Enter Code", message: "You need to enter a code to join an event", preferredStyle: .alert)
        alert.addAction(AlertActions.cancel)
        return alert
    }
    
    static var showEventAlreadyExists: UIAlertController {
        let alert = UIAlertController(title: "Event is already added", message: "The event you're trying to access is already added", preferredStyle: .alert)
        alert.addAction(AlertActions.cancel)
        return alert
    }
    
    static var addEventError: UIAlertController {
        let alert = UIAlertController(title: "Invalid Code", message: "The code entered doesn't seem to match any events", preferredStyle: .alert)
        alert.addAction(AlertActions.cancel)
        return alert
    }
    
    static var showConnectionError: UIAlertController {
        let alert = UIAlertController(title: "Unable to retrieve events", message: "Please check your connection", preferredStyle: .alert)
        alert.addAction(AlertActions.cancel)
        return alert
    }

}
