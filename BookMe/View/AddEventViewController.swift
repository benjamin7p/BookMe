//
//  AddEventTableViewController.swift
//  BookMe
//
//  Created by Benjamin Poulsen PRO on 2/14/19.
//  Copyright © 2019 Benjamin Poulsen PRO. All rights reserved.
//

import UIKit
import EventKit
import EventKitUI


class AddEventViewController: UIViewController {

    static let sharedController = AddEventViewController()
    
    var eventStore = EventKitController.sharedController.eventStore
    
    var calendar = EventKitController.sharedController.calendar
    
    var event: EKEvent?
    
    @IBOutlet weak var startTimeDatePicker: UIDatePicker!
    @IBOutlet weak var endTimeDatePicker: UIDatePicker!
    @IBOutlet weak var eventNameTextField: UITextField!
    
    
    @IBAction func saveEventButtonTapped(_ sender: UIBarButtonItem) {
        
        createEvent()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let eventsViewController = storyboard.instantiateViewController(withIdentifier: "EventsTableViewController")
        let welcomeViewController = storyboard.instantiateViewController(withIdentifier: "WelcomeViewController")
        let viewControllerArray = [welcomeViewController, eventsViewController]
        self.navigationController?.setViewControllers(viewControllerArray, animated: true)

    }
    
    
    func editEvent() {
        if let event = event {
            EventsTableViewController.sharedController.deleteThisEvent(eventToDelete: event)
        }
    }

    
    func createEvent()  {

        editEvent()
        let newEvent = EKEvent(eventStore: eventStore)

        newEvent.calendar = EventKitController.sharedController.calendar
        newEvent.title = self.eventNameTextField.text ?? "Event Name"
        newEvent.startDate = self.startTimeDatePicker.date
        newEvent.endDate = self.endTimeDatePicker.date

        do {
            try eventStore.save(newEvent, span: .thisEvent, commit: true)
            event = newEvent
        } catch {
            let alert = UIAlertController(title: "event could not save", message: (error as NSError).localizedDescription, preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(OKAction)
            present(alert, animated: true) {
                print("hi")
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendar = EventKitController.sharedController.calendar
        self.startTimeDatePicker.setDate(EventKitController.sharedController.initialDatePickerValue(), animated: true)
        self.endTimeDatePicker.setDate(EventKitController.sharedController.initialDatePickerValue(), animated: true)
        
        if let event = event {
            eventNameTextField.text = event.title
            startTimeDatePicker.date = event.startDate
            endTimeDatePicker.date = event.endDate
        }
    }
}
