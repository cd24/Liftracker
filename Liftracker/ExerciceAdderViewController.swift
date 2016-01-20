//
//  ExerciceAdderViewController.swift
//  Liftracker
//
//  Created by John McAvey on 10/10/15.
//  Copyright © 2015 MCApps. All rights reserved.
//

import UIKit

class ExerciceAdderViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, UIAlertViewDelegate {
    var groups: Array<MuscleGroup>?
    var tableView: ExerciceSelectorController?
    var currentGroup: MuscleGroup!
    var selectedIndex: Int = 0
    @IBOutlet var picker_view: UIPickerView!
    @IBOutlet var name_field: UITextField!
    @IBOutlet var timed_switch: UISwitch!
    
    let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        groups = DataManager.getInstance().loadAllMuscleGroups()
        
        picker_view.delegate = self
        picker_view.dataSource = self
        picker_view.reloadAllComponents()
        
        name_field.delegate = self
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: UIBarButtonItemStyle.Plain, target: self, action: "save");
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return groups!.count;
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if groups?.count <= row {
            return ""
        }
        return groups![row].name;
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedIndex = row;
    }
    
    func save(){
        if (!validData()){
            let alert = UIAlertController(title: "Invalid Data", message: "The data you entered either exists already or is empty.  Please enter a value which is not already entered to save", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK!", style: UIAlertActionStyle.Cancel, handler: {action in
                self.dismissViewControllerAnimated(true, completion: nil)
            }))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        let new_exercice = NSEntityDescription.insertNewObjectForEntityForName("Exercice", inManagedObjectContext: context) as! Exercice
        new_exercice.name = name_field?.text
        new_exercice.muscle_group = groups![selectedIndex]
        new_exercice.isTimed = timed_switch.on
        do{
            try context.save()
        }
        catch{}
        
        tableView!.load_data()
        tableView!.tableView.reloadData()
        dismissViewControllerAnimated(false, completion: nil)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func validData() -> Bool{
        /*let exercices = DataManager.getInstance().loadExercicesFor(muscle_group: groups![selectedIndex])
        for exercice in exercices {
            if exercice.name! == name_field.text! {
                return false
            }
        } */
        let predicate = NSPredicate(format: "name == '%@' AND muscle_group == '%@'", name_field.text!, groups![selectedIndex].name!)
        return name_field?.text != "" && DataManager.getInstance().entityCount(entityType: "Exercice", predicate: predicate) == 0
    }
    
    @IBAction func dismiss(){
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.selectAll(self)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
