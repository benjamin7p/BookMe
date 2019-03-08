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
                    EventKitController.sharedController.loadCalendars()
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
    
   

    
    func formatDate(_ date: Date?) -> String {
        if let date = date {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy"
            return dateFormatter.string(from: date)
        }
        
        return ""
    }
    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewTodaysEventsSegue" {
            guard let eventsTableViewController = segue.destination as? EventsTableViewController else {return}
            
            
            
            let startOfDay =  Calendar.current.startOfDay(for: Date())
            let startofDayZero = Calendar.current.date(byAdding: .hour, value: -7, to: startOfDay)
            let tomorrowStartDate =  Calendar.current.date(byAdding: .day, value: 1, to: startofDayZero!) ?? startOfDay
            
            let endDate = Calendar.current.date(byAdding: .second, value: -1, to: tomorrowStartDate) ?? tomorrowStartDate
            
            
            eventsTableViewController.endDate = endDate
            
            eventsTableViewController.segmentedBar.selectedSegmentIndex = 1
            
            
            
        } else if segue.identifier == "viewAllEvents" {
            guard let eventsTableViewController = segue.destination as? EventsTableViewController else {return}
            

            let endDate = Date.distantFuture
            eventsTableViewController.endDate = endDate
            
            eventsTableViewController.segmentedBar.selectedSegmentIndex = 0
            
            
        }
    }
    


}
