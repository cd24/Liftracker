//
//  TodayViewController.swift
//  Liftracker
//
//  Created by John McAvey on 10/20/15.
//  Copyright © 2015 John McAvey. All rights reserved.
//

import UIKit

class TodayViewController: UITableViewController {
    
    var todaysReps: [Exercice:[AnyObject]] = [Exercice:[AnyObject]]()
    var keys: [Exercice] = []
    let manager = DataManager.getInstance()
    let reuseIdentifier = "Cell"

    override func viewDidLoad() {
        super.viewDidLoad()

        loadData()
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: "loadData", forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl?.backgroundColor = UserPrefs.getMainColor()
        self.refreshControl?.tintColor = UserPrefs.getTintColor()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add Exercice", style: UIBarButtonItemStyle.Plain, target: self, action: "add_reps");
        title = "Today"
        
        if
            HealthKitManager.shouldRequestPermission()  {
            //tell user why we need permissions
            let alert = UIAlertController(title: "Health Kit", message: "Hello! Welcome to Liftracker.  Before we begin, we hope you will allow us to use Apples HealthKit to store and manage your data.  Enabling this will make your data as poratable as possible.  Please select 'allow all' so that we can keep your data in health kit.", preferredStyle: UIAlertControllerStyle.Alert)
            let accept = UIAlertAction(title: "OK!", style: UIAlertActionStyle.Default, handler: { (_) -> Void in
                print("Firing")
                HealthKitManager.requestPermission()
            })
            let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
            alert.addAction(accept)
            alert.addAction(cancel)
            presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        loadData()
    }
    
    func loadData(){
        let muscle_groups = manager.loadAllMuscleGroups()
        let today = NSDate()
        todaysReps = [Exercice:[AnyObject]]()
        keys = []
        for mg in muscle_groups{
            let exercices = manager.loadExercicesFor(muscle_group: mg)
            for exercice in exercices {
                let isTimed = exercice.isTimed!.boolValue
                if isTimed {
                    let eod = TimeManager.endOfDay(today)
                    let sod = TimeManager.startOfDay(today)
                    let reps = manager.timedRepsFor(exercice, start: sod, end: eod)
                    if reps.count == 0 {
                        continue
                    }
                    todaysReps[exercice] = reps
                }
                else {
                    let reps = manager.loadAllRepsFor(exercice: exercice, date: today)
                    if reps.count == 0{
                        continue
                    }
                    todaysReps[exercice] = reps
                }
                keys.append(exercice)
            }
        }
        
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return todaysReps.keys.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todaysReps[keys[section]]!.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath)
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        let key = keys[indexPath.section]
        let row = indexPath.row
        if key.isTimed!.boolValue {
            let rep = todaysReps[key]![row] as! TimedRep
            cell.textLabel?.text = "Time: \(rep.duration_hours!):\(rep.duration_minutes!):\(rep.duration_seconds!), Weight: \(rep.weight!)"
        }
        else {
            let rep = todaysReps[key]![row] as! Rep
            cell.textLabel?.text = "Reps: \(rep.num_reps!), Weight: \(manager.getRepWeightString(rep))"
        }
        return cell
    }
    
    @IBAction func add_reps(){
        performSegueWithIdentifier("Add", sender: self)
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return keys[section].name
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let key = keys[indexPath.section]
        if key.isTimed!.boolValue {
            performSegueWithIdentifier("timedRep", sender: self)
        }
        else {
            performSegueWithIdentifier("Rep", sender: self)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "Rep" {
            let indexPath = tableView.indexPathForSelectedRow!
            let controller = segue.destinationViewController as! RepsViewController
            controller.exercice = keys[indexPath.section]
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
        if segue.identifier == "timedRep" {
            let indexPath = tableView.indexPathForSelectedRow!
            let controller = segue.destinationViewController as! TimedRepViewController
            controller.exercice = keys[indexPath.section]
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
        
    }
}
