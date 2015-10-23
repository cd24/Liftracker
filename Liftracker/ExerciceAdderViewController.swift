//
//  ExerciceAdderViewController.swift
//  Liftracker
//
//  Created by John McAvey on 10/10/15.
//  Copyright © 2015 MCApps. All rights reserved.
//

import UIKit

class ExerciceAdderViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate{
    var groups: Array<MuscleGroup>?
    var tableView: ExerciceSelectorController?
    var selectedIndex: Int = 0
    @IBOutlet var picker_view: UIPickerView?
    @IBOutlet var name_field: UITextField?
    let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        groups = DataManager.getInstance().loadAllMuscleGroups()
        
        picker_view?.delegate = self
        picker_view?.dataSource = self
        picker_view?.reloadAllComponents()

        // Do any additional setup after loading the view.
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
    
    @IBAction func save(){
        if (!validData()){
            return
        }
        let new_exercice = NSEntityDescription.insertNewObjectForEntityForName("Exercice", inManagedObjectContext: context) as! Exercice
        new_exercice.name = name_field?.text
        new_exercice.muscle_group = groups![selectedIndex]
        do{
            try context.save()
        }
        catch{}
        
        tableView!.load_data()
        tableView!.tableView.reloadData()
        dismissViewControllerAnimated(false, completion: nil)
    }
    
    func validData() -> Bool{
        return name_field?.text != "" // todo: Some other validation might be nice.  EG if it already exists... so on so forth.
    }
    
    @IBAction func dismiss(){
        dismissViewControllerAnimated(true, completion: nil)
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
