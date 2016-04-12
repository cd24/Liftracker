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
import CocoaLumberjack
import CoreData
import Charts

class DataManager {
    static private var manager: DataManager = DataManager()
    let managedContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext;
    
    static let epley = "Epley",
        brzycki = "Brzycki",
        lander = "Lander",
        lombardi = "Lombardi",
        mayhew = "Mahew"

    static func getInstance() -> DataManager {
        return manager;
    }
    
    //MARK: - Muscle Groups Management
    
    func loadAllMuscleGroups() -> [MuscleGroup]{
        return getEntities(.MuscleGroup, predicate:nil, sortdesc: sortDescriptorName()) as! [MuscleGroup]
    }
    
    func newMuscleGroup(name name: String) -> MuscleGroup {
        DDLogInfo("Creating new mucle group called '\(name)'")
        let pred = NSPredicate(format: "name == '\(name)'")
        let count = entityCount(entityType: .MuscleGroup, predicate: pred)
        if count != 0{
            DDLogWarn("Muscle group named '\(name)' already existed, returning existing entitty instead")
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
        DDLogDebug("No Muscle Group by the name '\(name)' exists in the database")
        return nil
    }
    
    //MARK: - Exercice Management
    
    func loadExercicesFor(muscle_group group: MuscleGroup) -> [Exercice] {
        DDLogVerbose("Loading exercices for muscle group '\(group.name!)'")
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
    
    func newWeightedRep(weight w: Double, repetitions reps: Double, exercice ex: Exercice, date: NSDate = NSDate()) -> WeightRep {
        let rep = newEntity(.WeightRep) as! WeightRep
        DDLogVerbose("Created new rep with weight: \(w), repetitions: \(reps), for exercice: \(ex.name!) on \(date)")
        rep.weight = w
        rep.reps = reps
        rep.start_time = date
        rep.exercice = ex
        rep.unit = UserPrefs.getUnitString()
        save_context()
        return rep
    }
    
    func loadAllWeightedRepsFor(exercice exercice: Exercice) -> [WeightRep]{
        let predicate = NSPredicate(format: "exercice.name == '\(exercice.name!)'")
        let reps = getEntities(.WeightRep, predicate: predicate) as! [WeightRep]
        DDLogDebug("Retrievied \(reps.count) reps from the model while querying all")
        return reps
    }
    
    func loadAllWeightedRepsFor(exercice exercice: Exercice, date: NSDate) -> [WeightRep]{
        let start = TimeManager.startOfDay(date)
        let end = TimeManager.endOfDay(date)
        let predicate = NSPredicate(format: "exercice.name == %@ AND (start_time >= %@) AND (start_time <= %@)",
                        exercice.name!,
                        start,
                        end)
        return getEntities(.WeightRep, predicate: predicate) as! [WeightRep]
    }
    
    func loadAllWeightedRepsFor(date date: NSDate) -> [Rep]{
        let cleanded_date: NSDate = TimeManager.startOfDay(date)
        let predicate = NSPredicate(format: "start_time == '\(cleanded_date)'")
        return getEntities(.WeightRep, predicate: predicate) as! [Rep]
    }
    
    func getRepWeightString(rep: WeightRep) -> String {
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
    
    //MARK: - Timed Rep Management
    
    func newTimedRep(start: NSDate, end: NSDate, weight: Double = 0, exercice: Exercice) -> TimedRep {
        DDLogDebug("Creating new timed rep")
        let rep = newEntity(.TimedRep) as! TimedRep
        DDLogVerbose("Created new entity of type Timed Rep")
        
        rep.weight = weight
        rep.exercice = exercice
        rep.start_time = start
        rep.end_time = end
        rep.unit = UserPrefs.getUnitString()
        
        DDLogDebug("Added attributes to the object... preparing to save")
        save_context()
        DDLogInfo("Created new timed rep for start \(start) and end \(end), weight = \(weight)")
        
        return rep
    }
    
    func timedRepsFor(exercice: Exercice, start: NSDate, end: NSDate) -> [TimedRep] {
        let predicate = NSPredicate(format: "exercice.name == %@ AND (start_time >= %@) AND (end_time <= %@)", exercice.name!, start, end)
        DDLogDebug("Fetching timed reps for predicate '\(predicate)'")
        let reps = getEntities(.TimedRep, predicate: predicate) as! [TimedRep]
        DDLogVerbose("Retrievied \(reps.count) timed reps between \(start) and \(end) for \(exercice.name!)")
        return reps
    }
    
    func timedRepsFor(exercice: Exercice) -> [TimedRep] {
        let predicate = NSPredicate(format: "exercice.name == '\(exercice.name!)'")
        DDLogVerbose("Fetching timed reps for predicate '\(predicate)'")
        let values = getEntities(.TimedRep, predicate: predicate) as! [TimedRep]
        DDLogVerbose("Retrieved \(values.count) timed reps for exercice \(exercice.name!)")
        return values
    }
    
    func allTimedReps() -> [TimedRep] {
        DDLogDebug("Loading all timed reps")
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
    
    //MARK: - Workout methods
    
    func allWorkouts() -> [Workout]{
        return getEntities(.Workout) as! [Workout]
    }
    
    func newWorkout(info: [WorkoutMetaData]) -> Workout {
        let workout = newEntity(.Workout) as! Workout
        let set = NSMutableSet()
        for meta in info {
            meta.workout = workout
            set.addObject(meta)
        }
        workout.meta_data = set
        workout.created = NSDate()
        save_context()
        
        return workout
    }
    
    func newTimedMetaData(exercice: Exercice, hour: Int, minute: Int, second: Int) -> WorkoutMetaData {
        let meta = newEntity(.WorkoutMetaData) as! WorkoutMetaData
        meta.exercice = exercice
        meta.duration_hour = hour
        meta.duration_minute = minute
        meta.duration_second = second
        meta.target_reps = 1
        save_context()
        return meta
    }
    
    func newWeightMetaData(exercice: Exercice, reps: Int) -> WorkoutMetaData {
        let meta = newEntity(.WorkoutMetaData) as! WorkoutMetaData
        meta.exercice = exercice
        meta.duration_hour = 0
        meta.duration_minute = 0
        meta.duration_second = 0
        meta.target_reps = reps
        save_context()
        return meta
    }
    
    func deleteWorkout(workout: Workout) {
        let workouts = workout.meta_data
        managedContext.deleteObject(workout)
        for work in workouts! {
            managedContext.deleteObject(work as! NSManagedObject)
        }
        save_context()
    }
    
    //MARK: - General Core Data
    
    func entityExists(name: String, entityType entity: LTObject, nameField field: String = "name") -> Bool {
        let predicate = NSPredicate(format: "\(field) == \(name)")
        let exists = entityCount(entityType: entity, predicate: predicate) > 0
        DDLogDebug("Entity \(entity) exists where \(field) == \(name)?: \(exists)")
        return exists
    }
    
    func entityCount(entityType entity: LTObject, predicate: NSPredicate? = nil) -> Int {
        let fetch_request = NSFetchRequest(entityName: entity.rawValue)
        fetch_request.predicate = predicate
        let error: NSErrorPointer = nil
        var count = managedContext.countForFetchRequest(fetch_request, error: error)
        if (error != nil) {
            DDLogError("Encountered an error while counting objects of type \(entity).\nError: \(error.debugDescription)")
            count = 0
        }
        else {
            DDLogDebug("Counted \(count) objects for type \(entity)")
        }
        return count
    }
    
    func newEntity(name: LTObject) -> NSManagedObject {
        DDLogVerbose("Creating new entity for type \(name)")
        let object = NSEntityDescription.insertNewObjectForEntityForName(name.rawValue, inManagedObjectContext: managedContext)
        return object
    }
    
    func getEntityWithValue(value: String, entityType entity: LTObject, valueField field: String = "name") -> [AnyObject] {
        let predicate = NSPredicate(format: "\(field) == \(value)")
        return getEntities(entity, predicate: predicate)
    }
    
    func getEntities(name: LTObject, predicate: NSPredicate? = nil, sortdesc: [NSSortDescriptor]? = nil) -> [AnyObject] {
        let fetch_request = NSFetchRequest(entityName: name.rawValue)
        DDLogVerbose("Fetching entities of type \(name)")
        if let pred = predicate {
            fetch_request.predicate = pred
            DDLogVerbose("with predicate \(pred)")
        }
        if let sd = sortdesc {
            fetch_request.sortDescriptors = sd
            DDLogVerbose("with sort descriptors \(sd)")
        }
        
        let values: [AnyObject]
        do {
            DDLogDebug("Attempting to retrieve objects...")
            values = try managedContext.executeFetchRequest(fetch_request)
            DDLogVerbose("Retrieved \(values.count) objects.")
            return values
        }
        catch {
            DDLogError("An error occured while fetching an \(name).  The error was: \(error)")
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
            DDLogDebug("Saving context")
            try managedContext.save()
        }
        catch{
            reportError(error)
        }
    }
    
    //MARK: - Useful Numbers
    func bmi(weight: Double) -> Double {
        let weight = UserPrefs.getUnitString() == "Lbs" ?
                        UnitCalculator.lbsToKilograms(weight) :
                        weight
        let height = UnitCalculator.ftToCm(feet: UserPrefs.getHeight_ft(),
                            inches: UserPrefs.getHeight_in()) / 100
        let bmi = weight / pow(height, 2)
        return bmi
    }
    
    //MARK: - Error Reporting via Network
    
    func reportError(error: ErrorType) {
        DDLogError("Encountered an error - error information:")
        DDLogError("\(error)")
        for err in NSThread.callStackSymbols() {
            DDLogError(err)
        }
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