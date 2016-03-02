//
//  MaxTableViewController.swift
//  Liftracker
//
//  Created by John McAvey on 10/23/15.
//  Copyright © 2015 John McAvey. All rights reserved.
//

import UIKit

class MaxTableViewController: UITableViewController {
    
    var exercice: Exercice?
    var results: [Int:Rep]?
    var keys: [Int] = []
    let manager = DataManager.getInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for key in results!.keys{
            keys.append(key)
        }
        
        keys = keys.sort()
        NSLog("\(keys)")
        
        title = "\(exercice!.name!) Max"
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        keys = []
        for key in results!.keys{
            keys.append(key)
        }
        
        keys = keys.sort()
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
        if keys.count > 0 {
            return results!.keys.count
        }
        return 1
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        // Configure the cell...
        if keys.count > 0 {
            NSLog("IndexPath.row: \(indexPath.row), key: \(self.keys[indexPath.row])")
            let rep = results![self.keys[indexPath.row]]
            cell.textLabel?.text = "Reps: \(rep!.num_reps!) \t Weight: \(rep!.weight!) \(UserPrefs.getUnitString())" //append weight units to the end of the string.
        }
        else {
            cell.textLabel?.text = "You haven't done this exercice yet!"
        }

        return cell
    }
}
