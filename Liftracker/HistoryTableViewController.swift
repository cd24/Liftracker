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
    var parent: HistoryViewController!
    
    init(style: UITableViewStyle, parent: HistoryViewController) {
        super.init(style: style)
        self.parent = parent
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
            return 1;
        }
        else if section == 0{
            return 1;
        }
        let key = keys[section - 1]
        return data[key]!.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let title = TimeManager.dateToString(day)
        if keys.count == 0{
            return getHeadCell(tableView, indexPath: indexPath, title: title)
        }
        if indexPath.section == 0 {
            return getHeadCell(tableView, indexPath: indexPath, title: title)
        }
        else{
            let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
            let key = keys[indexPath.section - 1]
            let rep = data[key]![indexPath.row]
            cell.textLabel?.text = "Weight: \(rep.weight!), Num Reps: \(rep.num_reps!)"
            return cell
        }
    }
    
    func getHeadCell(tableView: UITableView, indexPath: NSIndexPath, title: String) -> HeadCell {
        let cl = tableView.dequeueReusableCellWithIdentifier("headCell", forIndexPath: indexPath) as! HeadCell
        cl.label.text = title
        cl.forward.addTarget(parent, action: "shiftForward", forControlEvents: UIControlEvents.TouchDown)
        cl.backward.addTarget(parent, action: "shiftBackward", forControlEvents: UIControlEvents.TouchDown)
        return cl
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
