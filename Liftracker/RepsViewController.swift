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
    
    var repsTemp: [Rep] = []
    var allReps = [String: [Rep]]()
    var repKeys = [String]()
    var updating = false
    var rowUpdating: NSIndexPath?
    let manager = DataManager.getInstance()
    var addDate: NSDate!
    var recognizer: UITapGestureRecognizer!
    @IBOutlet var tableView: UITableView?
    @IBOutlet var num_reps: UITextField?
    @IBOutlet var weight: UITextField?
    @IBOutlet var weight_stepper: UIStepper!
    @IBOutlet var rep_stepper: UIStepper!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: UIBarButtonItemStyle.Plain, target: self, action: "save_rep");
        repsTemp = DataManager.getInstance().loadAllRepsFor(exercice: exercice!)
        self.title = exercice?.name
        
        for rep in repsTemp {
            if allReps.keys.contains(rep.date!){
                allReps[rep.date!]!.append(rep)
            }
            else {
                allReps[rep.date!] = [rep]
                repKeys.append(rep.date!)
            }
        }
        
        configureSteppers()
        configureTextFields()
        fillSuggestedData()
        repKeys.sortInPlace({(ele1: String, ele2: String) -> Bool in
            let formatter = NSDateFormatter()
            formatter.locale = NSLocale.systemLocale()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
            let date1 = formatter.dateFromString(ele1)
            let date2 = formatter.dateFromString(ele2)
            if date1 == nil || date2 == nil{
                return false
            }
            let before = date1!.compare(date2!)
            NSLog("val: \(before.rawValue), descending: \(NSComparisonResult.OrderedDescending.rawValue)")
            return before == NSComparisonResult.OrderedDescending
        })
        tableView?.reloadData()
    }
    
    func fillSuggestedData(){
        let repSuggestion = 10
        let tenMax = manager.estimatedMax(exercice!, reps: repSuggestion)
        weight?.text = "\(tenMax)"
        num_reps?.text = "\(repSuggestion)"
        rep_stepper.value = Double(repSuggestion)
    }
    
    func configureSteppers(){
        repKeys.sortInPlace()
        weight_stepper.minimumValue = 0
        weight_stepper.maximumValue = Double.infinity
        rep_stepper.minimumValue = 0
        rep_stepper.maximumValue = Double.infinity
        rep_stepper.stepValue = 1
        weight_stepper.stepValue = 2.5
    }
    
    func configureTextFields(){
        num_reps?.delegate = self
        num_reps?.keyboardType = UIKeyboardType.DecimalPad
        weight?.delegate = self
        weight?.keyboardType = UIKeyboardType.DecimalPad
        
        recognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if allReps.keys.count == 0 {
            return 1
        }
        return allReps.keys.count + 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if allReps.keys.count == 0 {
            return 1
        }
        if section > 0{
            let key = repKeys[section - 1]
            return allReps[key]!.count
        }
        return 3
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        if allReps.keys.count == 0 {
            cell.textLabel?.text = "No Reps Found"
        }
        else {
            if indexPath.section == 0{
                
                if indexPath.row  == 0{
                    let roundedString = String(format: "%.2f", manager.estimatedMax(exercice!))
                cell.textLabel?.text = "Estimated ORM: \(roundedString) \(manager.getUnitString())"
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
                let key = repKeys[indexPath.section - 1]
                let rep = allReps[key]![indexPath.row]
                cell.textLabel?.text = "Reps: \(rep.num_reps!), weight: \(manager.getRepWeightString(rep))"
            }
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        //put info in the text fiels, perform update instead of save
        updating = true
        rowUpdating = indexPath
    }
    
    func tableView(tableView: UITableView, willDeselectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        //remove updating status
        updating = false
        return indexPath
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if allReps.keys.count == 0 {
            return ""
        }
        if section == 0{
            return "Estimated Max"
        }
        let key = repKeys[section - 1]
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        let date = formatter.dateFromString(key)
        let formattedString = DataManager.getInstance().dateToString(date!)
        return "\(formattedString)"
    }
    
    @IBAction func save_rep(){
        let manager = DataManager.getInstance()
        weight?.resignFirstResponder()
        num_reps?.resignFirstResponder()
        if let w = Double(weight!.text!) {
            if let r = Double(num_reps!.text!){
                if addDate == nil{
                    addDate = NSDate()
                }
                let new_rep = manager.newRep(weight: w, repetitions: r, exercice: exercice!, date: addDate)
                addRep(repetition: new_rep)
                tableView!.reloadData()
            }
        }
    }
    
    func orderByDate(reps reps: [Rep]) -> [String:[Rep]]{
        for rep in reps {
            addRep(repetition: rep)
        }
        return allReps
    }
    
    func addRep(repetition rep: Rep){
        let date = rep.date!
        if allReps.keys.contains(date){
            allReps[date]?.append(rep)
        }
        else {
            allReps[date] = [rep]
            repKeys.append(date)
        }
        repKeys.sortInPlace({(ele1: String, ele2: String) -> Bool in
            let formatter = NSDateFormatter()
            formatter.locale = NSLocale.systemLocale()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
            let date1 = formatter.dateFromString(ele1)
            let date2 = formatter.dateFromString(ele2)
            if date1 == nil || date2 == nil{
                return false
            }
            let before = date1!.compare(date2!)
            return before == NSComparisonResult.OrderedAscending ? false: true
        })
    }

    
    // Override to support conditional editing of the table view.
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            let key = repKeys[indexPath.section]
            allReps[key]!.removeAtIndex(indexPath.row)
            if (allReps[key]!.count == 0){
                allReps.removeValueForKey(key)
                repKeys.removeAtIndex(indexPath.section)
            }
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    @IBAction func valueChanged(sender: UIStepper){
        if sender == rep_stepper {
            num_reps?.text = "\(sender.value)"
        }
        else if sender == weight_stepper{
            weight?.text = "\(sender.value)"
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField == weight!{
            if let value = Double(weight!.text!){
                weight_stepper.value = value
            }
            else {
                weight_stepper.value = 0
            }
        }
        else if textField == num_reps!{
            if let value = Double(num_reps!.text!){
                rep_stepper.value = value
            }
            else {
                rep_stepper.value = 0
            }
        }
        
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
