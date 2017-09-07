//
//  PresentPhotoViewController.swift
//  Joy
//
//  Created by Arjun Lalwani on 8/29/17.
//  Copyright © 2017 Arjun Lalwani. All rights reserved.
//

import UIKit

class PresentPhotoViewController: UIViewController {

    @IBOutlet weak var eventImage: UIImageView!
    var modelIndex: Int!
    var currentEvent: Event!
    var currentEventMoments: [UIImage]!

    //var temporaryIamges = [UIImage(named: "Event Image"), UIImage(named: "img1"), UIImage(named: "img2"), UIImage(named: "img3"), UIImage(named: "img4"), UIImage(named: "img5"), UIImage(named: "img6"), UIImage(named: "img7"), UIImage(named: "img8"), UIImage(named: "img9"), UIImage(named: "img10"), UIImage(named: "img11"), UIImage(named: "img12")]
    
    var imagesToDisplay: [UIImage]!
    
    let animationDuration: TimeInterval = 0.60
    let switchingInterval: TimeInterval = 2.5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentEventMoments = currentEvent.moments
        setImagesToDisplay()
        animateImageView()
    }
    
    func setImagesToDisplay() {
        let imagesFromSelectedIndex = Array(currentEventMoments[modelIndex..<(currentEventMoments.count)])
        let imagesBeforeSelectedIndex = Array(currentEventMoments[0..<modelIndex])
        imagesToDisplay = imagesFromSelectedIndex + imagesBeforeSelectedIndex
        modelIndex = 0;
    }
    
    func animateImageView() {
        CATransaction.begin()
        
        CATransaction.setAnimationDuration(animationDuration)
        CATransaction.setCompletionBlock {
            DispatchQueue.main.asyncAfter(deadline: .now() + self.switchingInterval) {
                self.animateImageView()
            }
        }
        
        let transition = CATransition()
        transition.type = kCATransitionFade
        transition.subtype = kCATransitionMoveIn
        eventImage.layer.add(transition, forKey: kCATransition)
        eventImage.image = (imagesToDisplay[modelIndex!])
        
        CATransaction.commit()
        modelIndex = (modelIndex + 1) % imagesToDisplay.count;
    }
}
