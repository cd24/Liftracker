//
//  MGSelectionController.swift
//  Liftracker
//
//  Created by John McAvey on 10/9/15.
//  Copyright © 2015 MCApps. All rights reserved.
//

import UIKit
import CoreData

class MGSelectionController: UITableViewController {

    let managed_context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext;
    var muscle_group: Array<MuscleGroup> = Array();
    var maxView: Bool = false
    var estimate: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Groups"
        
        //load exercices for function
        load_data()
        if (muscle_group.count == 0){
            load_data()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1;
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return muscle_group.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        // Configure the cell...
        cell.textLabel?.text = muscle_group[indexPath.row].name;

        return cell
    }
    
    func load_data(){
        let fetch_request = NSFetchRequest(entityName: "MuscleGroup");
        let order = NSSortDescriptor(key: "name", ascending: false)
        fetch_request.sortDescriptors?.append(order)
        
        do {
            let results = try managed_context.executeFetchRequest(fetch_request) as! Array<MuscleGroup>
            for result in results {
                muscle_group.append(result);
            }
        }
        catch {
            NSLog("An Error was thrown!");
        }
    }
    
    func addGroup(){
        //todo: implement
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let viewController = segue.destinationViewController as! ExerciceSelectorController;
        viewController.group = muscle_group[(tableView.indexPathForSelectedRow?.row)!]
        viewController.maxView = maxView
    }
    
    @IBAction func dismiss(){
        dismissViewControllerAnimated(true, completion: nil)
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
