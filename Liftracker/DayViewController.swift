//
//  HistoryViewController.swift
//  Liftracker
//
//  Created by John McAvey on 10/23/15.
//  Copyright © 2015 John McAvey. All rights reserved.
//

import UIKit

class DayViewController: UITableViewController {
    var todaysReps: [Exercice:[Rep]] = [Exercice:[Rep]]()
    var keys: [Exercice] = []
    let manager = DataManager.getInstance()
    let reuseIdentifier = "Cell"
    var day = NSDate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.backgroundColor = UserPrefs.getMainColor()
        self.refreshControl?.tintColor = UserPrefs.getTintColor()
        self.refreshControl?.addTarget(self, action: "loadData", forControlEvents: UIControlEvents.ValueChanged)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add Exercice", style: UIBarButtonItemStyle.Plain, target: self, action: "add_reps");
        title = "Today"
    }
    
    func loadData(){
        let muscle_groups = manager.loadAllMuscleGroups()
        todaysReps = [Exercice:[Rep]]()
        for mg in muscle_groups{
            let exercices = manager.loadExercicesFor(muscle_group: mg)
            for exercice in exercices{
                let reps = manager.loadAllRepsFor(exercice: exercice, date: day)
                if reps.count == 0{
                    continue
                }
                todaysReps[exercice] = reps
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
        
        // Configure the cell...
        let rep = todaysReps[keys[indexPath.section]]![indexPath.row]
        cell.textLabel?.text = "Reps: \(rep.num_reps!), Weight: \(manager.getRepWeightString(rep))"
        
        return cell
    }
    
    func add_reps(){
        performSegueWithIdentifier("Add", sender: self)
        //todo: send the date along with the segue so reps are added to the correct day.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destinationController = segue.destinationViewController as? MGSelectionController {
            destinationController.addDate = NSDate()
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return keys[section].name
    }
}
