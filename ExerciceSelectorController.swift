//
//  ExerciceSelectorController.swift
//  Liftracker
//
//  Created by John McAvey on 10/9/15.
//  Copyright © 2015 MCApps. All rights reserved.
//

import UIKit
import Charts

class ExerciceSelectorController: UITableViewController, UISearchControllerDelegate, UISearchResultsUpdating {
    
    var exercices = [Exercice]()
    var filtered_exercices = [Exercice]()
    var group: MuscleGroup!
    var maxView: Bool?
    var addDate: NSDate!
    let manager = DataManager.getInstance()
    let search_controller = UISearchController(searchResultsController: nil)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //load exercices for function
        load_data()
        self.title = group.name
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "addExercice");
        let barImage = UIImage(named: "data_bars.png")
        self.navigationItem.rightBarButtonItems?.append(UIBarButtonItem(image: barImage, style: UIBarButtonItemStyle.Plain, target: self, action: "graph_view"))
        
        //configure search controller
        search_controller.searchResultsUpdater = self
        search_controller.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        self.tableView.tableHeaderView = search_controller.searchBar
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching() {
            return filtered_exercices.count
        }
        return exercices.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        cell.textLabel?.text = searching() ?
                                filtered_exercices[indexPath.row].name :
                                exercices[indexPath.row].name
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "graph" {
            let destinationController = segue.destinationViewController as! PieChartViewController
            destinationController.pieData = mgPieInfo
            destinationController.data_changed = true
            return
        }
        if segue.identifier == "AddExercice" {
            let destination = segue.destinationViewController as! ExerciceAdderViewController
            destination.tableView = self
            //destination.currentGroup = group!
            return
        }
        
        //otherwise its a tableview move
        let selected_index = tableView.indexPathForSelectedRow!.row
        let selected_exercice = valueAtIndex(selected_index)
        
        if segue.identifier == "Max"{
            let destination = segue.destinationViewController as! MaxTableViewController
            destination.exercice = selected_exercice
            let reps = DataManager.getInstance().loadAllRepsFor(exercice: selected_exercice)
            destination.results = getMaxForAllReps(exercice: selected_exercice, reps: reps)
        }
        if segue.identifier == "Reps" {
            let destination = segue.destinationViewController as! RepsViewController
            destination.exercice = exercices[tableView.indexPathForSelectedRow!.row]
            destination.addDate = addDate
        }
        if segue.identifier == "timed" {
            let destination = segue.destinationViewController as! TimedRepViewController
            destination.exercice = exercices[tableView.indexPathForSelectedRow!.row]
        }
    }
    
    func addExercice() {
        performSegueWithIdentifier("AddExercice", sender: self)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if maxView! {
            performSegueWithIdentifier("Max", sender: self)
        }
        else {
            let exercice = exercices[indexPath.row]
            if exercice.isTimed!.boolValue {
                performSegueWithIdentifier("timed", sender: self)
            }
            else{
                performSegueWithIdentifier("Reps", sender: self)
            }
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func load_data(){
        exercices = manager.loadExercicesFor(muscle_group: group)
    }
    
    func getMaxForAllReps(exercice ex: Exercice, reps: [Rep]) -> [Int:Rep]{
        let reps = manager.loadAllRepsFor(exercice: ex)
        var map = [Int:Rep]()
        for rep in reps {
            let (weight, num_reps) = intValues(rep)
            if weight > map[num_reps]?.weight?.integerValue {
                map[num_reps] = rep
            }
            else {
                map[num_reps] = rep
            }
        }
        
        return map
    }
    
    func intValues(rep: Rep) -> (Int, Int){
        return (rep.weight!.integerValue, rep.num_reps!.integerValue)
    }

    //MARK: - search controller 
    
    func filterForSearchText(search_text: String, scope: String = "All") {
        let search = search_text.uppercaseString
        filtered_exercices = exercices.filter { exercice in
            let name = exercice.name?.uppercaseString
            return name!.containsString(search)
        }
        
        tableView.reloadData()
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let text = searchController.searchBar.text!
        filterForSearchText(text)
    }
    
    func searching() -> Bool {
        return search_controller.active && search_controller.searchBar.text != ""
    }
    
    func valueAtIndex(index: Int) -> Exercice {
        return searching() ? filtered_exercices[index] : exercices[index]
    }
    
    //MARK: - Pie Data Generator
    
    func mgPieInfo() -> PieChartData {
        var reps = [BarChartDataEntry]()
        var xVals = [String]()
        var exercices = manager.loadExercicesFor(muscle_group: group)
        for i in 0..<exercices.count {
            let exercice = exercices[i]
            let predicate = NSPredicate(format: "exercice.name == '\(exercice.name!)'")
            let count = manager.entityCount(entityType: "Rep", predicate: predicate)
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
    
    func graph_view() {
        performSegueWithIdentifier("graph", sender: self)
    }
}
