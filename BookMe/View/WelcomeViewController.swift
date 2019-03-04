//
//  WelcomeViewController.swift
//  BookMe
//
//  Created by Benjamin Poulsen PRO on 2/26/19.
//  Copyright © 2019 Benjamin Poulsen PRO. All rights reserved.
//

import UIKit
import EventKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var grantedPermissionView: UIView!
    @IBOutlet weak var needPermissionView: UIView!
   
    @IBAction func viewTodaysEventsButtonTapped(_ sender: Any) {
        
        //performSegue(withIdentifier: "viewTodaysEventsSegue", sender: nil)
        
    }
    
    @IBAction func viewAllEventsButtonTapped(_ sender: Any) {
        
    }
    //    static let sharedContoller = WelcomeViewController()
    
//    let eventStore = EKEventStore()
//
    var calendar: EKCalendar?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //calendars = EventKitController.sharedContoller.calendar
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
       checkCalendarAuthorizationStatus()
        
        
        
    }
    
    func checkCalendarAuthorizationStatus() {
        let status = EKEventStore.authorizationStatus(for: EKEntityType.event)
        
        switch (status) {
        case EKAuthorizationStatus.notDetermined:
            requestAccessToCalendar()
        case EKAuthorizationStatus.authorized:
            EventKitController.sharedController.loadCalendars()
            refreshViewsWithPermission()
        case EKAuthorizationStatus.restricted, EKAuthorizationStatus.denied:
            needPermissionView.fadeIn()
            
        }
    }

    func requestAccessToCalendar() {
        
        EventKitController.sharedController.eventStore.requestAccess(to: EKEntityType.event, completion: {
            (accessGranted: Bool, error: Error?) in
            
            if accessGranted == true {
                DispatchQueue.main.async {
                    EventKitController.sharedController.createCalendar()
                    self.refreshViewsWithPermission()
                    
                }
            } else {
                DispatchQueue.main.async {
                    self.refreshViewsDenied()
                }
            }
        })
    }
    
    func refreshViewsWithPermission() {
        grantedPermissionView.isHidden = false
        
    }
    
    func refreshViewsDenied() {
        grantedPermissionView.isHidden = true
        needPermissionView.isHidden = false
    }
    
//    func loadCalendars() {
//        self.calendar = EventKitController.sharedController.eventStore.calendars(for: EKEntityType.event)[2]
//    }
    
    func deleteCalendar(calendar: EKCalendar) {
        try? EventKitController.sharedController.eventStore.removeCalendar(calendar, commit: true)
    }
    
//    var startTimeToday = Date()
//    var endTimeToday = Date()
//    var todaysDate = Date()
    
//    func initialDatePickerValue() -> Date {
//        let calendarUnitFlags: NSCalendar.Unit = [.year, .month, .day, .hour, .minute, .second]
//
//        var dateComponents = (Calendar.current as NSCalendar).components(calendarUnitFlags, from: Date())
//
//        dateComponents.hour = 0
//        dateComponents.minute = 0
//        dateComponents.second = 0
//
//        startTimeToday = Calendar.current.date(from: dateComponents)!
//        return Calendar.current.date(from: dateComponents)!
//
//    }
//
    
    func formatDate(_ date: Date?) -> String {
        if let date = date {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy"
            return dateFormatter.string(from: date)
        }
        
        return ""
    }
    
//    func startInitialDatePickerValue() -> Date {
//        let calendarUnitFlags: NSCalendar.Unit = [.year, .month, .day, .hour, .minute, .second]
//
//        var dateComponents = (Calendar.current as NSCalendar).components(calendarUnitFlags, from: todaysDate)
//
//        startTimeToday = Calendar.current.date(from: dateComponents)!
//        return Calendar.current.date(from: dateComponents)!
//    }
//
//    func EndInitialDatePickerValue() -> Date {
//        let calendarUnitFlags: NSCalendar.Unit = [.year, .month, .day, .hour, .minute, .second]
//
//        var dateComponents = (Calendar.current as NSCalendar).components(calendarUnitFlags, from: startTimeToday)
//
//        dateComponents.day = 1
//
//
//        endTimeToday = Calendar.current.date(from: dateComponents)!
//        return Calendar.current.date(from: dateComponents)!
//
//    }
//
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewTodaysEventsSegue" {
            guard let eventsTableViewController = segue.destination as? EventsTableViewController else {return}
            //eventsTableViewController.startDateTodayForPredicate = startTimeToday
            //eventsTableViewController.endDateTodayForPredicate = endTimeToday
        }
    }

}
