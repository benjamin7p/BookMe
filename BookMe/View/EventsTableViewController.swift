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
    
    var events: [EKEvent]?
    
    var calendars: EKCalendar?
    
    let eventStore = EventKitController.sharedController.eventStore
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendars = EventKitController.sharedController.calendar
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadEvents()
    }

    func loadEvents() {
        // Create a date formatter instance to use for converting a string to a date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        // Create start and end date NSDate instances to build a predicate for which events to select
        let startDate = dateFormatter.date(from: "2019-01-20")
        let endDate = dateFormatter.date(from: "2020-02-23")
        
        if let startDate = startDate, let endDate = endDate {
            //let eventStore = eventStore
            
            if let calendars = EventKitController.sharedController.calendar {
                // Use an event store instance to create and properly configure an NSPredicate
                let eventsPredicate = eventStore.predicateForEvents(withStart: startDate, end: endDate, calendars: [calendars])
                
                // Use the configured NSPredicate to find and return events in the store that match
                self.events = eventStore.events(matching: eventsPredicate).sorted(){
                    (e1: EKEvent, e2: EKEvent) -> Bool in
                    return e1.startDate.compare(e2.startDate) == ComparisonResult.orderedAscending
                }
            }
            tableView.reloadData()
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
    
    func deleteThisEvent(eventToDelete: EKEvent) {
        try? EventKitController.sharedController.eventStore.remove(eventToDelete, span: .thisEvent, commit: true)
    }
//    func deleteCalendar(calendar: EKCalendar) {
//        try? eventStore.removeCalendar(calendar, commit: true)
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
