//
//  WorkoutsTableViewController.swift
//  
//
//  Created by John McAvey on 3/21/16.
//
//

import UIKit
import CocoaLumberjack

class WorkoutsTableViewController: UITableViewController {
    
    let manager = DataManager.getInstance()
    var workouts = [Workout]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let add_button = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: #selector(add_workout))
        self.navigationItem.rightBarButtonItems = [add_button]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadWorkouts() {
        self.workouts = manager.getEntities(.Workout) as! [Workout]
        self.tableView.reloadData()
    }
    
    
    @IBAction func add_workout(item: UIBarButtonItem) {
        DDLogInfo("Add Workout")
        performSegueWithIdentifier("addWorkout", sender: self)
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workouts.count
    }

}
