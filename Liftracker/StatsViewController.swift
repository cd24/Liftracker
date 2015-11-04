//
//  StatsViewController.swift
//  Liftracker
//
//  Created by John McAvey on 10/23/15.
//  Copyright © 2015 MCApps. All rights reserved.
//

import UIKit

class StatsViewController: UITableViewController {

    let stats = ["Existing Maxes", "Estimated Max"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Stats"
        
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

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stats.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        cell.textLabel?.text = stats[indexPath.row]
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator

        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destinationController = segue.destinationViewController as! MGSelectionController
        let row = tableView.indexPathForSelectedRow!.row
        if row == 0{
            destinationController.estimate = false
            destinationController.maxView = true
        }
        if row == 1 {
            destinationController.maxView = false
            destinationController.estimate = true
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("Max", sender: self)
    }
}
