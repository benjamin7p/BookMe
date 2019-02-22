//
//  ProBaseCalendar.swift
//  BookMe
//
//  Created by Benjamin Poulsen PRO on 2/14/19.
//  Copyright © 2019 Benjamin Poulsen PRO. All rights reserved.
//
import UIKit
import Foundation
import EventKit


class EventKitController: UIViewController {
    
    static let sharedContoller = EventKitController()
    
    let eventStore = EKEventStore()
    
    var calendar: EKCalendar?
    
    var event: [EKEvent]?
    
    func loadCalendars() {
        self.calendar = eventStore.calendars(for: EKEntityType.event)[2]
    }
    
    func deleteCalendar(calendar: EKCalendar) {
        try? eventStore.removeCalendar(calendar, commit: true)
    }
    
//    func creatCaledar2(title: String, type: EKCalendar.Type, allowsModify: Bool) -> EKCalendar {
//        let newCalendar = EKCalendar(for: .event, eventStore: eventStore)
//        
//    }
    
    
    func createCalendar() {
        
        // Create an Event Store instance
        //let eventStore = EKEventStore();
        
        // Use Event Store to create a new calendar instance
        // Configure its title
         let newCalendar = EKCalendar(for: .event, eventStore: eventStore)
        
        // Probably want to prevent someone from saving a calendar
        // if they don't type in a name...
        newCalendar.title = "Work Calendar"
        
        // Access list of available sources from the Event Store
        let sourcesInEventStore = eventStore.sources
        
        // Filter the available sources and select the "Local" source to assign to the new calendar's
        // source property
        newCalendar.source = sourcesInEventStore.filter{
            (source: EKSource) -> Bool in
            source.sourceType.rawValue == EKSourceType.local.rawValue
            }.first!
        
        // Save the calendar using the Event Store instance
        do {
            try eventStore.saveCalendar(newCalendar, commit: true)
            UserDefaults.standard.set(newCalendar.calendarIdentifier, forKey: "EventTrackerPrimaryCalendar")
            //delegate?.calendarDidAdd()
            
            //self.dismiss(animated: true, completion: nil)
        } catch {
            let alert = UIAlertController(title: "Calendar could not save", message: (error as NSError).localizedDescription, preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(OKAction)
            
            //self.present(alert, animated: true, completion: nil)
        }
        
        calendar = newCalendar
    
    
    }
    
    
    
//    func createEvent(eventType: EKEvent, name: String)  {
//        if let calendar = calendar,
//            let calendarForEvent = eventStore.calendar(withIdentifier: calendar.calendarIdentifier) {
//
//            var newEvent = EKEvent(eventStore: eventStore)
//
//
//            newEvent.calendar = calendarForEvent
//            newEvent.title = name
//            //newEvent.startDate = startTime.date
//           // newEvent.endDate = endTime.date
//
//            if let event = event?.first {
//                newEvent = event
//
//                do {
//                    try eventStore.save(newEvent, span: .thisEvent, commit: true)
//                    //eventDidAdd()
//
//                    self.navigationController?.popViewController(animated: true)
//
//                } catch {
//                    let alert = UIAlertController(title: "event could not save", message: (error as NSError).localizedDescription, preferredStyle: .alert)
//                    let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//                    alert.addAction(OKAction)
//                    present(alert, animated: true) {
//                        print("hi")
//                    }
//
//                    print(newEvent)
//                    print(event)
//
//                }
//            }
//        }
//    }
    
}

//class EventController {
//
//    let eventStore = NewCalendarController.sharedContoller.eventStore
//    let calendar = NewCalendarController.sharedContoller.newCalendar?[2]
//    let newEvent: [EKEvent]? = newEvent
//
//    static let sharedController = EventController()
//
//    func creatEvent() {
//        if let calendar = NewCalendarController.sharedContoller.newCalendar?[2],
//            let calendarForEvent = eventStore.calendar(withIdentifier: calendar.calendarIdentifier){
//            let newEvent = EKEvent(eventStore: eventStore)
//
//            newEvent.calendar = calendarForEvent
//            newEvent.title = AddEventViewController.sharedController.eventNameTextField.text ?? "Event Name"
//            newEvent.startDate = AddEventViewController.sharedController.startTimeDatePicker.date
//            newEvent.endDate = AddEventViewController.sharedController.endTimeDatePicker.date
//
//            do {
//                try eventStore.save(newEvent, span: .thisEvent, commit: true)
//                // eventDidAdd()
//            }
//    }
//        }
//
//
