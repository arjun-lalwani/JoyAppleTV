//
//  CurrentEventCollectionViewCell.swift
//  Joy
//
//  Created by Arjun Lalwani on 9/5/17.
//  Copyright © 2017 Arjun Lalwani. All rights reserved.
//

import UIKit 

class CurrentEventCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var eventName: UILabel!
    
    var eventInfo: EventInfo!
    
    override var canBecomeFocused: Bool {
        return true
    }
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        super.didUpdateFocus(in: context, with: coordinator)
        
        if context.nextFocusedView == self {
            coordinator.addCoordinatedAnimations({ () -> Void in
                self.eventName.center.y += (self.eventImage.center.y - self.eventName.center.y)
            
            }, completion: nil)
        } else if context.previouslyFocusedView == self {
            coordinator.addCoordinatedAnimations({() -> Void in
                self.eventName.center.y += 120
            }, completion: nil)
        }
    }
    

}
