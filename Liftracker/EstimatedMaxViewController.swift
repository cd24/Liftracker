//
//  EstimatedMaxViewController.swift
//  Liftracker
//
//  Created by John McAvey on 10/24/15.
//  Copyright © 2015 MCApps. All rights reserved.
//

import UIKit

class EstimatedMaxViewController: UITableViewController {
    
    var mg: MuscleGroup?
    var exercices: [Exercice:Double] = [Exercice:Double]()
    var keys: [Exercice] = []
    let manager = DataManager.getInstance();

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.backgroundColor = UserPrefs.getMainColor()
        self.refreshControl?.tintColor = UserPrefs.getTintColor()
        self.refreshControl?.addTarget(self, action: "loadData", forControlEvents: UIControlEvents.ValueChanged)
        loadData()
        
        title = "\(mg!.name!)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return keys.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! EstimateCell
        
        // Configure the cell...
        let exercice = keys[indexPath.row]
        let cellText: String
        if exercices.keys.contains(exercice){
            let max = exercices[exercice]
            let roundedDouble = String(format: "%.2f ", max!)
            cellText = roundedDouble + UserPrefs.getUnitString()
        }
        else {
            cellText = "No Data"
        }
        cell.leftText.text = "\(exercice.name!)"
        cell.rightText.text = cellText
        return cell
    }
    
    func loadData(){
        let manager = DataManager.getInstance()
        keys = []
        exercices = [Exercice:Double]()
        let ex = manager.loadExercicesFor(muscle_group: mg!)
        for exercice in ex {
            let reps = manager.loadAllRepsFor(exercice: exercice)
            if reps.count > 0{
                let max = manager.estimatedMax(exercice)
                exercices[exercice] = max
                keys.append(exercice)
            }
            else {
                keys.append(exercice)
            }
        }
        tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }
}
