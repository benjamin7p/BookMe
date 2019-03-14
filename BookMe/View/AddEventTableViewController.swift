//
//  AddEventTableViewController.swift
//  BookMe
//
//  Created by Benjamin Poulsen PRO on 3/12/19.
//  Copyright © 2019 Benjamin Poulsen PRO. All rights reserved.
//

import UIKit
import EventKit

class AddEventTableViewController: UITableViewController {

    static let sharedController = AddEventTableViewController()

    var event: EKEvent?
    
    let startDatePickerCellIndexPath = IndexPath(row: 1, section: 1)
    let startTimeDatePickerCellIndexPath = IndexPath(row: 3, section: 1)
    let endTimeDatePickerCellIndexPath = IndexPath(row: 5, section: 1)
    let eventNotesCellIndexPath = IndexPath(row: 1, section: 2)
    
    var isStartDatePickerShown: Bool = false {
        didSet {
            startDatePicker.isHidden = !isStartDatePickerShown
        }
    }
    
    var isStartTimeDatePickerShown: Bool = false {
        didSet {
            startTimeDatePicker.isHidden = !isStartTimeDatePickerShown
        }
    }
    
    var isEndTimeDatePickerShown: Bool = false {
        didSet {
            endTimeDatePicker.isHidden = !isEndTimeDatePickerShown
        }
    }
    
    var isEventNotesShown: Bool = false {
        didSet {
            eventNotesTextView.isHidden = !isEventNotesShown
        }
    }

    @IBOutlet weak var eventNameTextField: UITextField!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var startTimeDatePicker: UIDatePicker!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var endTimeDatePicker: UIDatePicker!
    @IBOutlet weak var eventNotesLabel: UILabel!
    @IBOutlet weak var eventNotesTextView: UITextView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaultStartDate = EventKitController.sharedController.initialDatePickerValue()
        let defaultEndDate = defaultStartDate.addingTimeInterval(3600)
        
        startDatePicker.setDate(defaultStartDate, animated: true)
        startTimeDatePicker.setDate(defaultStartDate, animated: true)
        endTimeDatePicker.setDate(defaultEndDate, animated: true)
        
        
        let dateFormatterForStartDate = DateFormatter()
        dateFormatterForStartDate.dateFormat = "MM/dd"
        let dateFormatterForTime = DateFormatter()
        dateFormatterForTime.dateFormat = "hh:mm"
        
        
        
        startDateLabel.text = dateFormatterForStartDate.string(from: startDatePicker.date)
        startTimeLabel.text = dateFormatterForTime.string(from: startTimeDatePicker.date)
        endTimeLabel.text = dateFormatterForTime.string(from: endTimeDatePicker.date)
        
//        self.startDatePicker.setDate(EventKitController.sharedController.initialDatePickerValue(), animated: true)
//        self.startTimeDatePicker.setDate(EventKitController.sharedController.initialDatePickerValue(), animated: true)
//        self.endTimeDatePicker.setDate(EventKitController.sharedController.initialDatePickerValue().addingTimeInterval(3600), animated: true)
        
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateStyle = .long
//        dateFormatter.dateFormat = "MM/dd hh:mm"
//
//        self.startDateLabel.text = dateFormatter.string(from: startDatePicker.date)
//        self.startTimeLabel.text = dateFormatter.string(from: startTimeDatePicker.date)
//        self.endTimeLabel.text = dateFormatter.string(from: endTimeDatePicker.date)
//
        if let event = event {
            eventNameTextField.text = event.title
            startDatePicker.setDate(event.startDate, animated: true)
            startDateLabel.text = dateFormatterForStartDate.string(from: startDatePicker.date)
            startTimeDatePicker.date = event.startDate
            startTimeLabel.text = dateFormatterForTime.string(from: startTimeDatePicker.date)
            endTimeDatePicker.date = event.endDate
            endTimeLabel.text = dateFormatterForTime.string(from: endTimeDatePicker.date)
            eventNotesTextView.text = event.notes
            
            tableView.reloadData()
        }
    }
    
    func dateFormatWithTime(date: Date?) -> String {
        if let date = date {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy HH:MM"
        }
        return ""
    }
    
    
    func updateDateViews() {
        let dateFormatterForStartDate = DateFormatter()
        dateFormatterForStartDate.dateFormat = "MM/dd"
        let dateFormatterForTime = DateFormatter()
        dateFormatterForTime.dateFormat = "hh:mm"
        
        let startTime = startTimeDatePicker.date
        let startDate = startDatePicker.date
        let endTime = endTimeDatePicker.date
        
        if startTime < startDate {
            
            startTimeLabel.text = dateFormatterForTime.string(from: startDate)
            startDateLabel.text = dateFormatterForStartDate.string(from: startDate)
            endTimeLabel.text = dateFormatterForTime.string(from: startDate.addingTimeInterval(3600))
            startTimeDatePicker.setDate(startDate, animated: true)
            endTimeDatePicker.setDate(startDate.addingTimeInterval(3600), animated: true)
            endTimeLabel.text = dateFormatterForTime.string(from: startDate)
        }
        
       // endTimeLabel.text = dateFormatter.string(from: startDate)
        
        startTime.compare(startDate)
        // if startDate changes update startTime
//        startDateLabel.text = dateFotmatter.string(from: startDatePicker.date)
//        startTimeLabel.text = dateFotmatter.string(from: startTimeDatePicker.date)
//        endTimeLabel.text = dateFotmatter.string(from: endTimeDatePicker.date)
        
    }
    
    
    func editEvent() {
        if let event = event {
            EventsTableViewController.sharedController.deleteThisEvent(eventToDelete: event)
        }
    }
    
    
    func createEvent()  {
        
        editEvent()
        let newEvent = EKEvent(eventStore: EventKitController.sharedController.eventStore)
        
        newEvent.calendar = EventKitController.sharedController.calendar
        newEvent.title = self.eventNameTextField.text ?? "Name"
        newEvent.startDate = self.startTimeDatePicker.date
        newEvent.endDate = self.endTimeDatePicker.date
        newEvent.notes = self.eventNotesTextView.text ?? ""
        
        
        do {
            try EventKitController.sharedController.eventStore.save(newEvent, span: .thisEvent, commit: true)
            event = newEvent
            
            
            //delegate?.eventDidAdd()
            self.dismiss(animated: true, completion: nil)
        } catch {
            let alert = UIAlertController(title: "event could not save", message: (error as NSError).localizedDescription, preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(OKAction)
            present(alert, animated: true) {
                print("event not saved")
            }
        }
    }
    
    
    @IBAction func startDatePickerValueChanged(_ sender: Any) {
        updateDateViews()
    }
    
    @IBAction func startTimeDatePickerValueChanged(_ sender: Any) {
        updateDateViews()
        
        let dateFormatterForTime = DateFormatter()
        dateFormatterForTime.dateFormat = "hh:mm"
        
        startTimeLabel.text = dateFormatterForTime.string(from: startTimeDatePicker.date)
        endTimeLabel.text = dateFormatterForTime.string(from: startTimeDatePicker.date.addingTimeInterval(3600))
        endTimeDatePicker.setDate(startTimeDatePicker.date.addingTimeInterval(3600), animated: true)
    }
    
    @IBAction func endTimeDatePickerValueChanged(_ sender: Any) {
        updateDateViews()
        
        let dateFormatterForTime = DateFormatter()
        dateFormatterForTime.dateFormat = "hh:mm"
        
        endTimeLabel.text = dateFormatterForTime.string(from: endTimeDatePicker.date)
        
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        createEvent()
        self.navigationController?.popViewController(animated: true)
    }
    
    
        
    
    
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch (indexPath.section, indexPath.row) {
        case (startDatePickerCellIndexPath.section, startDatePickerCellIndexPath.row):
            if isStartDatePickerShown {
                return 216.0
            } else {
                return 0.0
            }
        case (startTimeDatePickerCellIndexPath.section, startTimeDatePickerCellIndexPath.row):
            if isStartTimeDatePickerShown {
                return 216.0
            } else {
                return 0.0
            }
        case (endTimeDatePickerCellIndexPath.section, endTimeDatePickerCellIndexPath.row):
            if isEndTimeDatePickerShown {
                return 216.0
            } else {
                return 0.0
            }
        case (eventNotesCellIndexPath.section, eventNotesCellIndexPath.row):
            if isEventNotesShown {
                return 200.0
            } else {
                return 0.0
            }
        default:
            return 44.0
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
//        if indexPath.section == 1  && indexPath.row == 0 {
//            isStartDatePickerShown = !isStartTimeDatePickerShown
//        }
//                    tableView.beginUpdates()
//                    tableView.endUpdates()
        
        switch (indexPath.section, indexPath.row) {
        case (startDatePickerCellIndexPath.section, startDatePickerCellIndexPath.row - 1):
//            isStartDatePickerShown = !isStartTimeDatePickerShown
//            isStartTimeDatePickerShown = false
//            isEndTimeDatePickerShown = false
            if isStartDatePickerShown {
                isStartDatePickerShown = false
            } else if isStartTimeDatePickerShown {
                isStartTimeDatePickerShown = false
                isStartDatePickerShown = true
                isEndTimeDatePickerShown = true
            } else if isEndTimeDatePickerShown {
                isEndTimeDatePickerShown = false
                isStartDatePickerShown = true
                isStartTimeDatePickerShown = true
            } else {
                isStartDatePickerShown = true
            }

            tableView.beginUpdates()
            tableView.endUpdates()

        case (startTimeDatePickerCellIndexPath.section, startTimeDatePickerCellIndexPath.row - 1):
            if isStartTimeDatePickerShown {
                isStartTimeDatePickerShown = false
            } else if isStartDatePickerShown {
                isStartDatePickerShown = false
                isEndTimeDatePickerShown = true
                isStartDatePickerShown = true
            } else if isEndTimeDatePickerShown {
                isEndTimeDatePickerShown = false
                isStartDatePickerShown = true
                isStartTimeDatePickerShown = true
            } else {
                isStartTimeDatePickerShown = true
            }

            tableView.beginUpdates()
            tableView.endUpdates()

        case (endTimeDatePickerCellIndexPath.section, endTimeDatePickerCellIndexPath.row - 1):
            if isEndTimeDatePickerShown {
                isEndTimeDatePickerShown = false
            } else if isStartDatePickerShown {
                isStartDatePickerShown =  false
                isStartTimeDatePickerShown = true
                isEndTimeDatePickerShown = true
            } else if isStartTimeDatePickerShown {
                isStartTimeDatePickerShown = false
                isStartDatePickerShown = true
                isEndTimeDatePickerShown = true
            } else {
                isEndTimeDatePickerShown = true
            }

            tableView.beginUpdates()
            tableView.endUpdates()
            
            case (eventNotesCellIndexPath.section, eventNotesCellIndexPath.row - 1):
                if isEventNotesShown {
                    isEventNotesShown = false
                    eventNotesLabel.text = "Open"
                    eventNotesTextView.text = eventNotesTextView.text
                } else {
                    isEventNotesShown = true
                    eventNotesLabel.text = "Close"
                    eventNotesTextView.text = eventNotesTextView.text
                }
            
            tableView.beginUpdates()
            tableView.endUpdates()

        default:
            break
        }
    }
    
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
