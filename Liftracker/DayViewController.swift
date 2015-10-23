//
//  HistoryViewController.swift
//  Liftracker
//
//  Created by John McAvey on 10/23/15.
//  Copyright © 2015 MCApps. All rights reserved.
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
        self.refreshControl?.backgroundColor = UIColor.whiteColor()//todo: Colors in preferences
        self.refreshControl?.tintColor = UIColor.blackColor()//todo: Colors in prefrences
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
        // #warning Incomplete implementation, return the number of sections
        return todaysReps.keys.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return todaysReps[keys[section]]!.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath)
        
        // Configure the cell...
        let rep = todaysReps[keys[indexPath.section]]![indexPath.row]
        cell.textLabel?.text = "Weight: \(rep.weight!), Reps: \(rep.num_reps!)"
        
        return cell
    }
    
    @IBAction func add_reps(){
        performSegueWithIdentifier("Add", sender: self)
        //todo: send the date along with the segue so reps are added to the correct day.
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return keys[section].name
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the specified item to be editable.
    return true
    }
    */
    
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
    // Delete the row from the data source
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }
    */
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the item to be re-orderable.
    return true
    }
    */
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */


}
