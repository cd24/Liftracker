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
        self.title = "Stats"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        let row = tableView.indexPathForSelectedRow!.row
        if row == 0{
            let destinationController = segue.destinationViewController as! MGSelectionController
            destinationController.estimate = false
            destinationController.maxView = true
        }
        if row == 1 {
            let destinationController = segue.destinationViewController as! MGSelectionController
            destinationController.maxView = false
            destinationController.estimate = true
        }
        else {
            let destinationController = segue.destinationViewController as! ChartViewController;
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row <= 1 {
            performSegueWithIdentifier("Max", sender: self)
        }
        else {
            performSegueWithIdentifier("chart", sender: self)
        }
    }
}
