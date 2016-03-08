//
//  ExerciceAdderViewController.swift
//  Liftracker
//
//  Created by John McAvey on 10/10/15.
//  Copyright © 2015 John McAvey. All rights reserved.
//

import UIKit
import XLForm

class ExerciceAdderViewController: XLFormViewController {
    var groups: Array<MuscleGroup>?
    var currentGroup: MuscleGroup!
    var selectedIndex: Int = 0
    
    let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    let manager = DataManager.getInstance()
    var name_row, exercice_row, timed_row: XLFormRowDescriptor!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        form = getForm()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: UIBarButtonItemStyle.Plain, target: self, action: "save");
        title = "Add Exercice"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func save(){
        
        let values = formValues()
        let name = values["name"] as! String
        let mg = manager.mgForName(values["group"] as! String)
        let isTimed = values["timed"]!.boolValue
        if valid(mg!, name: name) {
            manager.newExercice(name: name, muscle_group: mg!, isTimed: isTimed)
            self.navigationController?.popViewControllerAnimated(true)
        }
        else {
            let alert = UIAlertController(title: "Existing Exercice", message: "You already have an exercice named \(name) in \(mg!.name!).  Change the muscle group or name to add this exercice.  If you need, return to the muscle group selector page to search for the exercice", preferredStyle: UIAlertControllerStyle.Alert)
            let accept = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
            alert.addAction(accept)
            presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func getForm() -> XLFormDescriptor {
        let descriptor = XLFormDescriptor(title: "Add Exercice")
        let filler = XLFormSectionDescriptor()
        descriptor.addFormSection(filler)
        let section = XLFormSectionDescriptor()
        section.title = "Add Exercice"
        name_row = XLFormRowDescriptor(tag: "name", rowType: XLFormRowDescriptorTypeText, title: "Name:")
        name_row.value = "Exercise Name"
        name_row.addValidator(nameValidator())
        section.addFormRow(name_row)
        
        exercice_row = XLFormRowDescriptor(tag: "group", rowType: XLFormRowDescriptorTypeSelectorPush, title: "Muscle Group: ")
        let vals = manager.loadAllMuscleGroups().map { mg in
            return mg.name!
        }
        
        exercice_row.addValidator(nonEmptyValidator())
        exercice_row.selectorOptions = vals
        exercice_row.value = currentGroup.name!
        //exercice_row.select(currentGroup.name!)
        section.addFormRow(exercice_row)
        
        timed_row = XLFormRowDescriptor(tag: "timed", rowType: XLFormRowDescriptorTypeBooleanSwitch, title: "Timed")
        timed_row.value = false
        section.addFormRow(timed_row)
        
        descriptor.addFormSection(section)
        return descriptor
    }
    
    func valid(mg: MuscleGroup, name: String) -> Bool {
        let exs = manager.loadExercicesFor(muscle_group: mg)
        for ex in exs {
            if ex.name == name {
                return false
            }
        }
        return name != ""
    }
    
    class nameValidator : NSObject, XLFormValidatorProtocol {
        @objc func isValid(row: XLFormRowDescriptor!) -> XLFormValidationStatus! {
            let stringVal = row.value?.valueData() as! String
            let predicate = NSPredicate(format: "name == '%@'", stringVal)
            let valid = stringVal != "" && DataManager.getInstance().entityCount(entityType: .Exercice, predicate: predicate) == 0
            return XLFormValidationStatus(msg: "OK", status: valid, rowDescriptor: row)
        }
    }
    
    class nonEmptyValidator: NSObject, XLFormValidatorProtocol {
        @objc func isValid(row: XLFormRowDescriptor!) -> XLFormValidationStatus! {
            let val = (row.valueData() as! String).characters.count > 0
            return XLFormValidationStatus(msg: "valid?", status: val, rowDescriptor: row)
        }
    }
    
    //MARK: - UITextFieldDelegate
    
    override func textFieldDidBeginEditing(textField: UITextField) {
        textField.selectAll(self);
        textField.autocapitalizationType = UITextAutocapitalizationType.Words
    }
}
