//
//  AvailabilityListTableViewController.swift
//  BookMe
//
//  Created by Benjamin Poulsen PRO on 2/13/19.
//  Copyright © 2019 Benjamin Poulsen PRO. All rights reserved.
//
import EventKit
import UIKit

class AvailabilityListTableViewController: UITableViewController {
    
    var calendar: EKCalendar!
    var events: [EKEvent]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        EventsListedProviderViewController.sharedController.loadEvents()
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let events = events {
            return events.count
        }
        
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "basicCell")!
        cell.textLabel?.text = events?[(indexPath as NSIndexPath).row].title
        return cell
    }
    
}

