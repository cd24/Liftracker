//
//  WorkoutEditViewController.swift
//  Liftracker
//
//  Created by John McAvey on 4/3/16.
//  Copyright © 2016 John McAvey. All rights reserved.
//

import UIKit
import XLForm

class WorkoutEditViewController: XLFormViewController {
    var workout: Workout?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        form = getForm()
        self.title = "Edit Workout"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: #selector(save))
    }
    
    func save() {
        let values = formValues()
    }
    
    func getForm() -> XLFormDescriptor {
        let form = XLFormDescriptor(title: "Edit Workout")
        let options = XLFormSectionOptions(rawValue: XLFormSectionOptions.CanInsert.rawValue |
                                                     XLFormSectionOptions.CanDelete.rawValue |
                                                     XLFormSectionOptions.CanReorder.rawValue)
        
        let header_section = XLFormSectionDescriptor.formSectionWithTitle("name")
        let row = XLFormRowDescriptor(tag: "name", rowType: XLFormRowDescriptorTypeText)
        header_section.addFormRow(row)
        form.addFormSection(header_section)
        
        let main_section = XLFormSectionDescriptor.formSectionWithTitle("Exercices",
                                                   sectionOptions: options,
                                                   sectionInsertMode: XLFormSectionInsertMode.LastRow)
        main_section.title = "Exercices"
        
        if let work = workout {
            for meta in work.meta_data! {
                let meta_data = meta as! WorkoutMetaData
                //let meta_title = meta_data.exercice!.name!
                let row = exerciceRow(meta_data.exercice!.name!)
                //row.cellConfig.setObject(meta_title, forKey: "textField.text")
                main_section.addFormRow(row)
            }
        }
        
        main_section.addFormRow(exerciceRow(nil))
        
        form.addFormSection(main_section)
        
        return form
    }
    
    func exerciceRow(title: String?) -> XLFormRowDescriptor {
        let row = XLFormRowDescriptor(tag: nil, rowType: XLFormRowDescriptorTypeSelectorPush, title: title)
        row.selectorOptions = exercicesForForm()
        row.title = ""
        row.value = title
        
        return row
    }
    
    func exercicesForForm() -> [String] {
        let manager = DataManager.getInstance()
        var values = [String]()
        let mgs = manager.loadAllMuscleGroups()
        for mg in mgs {
            let exercices = manager.loadExercicesFor(muscle_group: mg)
            for exercice in exercices {
                if exercice.isTimed!.boolValue {
                    continue
                }
                values.append(exercice.name!)
            }
        }
        return values
    }
}
