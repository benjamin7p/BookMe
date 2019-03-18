//
//  EventsTableViewController.swift
//  BookMe
//
//  Created by Benjamin Poulsen PRO on 2/27/19.
//  Copyright © 2019 Benjamin Poulsen PRO. All rights reserved.
//

import UIKit
import EventKit

class EventsTableViewController: UITableViewController {
    
    static let sharedController = EventsTableViewController()
    
    let eventStore = EventKitController.sharedController.eventStore
    
    var events: [EKEvent]?
    
    var endDate: Date?
    
    
    @IBOutlet weak var segmentedBar: UISegmentedControl!
    
    
    override func viewWillAppear(_ animated: Bool) {
        if let endDate = endDate {
            loadEventsWithEndDate(endDateToLoad: endDate)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func segmentedBar(_ sender: Any) {
        
        let getIndex = segmentedBar.selectedSegmentIndex
        
        switch (getIndex) {
        case 0:
            loadEventsWithEndDate(endDateToLoad: endDateAll())
        case 1:
            loadEventsWithEndDate(endDateToLoad: endDateCreator())
        default:
            loadEventsWithEndDate(endDateToLoad: endDateAll())
        }
    }
    
    
    func endDateCreator() -> Date {
        let startDate =  Calendar.current.startOfDay(for: Date())
        let tomorrowStartDate =  Calendar.current.date(byAdding: .day, value: 1, to: startDate) ?? startDate
        let endDate = Calendar.current.date(byAdding: .second, value: -1, to: tomorrowStartDate) ?? tomorrowStartDate
        
        return endDate
    }
    
    
    func endDateAll() -> Date {
        let endDate = Date.distantFuture
        return endDate
    }
    
    
    func loadEvents() {
        let newstartDate =  Calendar.current.startOfDay(for: Date())
        let startDate = Calendar.current.date(byAdding: .hour, value: -6, to: newstartDate)
        let endDateAll = Date.distantFuture
        
        if let calendars = EventKitController.sharedController.calendar {
            let eventsPredicate = eventStore.predicateForEvents(withStart: startDate!, end: endDateAll, calendars: [calendars])
            
            self.events = eventStore.events(matching: eventsPredicate).sorted(){
                (e1: EKEvent, e2: EKEvent) -> Bool in
                return e1.startDate.compare(e2.startDate) == ComparisonResult.orderedAscending
            }
            
        }
        tableView.reloadData()
    }
    
    
    func loadEventsWithEndDate(endDateToLoad: Date) {
        let todayAt6 =  Calendar.current.startOfDay(for: Date())
        let todayAt12 = Calendar.current.date(byAdding: .hour, value: -6, to: todayAt6)
        
        if let calendars = EventKitController.sharedController.calendar {
            let eventsPredicate = eventStore.predicateForEvents(withStart: todayAt12!, end: endDateToLoad, calendars: [calendars])
            
            self.events = eventStore.events(matching: eventsPredicate).sorted(){
                (e1: EKEvent, e2: EKEvent) -> Bool in
                return e1.startDate.compare(e2.startDate) == ComparisonResult.orderedAscending
            }
        }
        tableView.reloadData()
    }

    
    func formatDate(_ date: Date?) -> String {
        if let date = date {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy"
            
            return dateFormatter.string(from: date)
        }
        return ""
    }

    
    func deleteThisEvent(eventToDelete: EKEvent) {
        try? EventKitController.sharedController.eventStore.remove(eventToDelete, span: .thisEvent, commit: true)
    }
    
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let events = self.events {
            
            return events.count
        }
        return 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell")!
        let event = events?[indexPath.row]
        cell.textLabel?.text = event?.title
        cell.detailTextLabel?.text = formatDate(event?.startDate)
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let event = events?[indexPath.row] {
                deleteThisEvent(eventToDelete: event)
                events?.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                
                tableView.reloadData()
            }
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editCellSegue" {
            guard let addEventViewController = segue.destination as? AddEventTableViewController,
                let selectedRow = self.tableView.indexPathForSelectedRow?.row else {return}
            
            let selectedEvent = events?[selectedRow]
            addEventViewController.event = selectedEvent
            addEventViewController.loadViewIfNeeded()
        }
    }
}
