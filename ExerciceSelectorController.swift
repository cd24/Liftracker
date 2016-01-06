//
//  ExerciceSelectorController.swift
//  Liftracker
//
//  Created by John McAvey on 10/9/15.
//  Copyright © 2015 MCApps. All rights reserved.
//

import UIKit
import CoreData

class ExerciceSelectorController: UITableViewController, UISearchControllerDelegate, UISearchResultsUpdating {
    
    var exercices = [Exercice]()
    var filtered_exercices = [Exercice]()
    var group: MuscleGroup!
    var maxView: Bool?
    var addDate: NSDate!
    let managed_context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    let search_controller = UISearchController(searchResultsController: nil)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //load exercices for function
        load_data()
        self.title = group.name
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "addExercice");
        
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
        let selected_index = tableView.indexPathForSelectedRow!.row
        let selected_exercice = valueAtIndex(selected_index)
        
        if segue.identifier == "Max"{
            let destination = segue.destinationViewController as! MaxTableViewController
            destination.exercice = selected_exercice
            let reps = DataManager.getInstance().loadAllRepsFor(exercice: selected_exercice)
            destination.results = getMaxForAllReps(exercice: selected_exercice, reps: reps)
        }
        if segue.identifier == "AddExercice" {
            let destination = segue.destinationViewController as! ExerciceAdderViewController
            destination.tableView = self
            destination.currentGroup = group!
        }
        
        if segue.identifier == "Reps" {
            let destination = segue.destinationViewController as! RepsViewController;
            destination.exercice = exercices[tableView.indexPathForSelectedRow!.row];
            destination.addDate = addDate
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
            performSegueWithIdentifier("Reps", sender: self)
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func load_data(){
        exercices = DataManager.getInstance().loadExercicesFor(muscle_group: group)
    }
    
    func getMaxForAllReps(exercice ex: Exercice, reps: [Rep]) -> [Int:Rep]{
        let reps = DataManager.getInstance().loadAllRepsFor(exercice: ex)
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
}
