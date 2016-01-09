//
//  TodayViewController.swift
//  Liftracker
//
//  Created by John McAvey on 10/20/15.
//  Copyright © 2015 MCApps. All rights reserved.
//

import UIKit

class TodayViewController: UITableViewController {
    
    var todaysReps: [Exercice:[Rep]] = [Exercice:[Rep]]()
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
    }
    
    override func viewWillAppear(animated: Bool) {
        loadData()
    }
    
    func loadData(){
        let muscle_groups = manager.loadAllMuscleGroups()
        let today = NSDate()
        todaysReps = [Exercice:[Rep]]()
        keys = []
        for mg in muscle_groups{
            let exercices = manager.loadExercicesFor(muscle_group: mg)
            for exercice in exercices{
                let reps = manager.loadAllRepsFor(exercice: exercice, date: today)
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
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator

        return cell
    }
    
    @IBAction func add_reps(){
        performSegueWithIdentifier("Add", sender: self)
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return keys[section].name
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("Rep", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Rep" {
            let indexPath = tableView.indexPathForSelectedRow!
            let controller = segue.destinationViewController as! RepsViewController
            controller.exercice = keys[indexPath.section]
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }
}
