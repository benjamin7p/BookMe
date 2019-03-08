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


class EventKitController {
    
    static let sharedController = EventKitController()
    
    let eventStore = EKEventStore()
    
    var calendar: EKCalendar?
    
    var event: [EKEvent]?
    
    func loadCalendars() {
        for calendar in eventStore.calendars(for: .event) {
            if calendar.title == "My Work Calendar" {
                self.calendar = calendar
            }
        }
    }
    
    
    func deleteCalendar(calendar: EKCalendar) {
        try? eventStore.removeCalendar(calendar, commit: true)
    }
    
    func initialDatePickerValue() -> Date {
        let calendarUnitFlags: NSCalendar.Unit = [.year, .month, .day, .hour, .minute, .second]
        
        var dateComponents = (Calendar.current as NSCalendar).components(calendarUnitFlags, from: Date())
        
        dateComponents.hour = 0
        dateComponents.minute = 0
        dateComponents.second = 0
        
        return Calendar.current.date(from: dateComponents)!
    }
    
    
    
    func createCalendar() {
        
        // Create an Event Store instance
        //let eventStore = EKEventStore();
        
        // Use Event Store to create a new calendar instance
        // Configure its title
        let newCalendar = EKCalendar(for: .event, eventStore: eventStore)
        
        // Probably want to prevent someone from saving a calendar
        // if they don't type in a name...
        newCalendar.title = "My Work Calendar"
        
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
}
//
//    
