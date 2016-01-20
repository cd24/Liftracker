//
//  TimedRepViewController.swift
//  Liftracker
//
//  Created by John McAvey on 1/19/16.
//  Copyright © 2016 MCApps. All rights reserved.
//

import UIKit

class TimedRepViewController: UIViewController {

    @IBOutlet weak var time_label: UILabel!
    @IBOutlet weak var ss_button: UIButton!
    @IBOutlet weak var stop_button: UIButton!
    @IBOutlet weak var weight_field: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var timer: NSTimer!
    var exercice: Exercice!
    var start: NSDate!, stop: NSDate!
    var elapsed_time = 0.0
    
    var time_interval = 0.1 //in MS
    var timing = false
    var numberFormatter = NSNumberFormatter()
    let manager = DataManager.getInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        numberFormatter.paddingPosition = NSNumberFormatterPadPosition.BeforePrefix
        numberFormatter.paddingCharacter = "0"
        numberFormatter.minimumIntegerDigits = 2
        self.title = exercice.name!
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func toggleTimer() {
        if timing {
            stop_timer()
        }
        else {
            start_timer()
        }
    }
    
    func start_timer() {
        start = NSDate()
        elapsed_time = 0
        timer = NSTimer(timeInterval: 0, target: self, selector: "update_timer", userInfo: nil, repeats: true)
        NSRunLoop.currentRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)
        ss_button.setTitle("Stop", forState: UIControlState.Normal)
        timing = true
    }
    
    func stop_timer() {
        stop = NSDate()
        timer.invalidate()
        save_rep()
        ss_button.setTitle("Start", forState: UIControlState.Normal)
        timing = false
    }
    
    func update_timer() {
        elapsed_time += time_interval
        let seconds = numberFormatter.stringFromNumber(Int((elapsed_time/1000)%60))!
        let minutes = numberFormatter.stringFromNumber(Int((elapsed_time/1000/60)%60))!
        let hours = numberFormatter.stringFromNumber(Int((elapsed_time/1000/60/60)%60))!
        time_label.text = "\(hours):\(minutes):\(seconds)"
    }
    
    func save_rep(){
        if let val = weight_field.text {
            if let value = Double(val) {
                manager.newTimedRep(start, end: stop, weight: value, exercice: exercice)
            }
        }
        else {
            manager.newTimedRep(start, end: stop, exercice: exercice)
        }
    }

    //MARK: - Table View Delegate
    //MARK: - Table View Data Source

}
