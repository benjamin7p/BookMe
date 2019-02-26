//
//  EventViewController.swift
//  BookMe
//
//  Created by Benjamin Poulsen PRO on 2/25/19.
//  Copyright © 2019 Benjamin Poulsen PRO. All rights reserved.
//

import UIKit
import EventKit
import EventKitUI

class EKEventViewController: UIViewController {
    
    
    func eventViewController(_ controller: EKEventViewController, didCompleteWith action: EKEventViewAction) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    static let sharedController =  EKEventViewController()
    var event: EKEvent?
    var delegate: EKEventViewDelegate?
    var editingViewDelegate: EKEventEditViewDelegate?
   
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
       let selectedEventStartDate = formatDate(event?.startDate)
        let selectedEventEndDate = formatDate(event?.endDate)
        eventNameLabel.text = event?.title
        eventStartTimeLabel.text = selectedEventStartDate
        eventEndTimeLabel.text = selectedEventEndDate
        
    }
    

    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventStartTimeLabel: UILabel!
    @IBOutlet weak var eventEndTimeLabel: UILabel!
    
    func formatDate(_ date: Date?) -> String {
        if let date = date {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy"
            return dateFormatter.string(from: date)
        }
        
        return ""
    }
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "editButtonSegue" {
//            guard let detailVC = segue.destination as? EditViewController else {return}
//               
//            let eventToEdit = event
//            detailVC.event = eventToEdit
//            
//            detailVC.loadViewIfNeeded()
//        }
//    }

}
