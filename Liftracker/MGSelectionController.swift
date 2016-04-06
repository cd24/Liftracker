//
//  MGSelectionController.swift
//  Liftracker
//
//  Created by John McAvey on 10/9/15.
//  Copyright © 2015 John McAvey. All rights reserved.
//

import UIKit
import Charts
import CoreData

class MGSelectionController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate {

    let managed_context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext;
    let search_controller = UISearchController(searchResultsController: nil)
    let manager = DataManager.getInstance()
    
    var muscle_group = [MuscleGroup]()
    var search_mg = [MuscleGroup]()
    var search_exercices = [Exercice]()
    var viewing: MuscleGroup!
    
    var maxView: Bool = false
    var distribution_view = false
    var addDate: NSDate!
    var estimate: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Groups"
        
        //load exercices for function
        muscle_group = DataManager.getInstance().loadAllMuscleGroups()
        
        //setup search controller
        search_controller.searchResultsUpdater = self
        search_controller.searchBar.delegate = self
        search_controller.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = search_controller.searchBar
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return searching() ? 2 : 1;
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching(){
            return section == 0 ? search_mg.count : search_exercices.count
        }
        return muscle_group.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        if searching() {
            cell.textLabel?.text = indexPath.section == 0 ?
                                    search_mg[indexPath.row].name :
                                    search_exercices[indexPath.row].name
        }
        else {
            cell.textLabel?.text = muscle_group[indexPath.row].name;
        }

        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if searching() {
            return section == 0 ? "Muscle Groups" : "Exercices"
        }
        return ""
    }
    
    func addGroup(){
        //todo: implement
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "distribution" {
            let dest_controller = segue.destinationViewController as! PieChartViewController
            if searching() {
                viewing = search_mg[tableView.indexPathForSelectedRow!.row]
            }
            else {
                viewing = muscle_group[tableView.indexPathForSelectedRow!.row]
            }
            dest_controller.pieData = mgPieInfo
            dest_controller.data_changed = true
            dest_controller.center_text = "Repetition Distribution\n\tby Exercice"
            dest_controller.title = viewing.name!
        }
        else if segue.identifier == "Select"{
            let viewController = segue.destinationViewController as! ExerciceSelectorController;
            viewController.group = muscle_group[tableView.indexPathForSelectedRow!.row]
            viewController.maxView = maxView
            viewController.addDate = addDate
        }
        else if segue.identifier == "Max"{
            let viewController = segue.destinationViewController as! EstimatedMaxViewController
            viewController.mg = muscle_group[tableView.indexPathForSelectedRow!.row]
        }
        else if segue.identifier == "reps" {
            let dest_controller = segue.destinationViewController as! RepsViewController
            dest_controller.exercice = search_exercices[tableView.indexPathForSelectedRow!.row]
            dest_controller.addDate = addDate
        }
    }
    
    @IBAction func dismiss(){
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {
            if estimate {
                performSegueWithIdentifier("Max", sender: self)
            }
            else if distribution_view {
                performSegueWithIdentifier("distribution", sender: self)
            }
            else {
                performSegueWithIdentifier("Select", sender: self)
            }
        }
        else if indexPath.section == 1 {
            performSegueWithIdentifier("reps", sender: self)
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    // MARK: - Search control
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        search_controller.active = false
        tableView.reloadData()
    }
    
    func groupsMatchingSearch(text: String, context: String = "All") {
        search_mg = muscle_group.filter { mg in
            return mg.name!.containsString(text)
        }
    }
    
    func exercicesMatchingSearch(text: String, context: String = "All"){
        search_exercices = DataManager.getInstance().searchExercicesForSubstring(text)
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let text = searchController.searchBar.text!
        if text != "" {
            groupsMatchingSearch(text)
            exercicesMatchingSearch(text)
        }
        tableView.reloadData()
    }
    
    func searching() -> Bool {
        return search_controller.active && search_controller.searchBar.text != ""
    }
    
    func mgPieInfo() -> PieChartData {
        var reps = [BarChartDataEntry]()
        var xVals = [String]()
        var exercices: [AnyObject] = manager.loadExercicesFor(muscle_group: viewing)
        
        for i in 0..<exercices.count {
            let exercice = exercices[i]
            let predicate = NSPredicate(format: "exercice.name == '\(exercice.name!)'")
            let count = manager.entityCount(entityType: .WeightRep, predicate: predicate) +
                        manager.entityCount(entityType: .TimedRep, predicate: predicate)
            if count > 0 {
                reps.append(BarChartDataEntry(value: Double(count), xIndex: i))
                xVals.append(exercice.name!)
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
