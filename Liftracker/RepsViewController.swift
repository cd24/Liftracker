//
//  RepsViewController.swift
//  Liftracker
//
//  Created by John McAvey on 10/11/15.
//  Copyright © 2015 MCApps. All rights reserved.
//

import UIKit

class RepsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    let managedContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext;
    var exercice: Exercice?
    
    var allReps = [NSDate: [Rep]]()
    var repKeys = [NSDate]()
    var updating = false
    var rowUpdating: NSIndexPath?
    let manager = DataManager.getInstance()
    var addDate: NSDate!
    var recognizer: UITapGestureRecognizer!
    @IBOutlet var tableView: UITableView?
    @IBOutlet var num_reps: UITextField?
    @IBOutlet var weight: UITextField?
    @IBOutlet var unit_label: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem]()
        self.navigationItem.rightBarButtonItems?.append(UIBarButtonItem(title: "Save", style: UIBarButtonItemStyle.Plain, target: self, action: "save_rep"))
        //let bars = UIImage(named: "data_bars.png")
        //self.navigationItem.rightBarButtonItems?.append(UIBarButtonItem(image: bars, landscapeImagePhone: bars, style: UIBarButtonItemStyle.Plain, target: self, action: "graph_view"))
        
        self.title = exercice?.name
        self.unit_label.text = UserPrefs.getUnitString()
        
        loadReps()
        sortKeys()
        configureTextFields()
        fillSuggestedData()
        tableView?.reloadData()
    }
    
    func loadReps() {
        repKeys = [NSDate]()
        allReps = [NSDate:[Rep]]()
        let repsTemp = manager.loadAllRepsFor(exercice: exercice!)
        print("Reps temp length: \(repsTemp.count)")
        for rep in repsTemp {
            let start = TimeManager.zeroDateTime(rep.date!)
            if repKeys.contains(start){
                allReps[start]!.append(rep)
            }
            else {
                allReps[start] = [rep]
                repKeys.append(start)
            }
        }
        print("repKeyCount: \(repKeys.count)")
    }
    
    func sortKeys() {
        repKeys.sortInPlace({(date1: NSDate, date2: NSDate) -> Bool in
            let before = date1.compare(date2)
            return before == NSComparisonResult.OrderedDescending
        })
    }
    
    func fillSuggestedData(){
        let repSuggestion = 10
        let tenMax = manager.estimatedMax(exercice!, reps: repSuggestion)
        weight?.text = "\(tenMax)"
        num_reps?.text = "\(repSuggestion)"
    }
    
    func configureTextFields(){
        num_reps?.delegate = self
        num_reps?.keyboardType = UIKeyboardType.DecimalPad
        weight?.delegate = self
        weight?.keyboardType = UIKeyboardType.DecimalPad
        
        recognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
    }
    
    func graph_view(){
        performSegueWithIdentifier("chart", sender: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return repKeys.count + 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if repKeys.count == 0 {
            return 1
        }
        if section == 0 {
            return 3
        }
        let reps = repKeys[section - 1]
        return allReps[reps]!.count
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        if repKeys.count == 0 {
            cell.textLabel?.text = "No Reps Found"
        }
        else {
            let section = indexPath.section
            
            if section == 0{
                if indexPath.row  == 0{
                    let roundedString = String(format: "%.2f", manager.estimatedMax(exercice!))
                cell.textLabel?.text = "Estimated ORM: \(roundedString) \(UserPrefs.getUnitString())"
                }
                else if indexPath.row == 1{
                    let roundedString = String(format: "%.2f", manager.estimatedMax(exercice!, reps: 5))
                    cell.textLabel?.text = "Estimated 5 Rep Max: \(roundedString)"
                }
                else if indexPath.row == 2{
                    let roundedString = String(format: "%.2f", manager.estimatedMax(exercice!, reps: 10))
                    cell.textLabel?.text = "Estimated 10 Rep Max: \(roundedString)"
                }
            }
            else {
                let key = repKeys[section - 1]
                let rep = allReps[key]![indexPath.row]
                cell.textLabel?.text = "Reps: \(rep.num_reps!), weight: \(manager.getRepWeightString(rep))"
            }

        }
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if allReps.keys.count == 0 {
            return ""
        }
        if section == 0{
            return "Estimated Max"
        }
        let key = repKeys[section - 1]
        return "\(TimeManager.dateToString(key))"
    }
    
    @IBAction func save_rep(){
        let manager = DataManager.getInstance()
        weight?.resignFirstResponder()
        num_reps?.resignFirstResponder()
        
        if let w = Double(weight!.text!) {
            if let r = Double(num_reps!.text!){
                if updating {
                    let repFromRowKey = repKeys[rowUpdating!.section - 1]
                    let repFromRow = allReps[repFromRowKey]![rowUpdating!.row]
                    repFromRow.num_reps = r
                    repFromRow.weight = w
                    manager.save_context()
                    tableView!.deselectRowAtIndexPath(rowUpdating!, animated: true)
                    updating = false
                }
                else{
                    var date = NSDate()
                    if let day = addDate {
                        date = day
                    }
                    let new_rep = manager.newRep(weight: w, repetitions: r, exercice: exercice!, date: date)
                    addRep(repetition: new_rep)
                }
                tableView?.reloadData()
            }
        }
    }
    
    func orderByDate(reps reps: [Rep]) -> [NSDate:[Rep]]{
        for rep in reps {
            addRep(repetition: rep)
        }
        return allReps
    }
    
    func addRep(repetition rep: Rep){
        let date = TimeManager.zeroDateTime(rep.date!)
        if allReps.keys.contains(date){
            allReps[date]?.append(rep)
        }
        else {
            allReps[date] = [rep]
            repKeys.append(date)
        }
        sortKeys()
    }
    
    // Override to support editing the table view.
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let key = repKeys[indexPath.section - 1]
            let rep = allReps[key]![indexPath.row]
            manager.deleteRep(rep)
            loadReps()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if allReps.count == 0 {
            return
        }
        if indexPath.section > 0 {
            updating = true
            rowUpdating = indexPath
            let repFromRowKey = repKeys[indexPath.section - 1]
            let repFromRow = allReps[repFromRowKey]![indexPath.row]
            self.weight?.text = "\(repFromRow.weight!.doubleValue)"
            self.num_reps?.text = "\(repFromRow.num_reps!.doubleValue)"
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
        if indexPath.row == tableView.indexPathForSelectedRow?.row && updating {
            updating = false
            
        }
        else {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        updating = false
    }
    
    func tableView(tableView: UITableView, canFocusRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return indexPath.section > 0
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return indexPath.section > 0
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        self.view.removeGestureRecognizer(recognizer)
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        self.view.addGestureRecognizer(recognizer)
        textField.selectAll(self)
    }
    
    func dismissKeyboard(){
        if weight!.isFirstResponder(){
            weight!.resignFirstResponder()
        }
        else if num_reps!.isFirstResponder(){
            num_reps!.resignFirstResponder()
        }
    }
}
