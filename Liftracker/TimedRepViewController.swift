//
//  TimedRepViewController.swift
//  Liftracker
//
//  Created by John McAvey on 1/19/16.
//  Copyright © 2016 MCApps. All rights reserved.
//

import UIKit

class TimedRepViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var time_label: UILabel!
    @IBOutlet weak var ss_button: UIButton!
    @IBOutlet weak var weight_field: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var unit_label: UILabel!
    
    var timer: NSTimer!
    var exercice: Exercice!
    var start: NSDate!, stop: NSDate!
    var elapsed_time = 0.0
    var reps = [NSDate:[TimedRep]]()
    var keys = [NSDate]()
    
    var time_interval = 0.1 //in seconds
    var timing = false
    var numberFormatter = NSNumberFormatter()
    let manager = DataManager.getInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        numberFormatter.paddingPosition = NSNumberFormatterPadPosition.BeforePrefix
        numberFormatter.paddingCharacter = "0"
        numberFormatter.minimumIntegerDigits = 2
        self.title = exercice.name!
        unit_label.text = UserPrefs.getUnitString()
        loadReps()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        tableView.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "Cell")
        
        let recognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        self.view.addGestureRecognizer(recognizer)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(animated: Bool) {
        if let _ = timer {
            timer.invalidate()
        }
    }
    
    @IBAction func toggleTimer() {
        if timing {
            stopTimer()
        }
        else {
            startTimer()
        }
    }
    
    func startTimer() {
        start = NSDate()
        elapsed_time = 0
        timer = NSTimer(timeInterval: 0, target: self, selector: "update_timer", userInfo: nil, repeats: true)
        NSRunLoop.currentRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)
        ss_button.setTitle("Stop", forState: UIControlState.Normal)
        ss_button.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
        timing = true
    }
    
    func stopTimer() {
        stop = NSDate()
        timer.invalidate()
        save_rep()
        ss_button.setTitle("Start", forState: UIControlState.Normal)
        ss_button.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        timing = false
    }
    
    func update_timer() {
        let now = NSDate()
        let duration = TimeManager.getDuration(start, end: now)
        let hr = numberFormatter.stringFromNumber(duration.hour)
        let min = numberFormatter.stringFromNumber(duration.minute)
        let sec = numberFormatter.stringFromNumber(duration.second)
        time_label.text = "\(hr!):\(min!):\(sec!)"
    }
    
    func loadReps() {
        reps = [NSDate:[TimedRep]]()
        keys = [NSDate]()
        if let ex = exercice {
            let ar = manager.timedRepsFor(ex)
            for rep in ar {
                let date = TimeManager.startOfDay(rep.start_time!)
                if reps.keys.contains(date) {
                    reps[date]!.append(rep)
                }
                else {
                    reps[date] = [rep]
                    keys.append(date)
                }
            }
            sortKeys()
        }
        tableView.reloadData()
    }
    
    func sortKeys(){
        keys.sortInPlace { date1, date2 in
            return date1.compare(date2) == NSComparisonResult.OrderedDescending
        }
    }
    
    func save_rep(){
        let text = weight_field?.text
        let sod = TimeManager.startOfDay(NSDate())
        if !(reps.keys.contains(sod)){
            reps[sod] = []
            keys.append(sod)
            sortKeys()
        }
        if let val = Double(text!) {
            print(val)
            if val > 0 {
                reps[sod]!.append(manager.newTimedRep(start, end: stop, weight: val, exercice: exercice))
            }
            else {
                reps[sod]!.append(manager.newTimedRep(start, end: stop, exercice: exercice))
            }
        }
        else {
            reps[sod]!.append(manager.newTimedRep(start, end: stop, exercice: exercice))
        }
        
        
        let section = keys.indexOf(sod)!
        let indexPath = NSIndexPath(forRow: 0, inSection: section)
        if reps[keys[section]]!.count == 1 {
            tableView?.insertSections(NSIndexSet(index: section), withRowAnimation: .Right)
        }
        else {
            tableView?.beginUpdates()
            tableView?.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Right)
            tableView?.endUpdates()
        }
    }
    
    func dismissKeyboard() {
        if weight_field.isFirstResponder() {
            weight_field.resignFirstResponder()
        }
    }

    //MARK: - Table View Delegate
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false //todo: Implement deleting reps
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        //todo: Implement deleting reps
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        //todo: Implement resume
    }
    
    //MARK: - Table View Data Source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return keys.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let key = keys[section]
        return reps[key]!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")!
        
        let key = keys[indexPath.section]
        let rep_list = reps[key]!
        let rep = rep_list[indexPath.row]
        let hrs = numberFormatter.stringFromNumber(rep.duration_hours!)
        let minutes = numberFormatter.stringFromNumber(rep.duration_minutes!)
        let seconds = numberFormatter.stringFromNumber(rep.duration_seconds!)
        cell.textLabel?.text = "Time: \(hrs!):\(minutes!):\(seconds!), Weight: \(rep.weight!)"
        
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if reps.keys.count == 0 {
            return ""
        }
        let date = keys[section]
        return TimeManager.dateToString(date)
    }

}
