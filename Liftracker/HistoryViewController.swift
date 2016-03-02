//
//  HistoryViewController.swift
//  Liftracker
//
//  Created by John McAvey on 10/24/15.
//  Copyright © 2015 John McAvey. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController,UIScrollViewDelegate {

    var current: HistoryTableViewController!,
        shifter: HistoryTableViewController!// Used for animating left and right transitions.
    var pages: [HistoryTableViewController] = []
    let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
    var dayFocus = NSDate()
    @IBOutlet var mainView: UIScrollView!
    @IBOutlet var pageController: UIPageControl!
    @IBOutlet var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        current = HistoryTableViewController(style: UITableViewStyle.Grouped, parent: self)
        shifter = HistoryTableViewController(style: UITableViewStyle.Grouped, parent: self)
        
        configureTableView()
        configureGestures()
        loadAllData()
        setTitle()
        tableView.reloadData()
    }
    
    func configureGestures() {
        let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: "today")
        doubleTapRecognizer.numberOfTapsRequired = 2
        
        let leftSwipeRecognizer = UISwipeGestureRecognizer(target: self, action: "shiftForward")
        let rightSwipeRecognizer = UISwipeGestureRecognizer(target: self, action: "shiftBackward")
        leftSwipeRecognizer.direction = UISwipeGestureRecognizerDirection.Left
        rightSwipeRecognizer.direction = UISwipeGestureRecognizerDirection.Right
        leftSwipeRecognizer.cancelsTouchesInView = true
        rightSwipeRecognizer.cancelsTouchesInView = true
        
        current.view.addGestureRecognizer(doubleTapRecognizer)
        view.addGestureRecognizer(leftSwipeRecognizer)
        view.addGestureRecognizer(rightSwipeRecognizer)
    }
    
    func configureTableView(){
        tableView.delegate = current
        tableView.dataSource = current
        
        tableView.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "Cell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loadAllData(){
        updateView(fill_data(dayFocus), controller: current, day: dayFocus)
    }
    
    @IBAction func shiftForward(){
        let centerD = calendar.dateByAddingUnit(NSCalendarUnit.Day, value: 1, toDate: dayFocus, options: NSCalendarOptions(rawValue: 0))!
        updateView(fill_data(centerD), controller: current, day: centerD)
        dayFocus = centerD
    }
    
    @IBAction func shiftBackward(){
        let centerD = calendar.dateByAddingUnit(NSCalendarUnit.Day, value: -1, toDate: dayFocus, options: NSCalendarOptions(rawValue: 0))!
        updateView(fill_data(centerD), controller: current, day: centerD)
        dayFocus = centerD
    }
    
    @IBAction func today(){
        dayFocus = NSDate()
        updateView(fill_data(dayFocus), controller: current, day: dayFocus)
    }
    
    func updateView(info: (data: [Exercice:[Rep]], keys: [Exercice]), controller: HistoryTableViewController, day: NSDate){
        controller.keys = info.keys
        controller.data = info.data
        controller.day = day
        tableView.reloadData()
    }
    
    func fill_data(day: NSDate)-> (data: [Exercice:[Rep]], keys: [Exercice]){
        var store = [Exercice:[Rep]]()
        var keys = [Exercice]()
        let manager = DataManager.getInstance()
        let muscle_groups = manager.loadAllMuscleGroups()
        for mg in muscle_groups{
            let exercices = manager.loadExercicesFor(muscle_group: mg)
            for exercice in exercices{
                let reps = manager.loadAllRepsFor(exercice: exercice, date: day)
                if reps.count == 0{
                    continue
                }
                store[exercice] = reps
                keys.append(exercice)
            }
        }
        return (store, keys)
    }
    
    func setTitle() {
        ///title = "\(DataManager.getInstance().dateToString(dayFocus))"
        title = "History"
    }
    
    @IBAction func addToCurrent() {
        performSegueWithIdentifier("Add", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destination = segue.destinationViewController as? MGSelectionController {
            destination.addDate = dayFocus
        }
    }
}