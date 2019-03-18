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
        let newCalendar = EKCalendar(for: .event, eventStore: eventStore)
        newCalendar.title = "My Work Calendar"
        
        let sourcesInEventStore = eventStore.sources
        
        newCalendar.source = sourcesInEventStore.filter{
            (source: EKSource) -> Bool in
            source.sourceType.rawValue == EKSourceType.local.rawValue
            }.first!
        
        do {
            try eventStore.saveCalendar(newCalendar, commit: true)
            UserDefaults.standard.set(newCalendar.calendarIdentifier, forKey: "EventTrackerPrimaryCalendar")
        } catch {
            let alert = UIAlertController(title: "Calendar could not save", message: (error as NSError).localizedDescription, preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(OKAction)
        }
        calendar = newCalendar
    }
}
