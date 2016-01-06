//
//  MGSelectionController.swift
//  Liftracker
//
//  Created by John McAvey on 10/9/15.
//  Copyright © 2015 MCApps. All rights reserved.
//

import UIKit
import CoreData

class MGSelectionController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate {

    let managed_context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext;
    let search_controller = UISearchController(searchResultsController: nil)
    
    var muscle_group = [MuscleGroup]()
    var search_mg = [MuscleGroup]()
    var search_exercices = [Exercice]()
    
    var maxView: Bool = false
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
        if segue.identifier == "Select"{
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
            tableView.reloadData()
        }
    }
    
    func searching() -> Bool {
        return search_controller.active && search_controller.searchBar.text != ""
    }

}
