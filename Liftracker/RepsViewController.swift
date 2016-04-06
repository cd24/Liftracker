//
//  RepsViewController.swift
//  Liftracker
//
//  Created by John McAvey on 10/11/15.
//  Copyright © 2015 John McAvey. All rights reserved.
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
    var prev_weight = "",
        prev_reps = ""
    @IBOutlet var tableView: UITableView?
    @IBOutlet var num_reps: UITextField?
    @IBOutlet var weight: UITextField?
    @IBOutlet var unit_label: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem]()
        self.navigationItem.rightBarButtonItems?.append(UIBarButtonItem(title: "Save", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(save_rep)))
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
        let repsTemp = manager.loadAllWeightedRepsFor(exercice: exercice!)
        for rep in repsTemp {
            let start = TimeManager.zeroDateTime(rep.start_time!)
            if repKeys.contains(start){
                allReps[start]!.append(rep)
            }
            else {
                allReps[start] = [rep]
                repKeys.append(start)
            }
        }
    }
    
    func sortKeys() {
        repKeys.sortInPlace({(date1: NSDate, date2: NSDate) -> Bool in
            let before = date1.compare(date2)
            return before == NSComparisonResult.OrderedDescending
        })
    }
    
    func fillSuggestedData(){
        //TODO: Find a way to suggest the number of reps
        let repSuggestion = 10.0
        let tenMax = StatCalculator.estimatedMax(exercice!, reps: repSuggestion)
        weight?.text = String(format: "%.02f", tenMax)
        num_reps?.text = "\(repSuggestion)"
        
        prev_weight = weight!.text!
        prev_reps = num_reps!.text!
    }
    
    func configureTextFields(){
        num_reps?.delegate = self
        num_reps?.keyboardType = UIKeyboardType.DecimalPad
        weight?.delegate = self
        weight?.keyboardType = UIKeyboardType.DecimalPad
        
        recognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
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
        return repKeys.count
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if repKeys.count == 0 {
            return 1
        }
        let reps = repKeys[section]
        return allReps[reps]!.count
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        if repKeys.count == 0 {
            cell.textLabel?.text = "No reps found for this exercice"
        }
        else {
            let section = indexPath.section
            let key = repKeys[section]
            let rep = allReps[key]![indexPath.row] as!WeightRep
            cell.textLabel?.text = "Reps: \(rep.reps!), weight: \(manager.getRepWeightString(rep))"
        }
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if repKeys.count == 0 {
            return ""
        }
        let key = repKeys[section]
        return "\(TimeManager.dateToString(key))"
    }
    
    func save_rep(){
        let manager = DataManager.getInstance()
        weight?.resignFirstResponder()
        num_reps?.resignFirstResponder()
        if let w = Double(weight!.text!) {
            if let r = Double(num_reps!.text!){
                if updating {
                    let repFromRowKey = repKeys[rowUpdating!.section]
                    let repFromRow = allReps[repFromRowKey]![rowUpdating!.row] as! WeightRep
                    repFromRow.reps = r
                    repFromRow.weight = w
                    manager.save_context()
                    tableView!.deselectRowAtIndexPath(rowUpdating!, animated: true)
                    updating = false
                    tableView?.reloadData()
                }
                else{
                    var date = NSDate()
                    if let day = addDate {
                        date = day
                    }
                    let new_rep = manager.newWeightedRep(weight: w, repetitions: r, exercice: exercice!, date: date)
                    addRep(repetition: new_rep)
                    let sod = TimeManager.zeroDateTime(date)
                    let section = repKeys.indexOf(sod)!
                    let indexPath = NSIndexPath(forRow: 0, inSection: section)
                    
                    if allReps[repKeys[section]]!.count == 1 {
                        tableView?.insertSections(NSIndexSet(index: section), withRowAnimation: .Right)
                    }
                    else {
                        tableView?.beginUpdates()
                        tableView?.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Right)
                        tableView?.endUpdates()
                    }
                }
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
        let date = TimeManager.zeroDateTime(rep.start_time!)
        if allReps.keys.contains(date){
            allReps[date]?.insert(rep, atIndex: 0)
        }
        else {
            allReps[date] = [rep]
            repKeys.append(date)
            sortKeys()
        }
    }
    
    // Override to support editing the table view.
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let key = repKeys[indexPath.section]
            let rep = allReps[key]![indexPath.row]
            manager.deleteRep(rep)
            allReps[key]!.removeAtIndex(indexPath.row)
            loadReps()
            if let _ = allReps[key]{
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Left)
            }
            else {
                tableView.deleteSections(NSIndexSet(index: indexPath.section), withRowAnimation: .Left)
            }
            updating = false
        }
        
        if editingStyle == .Insert {
            print("In the insert call")
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if allReps.count == 0 {
            return
        }
        if !updating {
            updating = true
            rowUpdating = indexPath
            let repFromRowKey = repKeys[indexPath.section]
            let repFromRow = allReps[repFromRowKey]![indexPath.row] as! WeightRep
            self.weight?.text = "\(repFromRow.getWeight())"
            self.num_reps?.text = "\(repFromRow.getReps())"
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
        if indexPath.row == tableView.indexPathForSelectedRow?.row && updating {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            
        }
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        updating = false
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField.text!.characters.count == 0{
            if textField == weight {
                weight!.text = "\(prev_weight)"
            }
            if textField == num_reps {
                num_reps!.text = "\(prev_reps)"
            }
        }
        
        self.view.removeGestureRecognizer(recognizer)
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField == weight {
            prev_weight = "\(textField.text!)"
        }
        else {
            prev_reps = "\(textField.text!)"
        }
        self.view.addGestureRecognizer(recognizer)
        textField.selectAll(self)
        textField.text = ""
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
