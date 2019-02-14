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

class EventsListedProviderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let eventStore = EKEventStore()
    
    var calendars: [EKCalendar]?
    
    @IBOutlet weak var needPermissionView: UIView!
    @IBOutlet weak var providerCalendarView: UIView!
    @IBOutlet weak var providerTableView: UITableView!
    
    static let sharedController = EventsListedProviderViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
            loadCalendars()
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
                    self.loadCalendars()
                    self.refreshTableView()
                }
            } else {
                DispatchQueue.main.async {
                    self.needPermissionView.fadeIn()
                }
            }
        })
    }

    func loadCalendars() {
        self.calendars = eventStore.calendars(for: EKEntityType.event)
    }
    
    func refreshTableView() {
        providerCalendarView.isHidden = false
        providerTableView.reloadData()
    }
    
    @IBAction func goToSettingsButtonTapped(_ sender: UIButton) {
        let openSettingsURL = URL(string: UIApplication.openSettingsURLString)
        UIApplication.shared.openURL(openSettingsURL!)
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let calendars = self.calendars {
            return calendars.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProviderCalendarCell")!
        
        if let calendars = self.calendars {
            let calendarName = calendars[(indexPath as NSIndexPath).row].title
            cell.textLabel?.text = calendarName
        } else {
            cell.textLabel?.text = "No calendars loaded"
        }
        return cell
    }
    
    func calendarDidAdd() {
        self.loadCalendars()
        self.refreshTableView()
    }
    
    @IBAction func manageButtonTapped(_ sender: UIBarButtonItem) {
        
        let proBaseCalendar = EKCalendar(for: .event, eventStore: eventStore)
        proBaseCalendar.title = "My Work Calendar"
        let sourcesInEventStore = eventStore.sources
    
        proBaseCalendar.source = sourcesInEventStore.filter{
            (source: EKSource) -> Bool in
            source.sourceType.rawValue == EKSourceType.local.rawValue
            }.first!
        
        do {
            try eventStore.saveCalendar(proBaseCalendar, commit: true)
            UserDefaults.standard.set(proBaseCalendar.calendarIdentifier, forKey: "My Work Calendar")
            calendarDidAdd()
        } catch {
            let alert = UIAlertController(title: "Calender could not save", message: (error as NSError).localizedDescription, preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(OKAction)
            
            self.present(alert, animated: true, completion: nil)
            
        }
        

    }
    
    
    
    
}
