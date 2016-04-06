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
    }
    
    func getForm() -> XLFormDescriptor {
        let form = XLFormDescriptor(title: "Edit Exercice Details")
        let filler = XLFormSectionDescriptor()
        let main_section = XLFormSectionDescriptor()
        main_section.title = "Exercices"
        form.addFormSection(filler)
        
        
        return form
    }
}
