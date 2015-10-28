//
//  EstimatedMaxViewController.swift
//  Liftracker
//
//  Created by John McAvey on 10/24/15.
//  Copyright © 2015 MCApps. All rights reserved.
//

import UIKit

class EstimatedMaxViewController: UITableViewController {
    
    var mg: MuscleGroup?
    var exercices: [Exercice:Double] = [Exercice:Double]()
    var keys: [Exercice] = []
    let manager = DataManager.getInstance();


    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.backgroundColor = UIColor.whiteColor()//todo: Colors in preferences
        self.refreshControl?.tintColor = UIColor.blackColor()//todo: Colors in prefrences
        self.refreshControl?.addTarget(self, action: "loadData", forControlEvents: UIControlEvents.ValueChanged)
        loadData()
        
        title = "\(mg!.name!)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return keys.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! EstimateCell
        
        // Configure the cell...
        let exercice = keys[indexPath.row]
        let cellText: String
        if exercices.keys.contains(exercice){
            let max = exercices[exercice]
            let roundedDouble = String(format: "%.2f ", max!)
            cellText = roundedDouble + manager.getUnitString()
        }
        else {
            cellText = "No Data"
        }
        cell.leftText.text = "\(exercice.name!)"
        cell.rightText.text = cellText
        return cell
    }
    
    func loadData(){
        let manager = DataManager.getInstance()
        keys = []
        exercices = [Exercice:Double]()
        let ex = manager.loadExercicesFor(muscle_group: mg!)
        for exercice in ex {
            let reps = manager.loadAllRepsFor(exercice: exercice)
            if reps.count > 0{
                let max = manager.estimatedMax(exercice)
                exercices[exercice] = max
                keys.append(exercice)
            }
            else {
                keys.append(exercice)
            }
        }
        tableView.reloadData()
        self.refreshControl?.endRefreshing()
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
