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
    @IBOutlet weak var viewTodayAppointmentsButton: UIButton!
    @IBOutlet weak var viewAllAppointmentsButton: UIButton!
    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBAction func viewTodayButtonTapped(_ sender: Any) {
        UIView.animate(withDuration: 0.1) {
            self.viewTodayAppointmentsButton.transform = CGAffineTransform(scaleX: 5.0, y: 5.0)
            self.viewTodayAppointmentsButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
    }
    
    @IBAction func viewAllButtonTapped(_ sender: Any) {
        UIView.animate(withDuration: 0.1) {
        self.viewAllAppointmentsButton.transform = CGAffineTransform(scaleX: 5.0, y: 5.0)
        self.viewAllAppointmentsButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
        
    }
    
    var calendar: EKCalendar?
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewTodayAppointmentsButton.layer.cornerRadius = 5.0
        viewAllAppointmentsButton.layer.cornerRadius = 5.0
        //iconImageView.layer.cornerRadius = 5.0
        
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "WelcomeBackGround")
        backgroundImage.contentMode = UIView.ContentMode.scaleToFill
        self.grantedPermissionView.insertSubview(backgroundImage, at: 0)
        
        checkCalendarAuthorizationStatus()
    
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
    
    @IBAction func goToSettingsButtonTapped(_ sender: UIButton) {
        let openSettingsUrl = URL(string: UIApplication.openSettingsURLString)
        UIApplication.shared.open(openSettingsUrl!, options: [:], completionHandler: nil)
    }
}

