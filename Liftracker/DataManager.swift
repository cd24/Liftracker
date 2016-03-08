//
//  DataManager.swift
//  Liftracker
//
//  Created by John McAvey on 10/14/15.
//  Copyright © 2015 John McAvey. All rights reserved.
//

import Foundation
import UIKit
import HealthKit
import Charts

class DataManager {
    static private var manager: DataManager = DataManager()
    let managedContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext;
    
    static let epley = "Epley",
        brzycki = "Brzycki",
        lander = "Lander",
        lombardi = "Lombardi",
        mayhew = "Mahew"

    let estimators = [
            DataManager.epley     : EplyEstimator(),
            DataManager.brzycki   : BrzyckiEstimator(),
            DataManager.lander    : LanderEstimator(),
            DataManager.lombardi  : LombardiEstimator(),
            DataManager.mayhew    : MayhewEstimator()
    ]

    static func getInstance() -> DataManager {
        return manager;
    }
    
    //MARK: - Muscle Groups Management
    
    func loadAllMuscleGroups() -> [MuscleGroup]{
        return getEntities(LTObject.MuscleGroup, predicate:nil, sortdesc: sortDescriptorName()) as! [MuscleGroup]
    }
    
    func newMuscleGroup(name name: String) -> MuscleGroup {
        let pred = NSPredicate(format: "name == '\(name)'")
        let count = entityCount(entityType: .MuscleGroup, predicate: pred)
        if count != 0{
            return getEntities(.MuscleGroup, predicate: pred)[0] as! MuscleGroup
        }
        let group = newEntity(.MuscleGroup) as! MuscleGroup
        group.name = name
        save_context()
        return group
    }
    
    func mgForName(name: String) -> MuscleGroup? {
        let mgs = loadAllMuscleGroups()
        for mg in mgs {
            if mg.name == name {
                return mg
            }
        }
        return nil
    }
    
    //MARK: - Exercice Management
    
    func loadExercicesFor(muscle_group group: MuscleGroup) -> [Exercice] {
        let predicate = NSPredicate(format: "muscle_group.name == '\(group.name!)'")
        return getEntities(.Exercice, predicate: predicate, sortdesc: sortDescriptorName()) as! [Exercice]
    }
    
    func searchExercicesForSubstring(text: String) -> [Exercice] {
        let predicate = NSPredicate(format: "name CONTAINS[c] '\(text.lowercaseString)'")
        return getEntities(.Exercice, predicate: predicate) as! [Exercice]
    }
    
    func newExercice(name name: String, muscle_group group: MuscleGroup, isTimed: Bool = false) -> Exercice{
        let pred = NSPredicate(format: "name == '\(name)' AND muscle_group.name == '\(group.name!)'")
        let count = entityCount(entityType: .Exercice, predicate: pred)
        if count != 0 {
            return getEntities(.Exercice, predicate: pred)[0] as! Exercice
        }
        let exercice = newEntity(.Exercice) as! Exercice
        exercice.name = name
        exercice.muscle_group = group
        exercice.isTimed = isTimed
        save_context()
        return exercice
    }
    
    func exerciceForName(name: String) -> Exercice? {
        let predicate = NSPredicate(format: "name == '%@'", name)
        let entities = getEntities(.Exercice, predicate: predicate)
        if entities.count > 0 {
            return entities[0] as? Exercice
        }
        return nil
    }
    
    //MARK: - Rep Management
    
    func newRep(weight w: Double, repetitions reps: Double, exercice ex: Exercice, date: NSDate = NSDate()) -> Rep{
        let rep = newEntity(.Rep) as! Rep
        rep.weight = w
        rep.num_reps = reps
        rep.date = date
        rep.exercice = ex
        rep.unit = UserPrefs.getUnitString()
        save_context()
        return rep
    }
    
    func loadAllRepsFor(exercice exercice: Exercice) -> [Rep]{
        let predicate = NSPredicate(format: "exercice.name == '\(exercice.name!)'")
        return getEntities(.Rep, predicate: predicate) as! [Rep]
    }
    
    func loadAllRepsFor(exercice exercice: Exercice, date: NSDate) -> [Rep]{
        let start = TimeManager.startOfDay(date)
        let end = TimeManager.endOfDay(date)
        let predicate = NSPredicate(format: "exercice.name == %@ AND (date >= %@) AND (date <= %@)",
                        exercice.name!,
                        start,
                        end)
        return getEntities(.Rep, predicate: predicate) as! [Rep]
    }
    
    func loadAllRepsFor(date date: NSDate) -> [Rep]{
        let cleanded_date: NSDate = TimeManager.startOfDay(date)
        let predicate = NSPredicate(format: "date == '\(cleanded_date)'")
        return getEntities(.Rep, predicate: predicate) as! [Rep]
    }
    
    func getRepWeightString(rep: Rep) -> String {
        let weight = UserPrefs.getUnitString()
        var val = rep.weight!.doubleValue
        if rep.unit! != weight {
            if weight == "Kgs" {
                val = 0.453592 * val
            }
            else {
                val = 2.20462 * val
            }
        }
        return "\(val) \(weight)"
    }
    
    func deleteRep(rep: Rep){
        managedContext.deleteObject(rep)
        save_context()
    }
    
    func repsForMuscleGroup(group: MuscleGroup) -> [Rep] {
        let predicate = NSPredicate(format: "exercice.muscle_group.name == \(group.name)")
        return getEntities(.Rep, predicate: predicate) as! [Rep]
    }
    
    func values(rep: Rep) -> (Double, Double){
        return (rep.weight!.doubleValue, rep.num_reps!.doubleValue)
    }
    
    //MARK: - Timed Rep Management
    
    func newTimedRep(start: NSDate, end: NSDate, weight: Double = 0, exercice: Exercice) -> TimedRep {
        let rep = newEntity(.TimedRep) as! TimedRep
        
        let duration = TimeManager.getDuration(start, end: end)
        rep.duration_seconds = duration.second
        rep.duration_minutes = duration.minute
        rep.duration_hours = duration.hour
        rep.weight = weight
        rep.exercice = exercice
        rep.start_time = start
        rep.end_time = end
        
        save_context()
        
        return rep
    }
    
    func timedRepsFor(exercice: Exercice, start: NSDate, end: NSDate) -> [TimedRep] {
        let predicate = NSPredicate(format: "exercice.name == %@ AND (start_time >= %@) AND (end_time <= %@)", exercice.name!, start, end)
        return getEntities(.TimedRep, predicate: predicate) as! [TimedRep]
    }
    
    func timedRepsFor(exercice: Exercice) -> [TimedRep] {
        let predicate = NSPredicate(format: "exercice.name == '\(exercice.name!)'")
        return getEntities(.TimedRep, predicate: predicate) as! [TimedRep]
    }
    
    func allTimedReps() -> [TimedRep] {
        return getEntities(.TimedRep) as! [TimedRep]
    }
    
    //MARK: - Weight Methods
    
    func getAllWeights() -> [Weight] {
        return getEntities(.Weight) as! [Weight]
    }
    
    func addWeight(value: Int, notes: String, date: NSDate) -> Weight {
        let weightVal = newEntity(.Weight) as! Weight
        weightVal.value = value
        weightVal.notes = notes
        weightVal.date = date
        
        save_context()
        return weightVal
    }

    func getWeights(date date: NSDate) -> [Weight] {
        let startofDay = TimeManager.startOfDay(date),
            endofDay = TimeManager.endOfDay(date)
        return getWeights(startofDay, end: endofDay)
    }
    
    func getWeights(start: NSDate, end: NSDate) -> [Weight] {
        let predicate = NSPredicate(format: "(date >= %@) AND (date <= %@)", start, end)
        return getEntities(.Weight, predicate: predicate) as! [Weight]
    }
    
    func hkToWeight(samples: [HKQuantitySample]) -> [Weight] {
        var data = [Weight]()
        samples.forEach { w in
            let wt = Weight()
            wt.value = w.getWeightValue()
            wt.date = w.startDate
            data.append(wt)
        }
        return data
    }
    
    func weightToSampels(weights: [Weight]) -> [HKQuantitySample] {
        let weight = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMass)!
        return weights.map { w in
            return HKQuantitySample(type: weight,
                                    quantity: HKQuantity(unit: UserPrefs.getHKWeightUnit(), doubleValue: Double(w.value!)),
                                    startDate: w.date!,
                                    endDate: w.date!)
        }
    }
    
    //MARK: - General Core Data
    
    func entityExists(name: String, entityType entity: LTObject, nameField field: String = "name") -> Bool {
        let predicate = NSPredicate(format: "\(field) == \(name)")
        return entityCount(entityType: entity, predicate: predicate) > 0
    }
    
    func entityCount(entityType entity: LTObject, predicate: NSPredicate? = nil) -> Int {
        let fetch_request = NSFetchRequest(entityName: entity.rawValue)
        fetch_request.predicate = predicate
        let error = NSErrorPointer()
        return managedContext.countForFetchRequest(fetch_request, error: error)
    }
    
    func newEntity(name: LTObject) -> NSManagedObject {
        return NSEntityDescription.insertNewObjectForEntityForName(name.rawValue, inManagedObjectContext: managedContext)
    }
    
    func getEntityWithValue(value: String, entityType entity: LTObject, valueField field: String = "name") -> [AnyObject] {
        let predicate = NSPredicate(format: "\(field) == \(value)")
        return getEntities(entity, predicate: predicate)
    }
    
    func getEntities(name: LTObject, predicate: NSPredicate? = nil, sortdesc: [NSSortDescriptor]? = nil) -> [AnyObject] {
        let fetch_request = NSFetchRequest(entityName: name.rawValue)
        if let pred = predicate {
            fetch_request.predicate = pred
        }
        if let sd = sortdesc {
            fetch_request.sortDescriptors = sd
        }
        
        let values: [AnyObject]
        do {
            values = try managedContext.executeFetchRequest(fetch_request)
            return values
        }
        catch {
            print("An error occured while fetching an \(name).  The error was: \(error)")
            let alertView = UIAlertController(title: "Error Loading Data",
                message: "Sorry to say, but we ran into a problem loading your data from the device.  would you like to report this error?",
                preferredStyle: UIAlertControllerStyle.Alert)
            let email_action = UIAlertAction(title: "Report", style: UIAlertActionStyle.Default, handler: {act in
                self.reportError(error)
            })
            let cancel_action = UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Cancel, handler: nil)
            alertView.addAction(email_action)
            alertView.addAction(cancel_action)
            if let root_controller = getCurrentViewController() {
                root_controller.presentViewController(alertView, animated: true, completion: nil)
            }
            return [AnyObject]()
        }
    }
    
    func sortDescriptorName() -> [NSSortDescriptor]{
        return [NSSortDescriptor(key: "name", ascending: true)]
    }
    
    func sortDescriptorDate() -> [NSSortDescriptor] {
        return [NSSortDescriptor(key: "date", ascending: true)]
    }
    
    func save_context(){
        do {
            try managedContext.save()
        }
        catch{
            //todo: Find a logging library
        }
    }
    
    // MARK: - Helper Methods
    
    func estimatedMax(ex: Exercice, reps: Double) -> Double {
        let exrep = loadAllRepsFor(exercice: ex)
        let formula = NSUserDefaults.standardUserDefaults().valueForKey("max_rep_calculator") as! String
        if let estimator = estimators[formula] {
            return estimator.estimatedMax(exrep, targeted_reps: reps)
        }
        else {
            return estimators[DataManager.epley]!.estimatedMax(exrep, targeted_reps: reps)
        }
    }
    
    func estimatedMax(ex: Exercice) -> Double{
        let formula = NSUserDefaults.standardUserDefaults().valueForKey("max_rep_calculator") as! String
        let reps = loadAllRepsFor(exercice: ex)
        if let estimator = estimators[formula] {
            return estimator.estimatedMaxFor(reps)
        }
        else {
            return estimators[DataManager.epley]!.estimatedMaxFor(reps)
        }
    }
    
    func estimatedMax(rep: Rep) -> Double{
        let formula = NSUserDefaults.standardUserDefaults().valueForKey("max_rep_calculator") as! String
        let (weight, reps) = (rep.weight!.doubleValue, rep.num_reps!.doubleValue)
        if let estimator = estimators[formula] {
            return estimator.estimatedMaxFor(weight, num_reps: reps)
        }
        else {
            return estimators[DataManager.epley]!.estimatedMaxFor(weight, num_reps: reps)
        }

    }
    
    //MARK: - Useful Numbers
    func bmi(weight: Double) -> Double {
        let weight = UserPrefs.getUnitString() == "Lbs" ?
                        DataManager.lbsToKilograms(weight) :
                        weight
        let height = DataManager.ftToCm(feet: UserPrefs.getHeight_ft(),
                            inches: UserPrefs.getHeight_in()) / 100
        let bmi = weight / pow(height, 2)
        return bmi
    }
    
    //MARK: - Unit Conversions
    
    static func lbsToKilograms(value: Double) -> Double {
        return value * (1/2.204)
    }
    
    static func kilogramsToLbs(value: Double) -> Double {
        return value * 2.204
    }
    
    static func ftInToInch(feet ft: Int, inches inn: Int) -> Int {
        return (ft * 12) + inn
    }
    
    static func ftToCm(feet ft: Int, inches inn: Int) -> Double {
        return inchToCm(
                    ftInToInch(feet: ft, inches: inn))
    }
    
    static func inchToCm(inches: Int) -> Double {
        return Double(inches) * 2.54
    }
    
    static func cmToIn(cm: Double) -> Int {
        return Int(cm/2.54)
    }
    
    static func galToLiter(gal: Double) -> Double {
        return gal*3.7854118
    }
    
    static func literToGal(liter: Double) -> Double {
        return liter/3.7854118
    }
    
    //MARK: - Error Reporting via Network
    
    func reportError(error: ErrorType) {
        //todo: Write the error to an email and send it.
    }
    
    func getCurrentViewController() -> UIViewController? {
        if var topController = UIApplication.sharedApplication().keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            
            return topController
        }
        return nil
    }
    
    //MARK: - Chart Helper Methods
    
    func chartColors() -> [UIColor] {
        var colors = [UIColor]()
        colors.appendContentsOf(ChartColorTemplates.vordiplom())
        colors.appendContentsOf(ChartColorTemplates.joyful())
        colors.appendContentsOf(ChartColorTemplates.colorful())
        colors.appendContentsOf(ChartColorTemplates.liberty())
        colors.appendContentsOf(ChartColorTemplates.pastel())
        return colors
    }
    
    func percentNumberFormatter() -> NSNumberFormatter {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = NSNumberFormatterStyle.PercentStyle
        formatter.maximumFractionDigits = 1
        formatter.multiplier = 1.0
        formatter.percentSymbol = " %"
        return formatter
    }
}

extension HKQuantitySample {
    func getWeightValue() -> Double {
        return self.quantity.doubleValueForUnit(UserPrefs.getHKWeightUnit())
    }
}