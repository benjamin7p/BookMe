//
//  EventsListedProviderViewController.swift
//  BookMe
//
//  Created by Benjamin Poulsen PRO on 2/13/19.
//  Copyright © 2019 Benjamin Poulsen PRO. All rights reserved.
//
import EventKit
import EventKitUI
import UIKit

class EventsListedProviderViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    let eventStore = EventKitController.sharedContoller.eventStore
    
    var calendars: EKCalendar?
    
    var events: [EKEvent]? 
    
    @IBOutlet weak var needPermissionView: UIView!
    @IBOutlet weak var providerCalendarView: UIView!
    @IBOutlet weak var providerTableView: UITableView!
    
    static let sharedController = EventsListedProviderViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendars = EventKitController.sharedContoller.calendar
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        checkCalendarAuthorizationStatus()
        eventDidAdd()
        loadEvents()
        
    }
    
    func checkCalendarAuthorizationStatus() {
        let status = EKEventStore.authorizationStatus(for: EKEntityType.event)
        
        switch (status) {
        case EKAuthorizationStatus.notDetermined:
            requestAccessToCalendar()
        case EKAuthorizationStatus.authorized:
            EventKitController.sharedContoller.loadCalendars()
            refreshTableView()
        case EKAuthorizationStatus.restricted, EKAuthorizationStatus.denied:
            needPermissionView.fadeIn()
            
        }
    }
    
    func requestAccessToCalendar() {
        
        eventStore.requestAccess(to: EKEntityType.event, completion: {
            (accessGranted: Bool, error: Error?) in
            
            if accessGranted == true {
                DispatchQueue.main.async {
                    EventKitController.sharedContoller.createCalendar()
                    EventKitController.sharedContoller.loadCalendars()
                    
                    self.refreshTableView()
                }
            } else {
                DispatchQueue.main.async {
                    
                    self.needPermissionView.fadeIn()
                }
            }
        })
    }
    
    
    func refreshTableView() {
        providerCalendarView.isHidden = false
        providerTableView.reloadData()
    }
    
    @IBAction func goToSettingsButtonTapped(_ sender: UIButton) {
        let openSettingsURL = URL(string: UIApplication.openSettingsURLString)
       
        UIApplication.shared.open(openSettingsURL!, options: [:]) { (success) in
            
        }
    }
    
    
    @IBAction func manageButtonTapped(_ sender: UIBarButtonItem) {
        guard let calendars = calendars else {return}
        EventKitController.sharedContoller.calendar = calendars
        
        EventKitController.sharedContoller.loadCalendars()
        self.refreshTableView()
        
    }
    
    func loadEvents() {
        // Create a date formatter instance to use for converting a string to a date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        // Create start and end date NSDate instances to build a predicate for which events to select
        let startDate = dateFormatter.date(from: "2019-01-20")
        let endDate = dateFormatter.date(from: "2019-02-23")
        
        if let startDate = startDate, let endDate = endDate {
            //let eventStore = eventStore
            
            if let calendars = EventKitController.sharedContoller.calendar {
                // Use an event store instance to create and properly configure an NSPredicate
                let eventsPredicate = eventStore.predicateForEvents(withStart: startDate, end: endDate, calendars: [calendars])
                
                // Use the configured NSPredicate to find and return events in the store that match
                self.events = eventStore.events(matching: eventsPredicate).sorted(){
                    (e1: EKEvent, e2: EKEvent) -> Bool in
                    return e1.startDate.compare(e2.startDate) == ComparisonResult.orderedAscending
                }
            }
            refreshTableView()
        }
    }
    
    func formatDate(_ date: Date?) -> String {
        if let date = date {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy"
            return dateFormatter.string(from: date)
        }
        
        return ""
    }
    
    func eventDidAdd() {
        self.loadEvents()
        providerTableView.reloadData()
    }
    
    func calendarDidAdd() {
        EventKitController.sharedContoller.loadCalendars()
        self.refreshTableView()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let events = self.events {
            return events.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProviderCalendarCell")!
        cell.textLabel?.text = events?[(indexPath as NSIndexPath).row].title
        cell.detailTextLabel?.text = formatDate(events?[(indexPath as NSIndexPath).row].startDate)
        return cell
        
    }
}
