//
//  ViewController.swift
//  Joy
//
//  Created by Arjun Lalwani on 8/25/17.
//  Copyright © 2017 Arjun Lalwani. All rights reserved.
//

import UIKit
import PromiseKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITextFieldDelegate {
    
    @IBOutlet weak var eventsCollectionView: UICollectionView!
    
    // static var temporaryImages = [UIImage(named: "Event Image")]
    
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
        return events.getAllEvents().count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row < events.getAllEvents().count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "eventCell", for: indexPath) as! CurrentEventCollectionViewCell
            
            let currentEvent = events.getAllEvents()[indexPath.row]
            cell.eventImage.image = currentEvent.primaryImageHorizontal
            cell.eventName.text = currentEvent.eventName
            
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
        if indexPath.row < events.getAllEvents().count {
            openSelectedEvent(index: indexPath)
        } else {
            addNewEvent()
        }
    }
    
    func addNewEvent() {
        let alert = UIAlertController(title: "Join Event", message: "Enter the event code you recieved from the host to join an event", preferredStyle: .alert)
        
        var eventCodeTextField : UITextField?
        
        alert.addTextField(configurationHandler: {(textField: UITextField!) in
            textField.placeholder = "Enter Code"
            eventCodeTextField = textField
        })
        
        let join = UIAlertAction(title: "Join", style: .default, handler: {(alert: UIAlertAction!) in
            
            self.showActivityIndicator()

            firstly {
                self.tryAddingEventWithCode(code: eventCodeTextField?.text)
            }.then {_ in 
                self.saveEventCode() 
            }.then {
                 self.openNewJoinedEvent()
            }.always {
                self.hideActivityIndicator()
            }.catch {_ in 
                self.showAddEventError()
            }
        })
        
        alert.addAction(join)
        alert.addAction(AlertActions.cancel)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func openSelectedEvent(index: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let photosVC = storyboard.instantiateViewController(withIdentifier: "momentsVC") as! PhotosViewController
        photosVC.selectedImageIndex = index.row
        self.present(photosVC, animated: true, completion: nil)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    private func openNewJoinedEvent() {
        self.performSegue(withIdentifier: "joinEventSegue", sender: nil)
        eventsCollectionView.reloadData()
    }
    
    private func showActivityIndicator() {
        print("show here")
    }
    
    // PLAY WITH PROMISES and see what this does
    private func tryAddingEventWithCode(code: String?) -> Promise<Any> {
        if let code = code {
            return AllEvents.shared.addNewEvent(code)
        }
    }
    
    private func saveEventCode() {
        // In user defaults
    }
    
    private func hideActivityIndicator() {
        print("hidden")
    }
    
    private func showAddEventError() {
        let alert = UIAlertController(title: "Invalid Code", message: "The code entered doesn't seem to match any events", preferredStyle: .alert)
        alert.addAction(AlertActions.cancel)
        self.present(alert, animated: true, completion: nil)
    }
}

