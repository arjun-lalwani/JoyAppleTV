//
//  EventsModel.swift
//  Joy
//
//  Created by Arjun Lalwani on 9/5/17.
//  Copyright © 2017 Arjun Lalwani. All rights reserved.
//

import Foundation
import UIKit

struct Event {
    
    var eventPrimaryImage: UIImage
    var eventName: String
    var momentsCollection: [UIImage]
    
    init(image: UIImage, name: String, moments: [UIImage]) {
        self.eventPrimaryImage = image
        self.eventName = name
        self.momentsCollection = moments
    }
}


final class AllEvents {
    
    static var shared = AllEvents()
    
    private var events = [Event]()
    
    func addNewEvent(_ event: Event) {
        events.append(event)
    }
    
    func removeEventAt(index: Int) {
        events.remove(at: index)
    }
    
    func getAllEvents() -> [Event] {
        let eventsCopy = events
        return eventsCopy
    }
}
