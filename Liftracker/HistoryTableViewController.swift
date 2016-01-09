//
//  HistoryTableViewController.swift
//  Liftracker
//
//  Created by John McAvey on 10/28/15.
//  Copyright © 2015 MCApps. All rights reserved.
//

import UIKit

class HistoryTableViewController: UITableViewController {
    
    var id: Int!
    var data: [Exercice:[Rep]]!
    var keys: [Exercice]!
    var day: NSDate!
    let manager = DataManager.getInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "Cell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if keys.count > 0{
            return keys.count + 1
        }
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if keys.count == 0 && section == 0{
            return 2;
        }
        else if section == 0{
            return 1;
        }
        let key = keys[section - 1]
        return data[key]!.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        if indexPath.section == 0 {
            if indexPath.row == 0{
                cell.textLabel?.text = TimeManager.dateToString(day)
                return cell
            }
            if keys.count == 0{
                if indexPath.row == 1 {
                    cell.textLabel?.text = "No data for today!"
                }
            }
        }
        else{
            let key = keys[indexPath.section - 1]
            let rep = data[key]![indexPath.row]
            cell.textLabel?.text = "Weight: \(rep.weight!), Num Reps: \(rep.num_reps!)"
        }

        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if keys.count > 0{
            if section == 0{
                return ""
            }
            return keys[section-1].name!
        }
        return ""
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}
