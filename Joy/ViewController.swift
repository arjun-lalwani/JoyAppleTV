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
    
    // MARK: Outlets
    @IBOutlet weak var eventsCollectionView: UICollectionView!

    // MARK: Properties
    var eventCodes = AllEvents.shared
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        eventsCollectionView.delegate = self
        eventsCollectionView.dataSource = self
    }

    
    // MARK: Collection View Actions
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return eventCodes.getAllEvents().count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row < eventCodes.getAllEvents().count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "eventCell", for: indexPath) as! CurrentEventCollectionViewCell
            
            let currentEvent = eventCodes.getAllEvents()[indexPath.row]
            
            // using shared instance of eventCodes make a connection to load primary event image and event label
            firstly {
                currentEvent.makeConnection()
            }.then { eventConnection in
                self.customizeCell(cell, eventConnection)
            }.catch {_ in
                self.present(Alert.showConnectionError, animated: true, completion: nil)
            }
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
        if indexPath.row < eventCodes.getAllEvents().count {
            let cell = eventsCollectionView.dequeueReusableCell(withReuseIdentifier: "eventCell", for: indexPath) as! CurrentEventCollectionViewCell
            openSelectedEvent(cell, index: indexPath)
        } else {
            addNewEvent()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    
    // MARK: Helper actions
    private func addNewEvent() {
        let alert = UIAlertController(title: "Join Event", message: "Enter the event code you recieved from the host to join an event", preferredStyle: .alert)
        
        var eventCodeTextField : UITextField?
        
        alert.addTextField(configurationHandler: {(textField: UITextField!) in
            textField.placeholder = "Enter Code"
            eventCodeTextField = textField
        })
        
        let join = UIAlertAction(title: "Join", style: .default, handler: {(alert: UIAlertAction!) in
            
            // Verify code validity, if valid, open new event, else show Alert
            if let code = eventCodeTextField?.text {
                
                // checks if event code is already present
                for eventCode in self.eventCodes.getAllEvents() {
                    if eventCode.code == code {
                        self.present(Alert.showEventAlreadyExists, animated: true, completion: nil)
                        return
                    }
                }
    
                self.showActivityIndicator()
                
                firstly {
                    self.tryAddingEventWith(code)
                }.then {_ in
                    self.openNewJoinedEvent()
                }.always {
                    self.hideActivityIndicator()
                }.catch {_ in
                    self.present(Alert.addEventError, animated: true, completion: nil)
                }
            } else {
                self.present(Alert.enterCode, animated: true, completion: nil)
            }
        })
        
        alert.addAction(join)
        alert.addAction(AlertActions.cancel)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func customizeCell(_ cell: CurrentEventCollectionViewCell, _ event: EventConnection) {
        cell.eventName.text = event.eventInfo.eventName
        cell.eventInfo = event.eventInfo
        
        firstly {
            event.eventInfo.primaryPhoto.getImage()
        }.then { eventImage in
            cell.eventImage.image = eventImage
        }.catch {_ in 
            self.present(Alert.showConnectionError, animated: true, completion: nil)
        }
    }

    private func openSelectedEvent(_ cell: CurrentEventCollectionViewCell, index: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let photosVC = storyboard.instantiateViewController(withIdentifier: "momentsVC") as! PhotosViewController
        photosVC.selectedEventInfo = cell.eventInfo
        self.present(photosVC, animated: true, completion: nil)
    }
    
    private func openNewJoinedEvent() {
        self.performSegue(withIdentifier: "joinEventSegue", sender: nil)
        eventsCollectionView.reloadData()
    }
    
    private func showActivityIndicator() {
        // FIXME: Add activity indicator here
        print("show activity indicator here")
    }

    private func tryAddingEventWith(_ code: String) -> Promise<EventCode> {
        return AllEvents.shared.addNewEvent(code)
    }

    private func hideActivityIndicator() {
        // FIXME: Hide activity indicator here
        print("hide activity indicator here")
    }
}

