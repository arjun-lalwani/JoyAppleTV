//
//  CurrentEventCollectionViewCell.swift
//  Joy
//
//  Created by Arjun Lalwani on 9/5/17.
//  Copyright © 2017 Arjun Lalwani. All rights reserved.
//

import UIKit 

//class Api {
//    getEventJson(code: String, callback: (json: Dictionary) -> Void) -> Void {
//        //sksjdflksjdlfkj
//    
//        callback("sdfsdfsd");
//    }
//}
class CurrentEventCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Add event Image 
        // Add name of couple
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override var canBecomeFocused: Bool {
        return true
    }
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        super.didUpdateFocus(in: context, with: coordinator)
        
        if context.nextFocusedView == self {
            coordinator.addCoordinatedAnimations({ () -> Void in
                self.nameLabel.center.y += (self.eventImage.center.y - self.nameLabel.center.y)
            
            }, completion: nil)
        } else if context.previouslyFocusedView == self {
            coordinator.addCoordinatedAnimations({() -> Void in
                self.nameLabel.center.y += 120
            }, completion: nil)
        }
    }
    

}
