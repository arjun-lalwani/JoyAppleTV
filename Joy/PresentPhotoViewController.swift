//
//  PresentPhotoViewController.swift
//  Joy
//
//  Created by Arjun Lalwani on 8/29/17.
//  Copyright © 2017 Arjun Lalwani. All rights reserved.
//

import UIKit

class PresentPhotoViewController: UIViewController {

    // FIXME: Remove temporaryImages
    var temporaryImages = [UIImage(named: "Event Image"), UIImage(named: "img1"), UIImage(named: "img2"), UIImage(named: "img3"), UIImage(named: "img4"), UIImage(named: "img5"), UIImage(named: "img6"), UIImage(named: "img7"), UIImage(named: "img8"), UIImage(named: "img9"), UIImage(named: "img10"), UIImage(named: "img11"), UIImage(named: "img12")]
    
    @IBOutlet weak var eventImage: UIImageView!
    
    var modelIndex: Int!
    
    // FIXME:  Add below code
    // var eventAssets: [Asset]!

    var imagesToDisplay: [UIImage]!
    
    let animationDuration: TimeInterval = 0.60
    let switchingInterval: TimeInterval = 2.5
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setImagesToDisplay()
        animateImageView()
    }
    
    func setImagesToDisplay() {
        // FIXME: replace below code with -
        /* 
             let imagesFromSelectedIndex = Array(eventAssets[modelIndex..<(temporaryImages.count)]) as! [Asset]
             let imagesBeforeSelectedIndex = Array(eventAssets[0..<modelIndex]) as! [Asset]
             let AssetsToDisplay = Array(imagesFromSelectedIndex + imagesBeforeSelectedIndex)
             for asset in AssetsToDisplay {
                imagesToDisplay.append(asset.getImage())
             }
             modelIndex = 0
        */
        let imagesFromSelectedIndex = Array(temporaryImages[modelIndex..<(temporaryImages.count)]) as! [UIImage]
        let imagesBeforeSelectedIndex = Array(temporaryImages[0..<modelIndex]) as! [UIImage]
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
        eventImage.image = imagesToDisplay[modelIndex!]
        CATransaction.commit()
        modelIndex = (modelIndex + 1) % imagesToDisplay.count;
    }
}
