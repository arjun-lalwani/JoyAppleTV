//
//  ViewController.swift
//  Joy
//
//  Created by Arjun Lalwani on 8/25/17.
//  Copyright © 2017 Arjun Lalwani. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITextFieldDelegate {
    
    @IBOutlet weak var eventsCollectionView: UICollectionView!
    @IBOutlet weak var abc: UIImageView!
    
    static var temporaryImages = [UIImage(named: "Event Image")]
    
    let events = AllEvents.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        eventsCollectionView.delegate = self
        eventsCollectionView.dataSource = self
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ViewController.temporaryImages.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        tif indexPath.row < ViewController.temporaryImages.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "eventCell", for: indexPath) as! CurrentEventCollectionViewCell
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "newEventCell", for: indexPath) as! NewEventCollectionViewCell
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(25)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row < ViewController.temporaryImages.count {
            openSelectedEvent()
        } else {
            addNewEvent()
        }
    }
    
    func openSelectedEvent() {
        self.performSegue(withIdentifier: "joinEventSegue", sender: nil)
    }
    
    func addNewEvent() {
        let alert = UIAlertController(title: "Join Event", message: "Enter the event code you recieved from the host to join an event", preferredStyle: .alert)
        
        var eventCodeTextField : UITextField?
        
        alert.addTextField(configurationHandler: {(textField: UITextField!) in
            textField.placeholder = "Enter Code"
            eventCodeTextField = textField
        })
        
        let join = UIAlertAction(title: "Join", style: .default, handler: {(alert: UIAlertAction!) in
            
            let codeEntered = eventCodeTextField!.text!
            
            if AddEventModel.verifyEventCode(codeEntered) {
                self.performSegue(withIdentifier: "joinEventSegue", sender: nil)
//                ViewController.temporaryImages.append(UIImage(named: "Event Image"))
                MomentsAPI.verifyEventCode("doesn't matter what you put", completion: {() -> Void in
                    // async call after completing requests
                    self.eventsCollectionView.reloadData()
                }, imagez: self.abc)
//                self.eventsCollectionView.reloadData()
            } else {
            
                let alert = UIAlertController(title: "Invalid Code", message: "The code entered doesn't seem to match any events", preferredStyle: .alert)
                alert.addAction(AlertActions.cancel)
                self.present(alert, animated: true, completion: nil)
            }
        })
        
        alert.addAction(join)
        alert.addAction(AlertActions.cancel)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
}

