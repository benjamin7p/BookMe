//
//  EventController.swift
//  BookMe
//
//  Created by Benjamin Poulsen PRO on 2/15/19.
//  Copyright © 2019 Benjamin Poulsen PRO. All rights reserved.
//

import Foundation
import EventKit

//class EventController {
//    
//    let eventStore = NewCalendarController.sharedContoller.eventStore
//    let calendar = NewCalendarController.sharedContoller.calendar
//    var event: EKEvent?
    
//    func createEvent(title: String, calendar: EKCalendar, location: [String]?) -> EKEvent {
//        let event = Event(title: title, calendar: calendar, location: location)
//
//        let newevent = EKEvent(eventStore: eventStore)
//
//        return event
//    }
    //Create an EKEvent
    //Edit an EKevent using the UI given to you from apple
    //Delete and EKEvent same as above
    
//}



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
//}
