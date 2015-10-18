//
//  RepsViewController.swift
//  Liftracker
//
//  Created by John McAvey on 10/11/15.
//  Copyright © 2015 MCApps. All rights reserved.
//

import UIKit

class RepsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let managedContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext;
    var exercice: Exercice?
    
    var repsTemp: [Rep] = []
    var allReps = [String: [Rep]]()
    var repKeys = [String]()
    var updating = false
    var rowUpdating: NSIndexPath?
    @IBOutlet var tableView: UITableView?
    @IBOutlet var num_reps: UITextField?
    @IBOutlet var weight: UITextField?
    @IBOutlet var weight_stepper: UIStepper?
    @IBOutlet var rep_stepper: UIStepper?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: UIBarButtonItemStyle.Plain, target: self, action: "save_rep");
        repsTemp = DataManager.getInstance().loadAllRepsFor(exercice: exercice!)
        self.title = exercice?.name

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return allReps.keys.count
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0){
            return 1
        }
        let key = repKeys[section]
        return allReps[key]!.count
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        let key = repKeys[indexPath.section]
        let rep = allReps[key]![indexPath.row]
        cell.textLabel?.text = "Reps: \(rep.num_reps!), weight: \(rep.weight!)"

        return cell
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        //put info in the text fiels, perform update instead of save
        updating = true
        rowUpdating = indexPath
    }
    
    func tableView(tableView: UITableView, willDeselectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        //remove updating status
        updating = false
        return indexPath
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "\(repKeys[section])"
    }
    
    func save_rep(){
        let manager = DataManager.getInstance()
        if let w = Int(weight!.text!) {
            if let r = Int(num_reps!.text!){
                let new_rep = manager.newRep(weight: w, repetitions: r)
                addRep(repetition: new_rep)
                tableView!.reloadData()
                manager.save_context()
            }
        }
    }
    
    func orderByDate(reps reps: [Rep]) -> [String:[Rep]]{
        for rep in reps {
            addRep(repetition: rep)
        }
        return allReps
    }
    
    func addRep(repetition rep: Rep){
        let date = rep.day!.date!
        if allReps.keys.contains(date){
            allReps[date]?.append(rep)
        }
        else {
            allReps[date] = [rep]
            repKeys.append(date)
        }
    }

    
    // Override to support conditional editing of the table view.
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            let key = repKeys[indexPath.section]
            allReps[key]!.removeAtIndex(indexPath.row)
            if (allReps[key]!.count == 0){
                allReps.removeValueForKey(key)
                repKeys.removeAtIndex(indexPath.section)
            }
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

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
