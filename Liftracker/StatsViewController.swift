//
//  StatsViewController.swift
//  Liftracker
//
//  Created by John McAvey on 10/23/15.
//  Copyright © 2015 MCApps. All rights reserved.
//

import UIKit
import Charts

class StatsViewController: UITableViewController {

    let stats = ["Existing Maxes", "Estimated Max", "Workout Distribution"]
    let manager = DataManager.getInstance()
    
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
        if row == 2 {
            let destinationController = segue.destinationViewController as! PieChartViewController
            destinationController.pieData = pieData
            destinationController.data_changed = true
            destinationController.center_text = "Exercice Distribution\n\tby Muscle Group"
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row <= 1 {
            performSegueWithIdentifier("Max", sender: self)
        }
        else {
            performSegueWithIdentifier("groups", sender: self)
        }
    }
    
    func pieData() -> PieChartData {
        var reps = [BarChartDataEntry]()
        var xVals = [String]()
        var mgs = manager.loadAllMuscleGroups()
        for i in 0..<mgs.count {
            let mg = mgs[i]
            let predicate = NSPredicate(format: "exercice.muscle_group.name == '\(mg.name!)'")
            let count = manager.entityCount(entityType: "Rep", predicate: predicate) + manager.entityCount(entityType: "TimedRep", predicate: predicate)
            if count > 0 {
                reps.append(BarChartDataEntry(value: Double(count), xIndex: i))
                xVals.append(mg.name!)
            }
        }
        
        let dataSet = PieChartDataSet(yVals: reps, label: "Muscle Group Breakdown")
        dataSet.sliceSpace = 2.0
        dataSet.colors = manager.chartColors()
        
        let data = PieChartData(xVals: xVals, dataSet: dataSet)
        data.setValueFormatter(manager.percentNumberFormatter())
        data.setValueFont(UIFont(name: "HelveticaNeue-Light", size: 11.0))
        data.setValueTextColor(UIColor.blackColor())
        
        return data
    }
}
