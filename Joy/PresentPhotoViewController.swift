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


    var temporaryIamges = [UIImage(named: "Event Image"), UIImage(named: "img1"), UIImage(named: "img2"), UIImage(named: "img3"), UIImage(named: "img4"), UIImage(named: "img5"), UIImage(named: "img6"), UIImage(named: "img7"), UIImage(named: "img8"), UIImage(named: "img9"), UIImage(named: "img10"), UIImage(named: "img11"), UIImage(named: "img12")]
    
    var imagesToDisplay: [UIImage]!
    
    let animationDuration: TimeInterval = 0.60
    let switchingInterval: TimeInterval = 2.5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setImagesToDisplay()
        animateImageView()
    }
    
    func setImagesToDisplay() {
        let imagesFromSelectedIndex = Array(temporaryIamges[modelIndex..<temporaryIamges.count]) as! [UIImage]
        let imagesBeforeSelectedIndex = Array(temporaryIamges[0..<modelIndex]) as! [UIImage]
        imagesToDisplay = imagesFromSelectedIndex + imagesBeforeSelectedIndex
        modelIndex = 0;
        
        
//        imagesToDisplay = temporaryIamges;
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
        
        //modelIndex = modelIndex < temporaryIamges.count - 1 ? modelIndex + 1 : 0
        modelIndex = (modelIndex + 1) % imagesToDisplay.count;
    }
}
