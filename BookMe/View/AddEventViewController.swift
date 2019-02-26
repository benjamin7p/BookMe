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
    
    //var calendar: EKCalendar?
    var event: EKEvent?
        
    
    
    @IBOutlet weak var startTimeDatePicker: UIDatePicker!
    
    
    @IBOutlet weak var endTimeDatePicker: UIDatePicker!
    @IBOutlet weak var eventNameTextField: UITextField!
    
    
    @IBAction func saveEventButtonTapped(_ sender: UIBarButtonItem) {
         
        createEvent()
        self.navigationController?.popViewController(animated: true)
    }
    func createEvent()  {

            let newEvent = EKEvent(eventStore: EventKitController.sharedContoller.eventStore)

            newEvent.calendar = EventKitController.sharedContoller.calendar
            newEvent.title = self.eventNameTextField.text ?? "Event Name"
            newEvent.startDate = self.startTimeDatePicker.date
            newEvent.endDate = self.endTimeDatePicker.date

            do {
                try EventKitController.sharedContoller.eventStore.save(newEvent, span: .thisEvent, commit: true)
                
                

                
            } catch {
                let alert = UIAlertController(title: "event could not save", message: (error as NSError).localizedDescription, preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(OKAction)
                present(alert, animated: true) {
                    print("hi")
                }

                print(newEvent)
                event = newEvent
                


        }
    }

    

    
    
    func initialDatePickerValue() -> Date {
        let calendarUnitFlags: NSCalendar.Unit = [.year, .month, .day, .hour, .minute, .second]
        
        var dateComponents = (Calendar.current as NSCalendar).components(calendarUnitFlags, from: Date())
        
        dateComponents.hour = 0
        dateComponents.minute = 0
        dateComponents.second = 0
        
        return Calendar.current.date(from: dateComponents)!
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.startTimeDatePicker.setDate(initialDatePickerValue(), animated: true)
        self.endTimeDatePicker.setDate(initialDatePickerValue(), animated: true)
    }

    
}
