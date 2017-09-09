//
//  PhotosViewController.swift
//  Joy
//
//  Created by Arjun Lalwani on 8/29/17.
//  Copyright © 2017 Arjun Lalwani. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: Outlets
    @IBOutlet weak var photosCollectionView: UICollectionView!
    
    // FIXME: Remove temporary images
    var temporaryIamges = [UIImage(named: "Event Image"), UIImage(named: "img1"), UIImage(named: "img2"), UIImage(named: "img3"), UIImage(named: "img4"), UIImage(named: "img5"), UIImage(named: "img6"), UIImage(named: "img7"), UIImage(named: "img8"), UIImage(named: "img9"), UIImage(named: "img10"), UIImage(named: "img11"), UIImage(named: "img12")]

    // MARK: Properties
    var selectedEventIndex: Int!
    var selectedEventInfo: EventInfo!
    
    private var eventAssets: [Asset]! // POPULATE THIS IN VIEW WILL APPEAR
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        photosCollectionView.dataSource = self
        photosCollectionView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // FIXME: Add below code
        // eventAssets = selectedEventInfo.getEventAssets
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // FIXME: replace with - eventAssets.count
        return temporaryIamges.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = photosCollectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! MomentsCollectionViewCell
        
        // FIXME: replace with - eventAssets[indexPath.row].getImage()
        if let image = temporaryIamges[indexPath.row] {
            cell.momentsImage.image = image
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(60)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedEventIndex = indexPath.row
        self.performSegue(withIdentifier: "presentPhotoSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "presentPhotoSegue" {
            let presentPhotoVC = segue.destination as! PresentPhotoViewController
            presentPhotoVC.modelIndex = selectedEventIndex
            // FIXME: Add below code
            // presentPhotoVC.eventAssets = eventAssets
        }
    }
}
