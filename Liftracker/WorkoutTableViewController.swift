//
//  WorkoutTableViewController.swift
//  Liftracker
//
//  Created by John McAvey on 2/26/17.
//  Copyright © 2017 John McAvey. All rights reserved.
//

import UIKit

class WorkoutTableViewController: UITableViewController {

    var todaysWorkouts: [Workout] = []
    var allWorkouts: [Workout] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addWorkout))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return todaysWorkouts.count > 0 ? 2 : 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
        case 0:
            return todaysWorkouts.count > 0 ? todaysWorkouts.count : allWorkouts.count
        case 1:
            return allWorkouts.count
        default:
            return 0
        }
    }
    
    func setupMemory(for objects: [Workout]) {
        allWorkouts = objects
        todaysWorkouts = objects.filter { Schedule(num: $0.schedule).active() }
    }
    
    func updateData() {
        CoreDataManager.shared.getEntities(of: Workout.self)
        .then(execute: setupMemory)
        .catch {
            // TODO: Display an error of some kind to the user
            log.error("Unable to update workout information. Encountered error:")
            log.error($0)
        }
    }
    
    func addWorkout() {
        self.performSegue(withIdentifier: "add", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "start" {
            // Prepare destination
            // TODO
        }
    }
}
