//
//  EventsTableViewController.swift
//  BookMe
//
//  Created by Benjamin Poulsen PRO on 2/27/19.
//  Copyright © 2019 Benjamin Poulsen PRO. All rights reserved.
//

import UIKit
import EventKit

class EventsTableViewController: UITableViewController, EventAddedDelegate {
    
    var events: [EKEvent]?
    
    //var startDate: Date?
    
    var endDate: Date?
    
    //var todaysDate = Date()
    
    static let sharedController = EventsTableViewController()
    
    let eventStore = EventKitController.sharedController.eventStore
    
    @IBOutlet weak var segmentedBar: UISegmentedControl!
    
    
    
    @IBAction func segmentedBar(_ sender: Any) {
        
        let getIndex = segmentedBar.selectedSegmentIndex
        
        switch (getIndex) {
        case 0:
            loadEventsAll(endDateToLoad: endDateAll())
            
        case 1:
            loadEventsAll(endDateToLoad: endDateCreator())
        
        default:
            loadEventsAll(endDateToLoad: endDateAll())
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.backgroundColor = UIColor.lightGray

    }
    
    override func viewWillAppear(_ animated: Bool) {
       
        if let endDate = endDate {
           loadEventsAll(endDateToLoad: endDate)
        }
        
    }
    
    
    
    func loadEvents() {
        
        
        let newstartDate =  Calendar.current.startOfDay(for: Date())
        
        let startDate = Calendar.current.date(byAdding: .hour, value: -7, to: newstartDate)
        
        
        if let endDate = endDate {
            
            if let calendars = EventKitController.sharedController.calendar {
                // Use an event store instance to create and properly configure an NSPredicate
                let eventsPredicate = eventStore.predicateForEvents(withStart: startDate!, end: endDate, calendars: [calendars])
                
                // Use the configured NSPredicate to find and return events in the store that match
                self.events = eventStore.events(matching: eventsPredicate).sorted(){
                    (e1: EKEvent, e2: EKEvent) -> Bool in
                    return e1.startDate.compare(e2.startDate) == ComparisonResult.orderedAscending
                }
            }
        }
        tableView.reloadData()
        
    }
    
        
    
    

    func loadEventsAll(endDateToLoad: Date) {

        
        let newstartDate =  Calendar.current.startOfDay(for: Date())
        
        let startDate = Calendar.current.date(byAdding: .hour, value: -6, to: newstartDate)
    
            if let calendars = EventKitController.sharedController.calendar {
                // Use an event store instance to create and properly configure an NSPredicate
                let eventsPredicate = eventStore.predicateForEvents(withStart: startDate!, end: endDateToLoad, calendars: [calendars])
                
                // Use the configured NSPredicate to find and return events in the store that match
                self.events = eventStore.events(matching: eventsPredicate).sorted(){
                    (e1: EKEvent, e2: EKEvent) -> Bool in
                    return e1.startDate.compare(e2.startDate) == ComparisonResult.orderedAscending
                }
            }
        
        tableView.reloadData()
        
    }
    
    func eventDidAdd() {
        segmentedBar.selectedSegmentIndex = 1
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

    
    func dateFormatWithTime(date: Date?) -> String {
        if let date = date {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy HH:MM"
        }
        return ""
    }
    
    func deleteThisEvent(eventToDelete: EKEvent) {
        try? EventKitController.sharedController.eventStore.remove(eventToDelete, span: .thisEvent, commit: true)
    }

    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
        cell.textLabel?.textColor = UIColor.black
    }
    
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        if let events = self.events {
//            return events.count
//        }
//        return 0
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let events = self.events {
            
            return events.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell")!
        //TODO: Fix ME.
        let event = events?[indexPath.row]
        cell.textLabel?.text = events?[(indexPath as NSIndexPath).row].title
        cell.detailTextLabel?.text = formatDate(events?[(indexPath as NSIndexPath).row].startDate)
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
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "addButtonTappedSegue" {
//        self.navigationController?.popViewController(animated: true)
//        }
//    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
