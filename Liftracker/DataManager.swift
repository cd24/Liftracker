//
//  DataManager.swift
//  Liftracker
//
//  Created by John McAvey on 10/14/15.
//  Copyright © 2015 MCApps. All rights reserved.
//

import Foundation
import UIKit

class DataManager {
    static private var manager: DataManager = DataManager()
    let managedContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext;
    
    let epley = "Epley",
        brzycki = "Brzycki",
        lander = "Lander",
        lombardi = "Lombardi",
        mayhew = "Mahew"
    
    let conversions = [1: 1,
        2: 0.95,
        3: 0.9,
        4: 0.88,
        5: 0.86,
        6: 0.83,
        7: 0.80,
        8: 0.78,
        9: 0.76,
        10: 0.75,
        11: 0.72,
        12: 0.70]

    static func getInstance() -> DataManager {
        return manager;
    }
    
    //MARK: - Muscle Groups Management
    
    func loadAllMuscleGroups() -> [MuscleGroup]{
        return getEntities("MuscleGroup") as! [MuscleGroup]
    }
    
    func newMuscleGroup(name name: String) -> MuscleGroup {
        let group = newEntity("MuscleGroup") as! MuscleGroup
        group.name = name
        save_context()
        return group
    }
    
    //MARK: - Exercice Management
    
    func loadExercicesFor(muscle_group group: MuscleGroup) -> [Exercice] {
        let predicate = NSPredicate(format: "muscle_group.name == '\(group.name!)'")
        return getEntities("Exercice", predicate: predicate) as! [Exercice]
    }
    
    func searchExercicesForSubstring(text: String) -> [Exercice] {
        let predicate = NSPredicate(format: "name CONTAINS[c] '\(text.lowercaseString)'")
        return getEntities("Exercice", predicate: predicate) as! [Exercice]
    }
    
    func newExercice(name name: String, muscle_group group: MuscleGroup) -> Exercice{
        let exercice = NSEntityDescription.insertNewObjectForEntityForName("Exercice", inManagedObjectContext: managedContext) as! Exercice
        exercice.name = name
        exercice.muscle_group = group
        save_context()
        return exercice
    }
    
    //MARK: - Rep Management
    
    func newRep(weight w: Double, repetitions reps: Double, exercice ex: Exercice) -> Rep {
        return newRep(weight: w, repetitions: reps, exercice: ex, date: TimeManager.getDayOfWeek())
    }
    
    func loadAllRepsFor(exercice exercice: Exercice) -> [Rep]{
        let fetch_request = NSFetchRequest(entityName: "Rep")
        let sort_predicate = NSPredicate(format: "exercice.name == '\(exercice.name!)'")
        fetch_request.predicate = sort_predicate
        let results: [Rep]
        do {
            results = try managedContext.executeFetchRequest(fetch_request) as! [Rep]
        }
        catch {
            results = [];
            //todo: Report the error
        }
        return results;
    }
    
    func loadAllRepsFor(exercice exercice: Exercice, date day: NSDate) -> [Rep]{
        let fetch_request = NSFetchRequest(entityName: "Rep")
        let cleanded_date = TimeManager.startOfDay(day)
        let sort_predicate = NSPredicate(format: "exercice.name == '\(exercice.name!)' AND date == '\(cleanded_date)'")
        fetch_request.predicate = sort_predicate
        let results: [Rep]
        do {
            results = try managedContext.executeFetchRequest(fetch_request) as! [Rep]
        }
        catch {
            results = [];
            //todo: Report the error
        }
        return results;
    }
    
    func loadAllRepsFor( date date: NSDate) -> [Rep]{
        let fetch_request = NSFetchRequest(entityName: "Rep")
        let cleanded_date: NSDate = TimeManager.startOfDay(date)
        let sort_predicate = NSPredicate(format: "date == '\(cleanded_date)'")
        fetch_request.predicate = sort_predicate
        let results: [Rep]
        do {
            results = try managedContext.executeFetchRequest(fetch_request) as! [Rep]
        }
        catch {
            results = [];
            //todo: Report the error
        }
        return results;
    }
    
    func newRep(weight w: Double, repetitions reps: Double, exercice ex: Exercice, var date day: NSDate) -> Rep{
        let rep = NSEntityDescription.insertNewObjectForEntityForName("Rep", inManagedObjectContext: managedContext) as! Rep
        day = TimeManager.startOfDay(day)
        rep.weight = w
        rep.num_reps = reps
        rep.date = "\(day)"
        rep.exercice = ex
        rep.unit = UserPrefs.getUnitString()
        save_context()
        return rep
    }
    
    func getRepWeightString(rep: Rep) -> String {
        let weight = UserPrefs.getUnitString()
        if weight == rep.unit!{
            return "\(rep.weight!) \(weight)"
        }
        if weight == "Kgs" {
            let kgsWeight = 0.453592 * rep.weight!.doubleValue
            return "\(kgsWeight) \(weight)"
        }
        else {
            let lbsWeight = 2.20462 * rep.weight!.doubleValue
            return "\(lbsWeight) \(weight)"
        }
    }
    
    func deleteRep(rep: Rep){
        managedContext.deleteObject(rep)
        save_context()
    }
    
    func values(rep: Rep) -> (Double, Double){
        return (rep.weight!.doubleValue, rep.num_reps!.doubleValue)
    }
    
    //MARK: - Weight Methods
    
    func addWeight(value: Int, notes: String, date: NSDate) -> Weight {
        let weightVal = newEntity("Weight") as! Weight
        weightVal.value = value
        weightVal.notes = notes
        weightVal.date = date
        
        save_context()
        return weightVal
    }

    func getWeights(date date: NSDate) -> [Weight] {
        let startofDay = TimeManager.startOfDay(date),
            endofDay = TimeManager.endOfDay(date)
        let predicate = NSPredicate(format: "(date >= %@) AND (date <= %@)", startofDay, endofDay)
        return getEntities("Weight", predicate: predicate) as! [Weight]
    }
    
    func getWeights(start: NSDate, end: NSDate) -> [Weight] {
        let predicate = NSPredicate(format: "(date >= %@) AND (date <= %@)", start, end)
        return getEntities("Weight", predicate: predicate) as! [Weight]
    }
    
    //MARK: - General Core Data
    
    func entityExists(name: String, entityType entity: String, nameField field: String = "name") -> Bool {
        let fetch_request = NSFetchRequest(entityName: entity)
        let predicate = NSPredicate(format: "\(field) == \(name)")
        fetch_request.predicate = predicate
        let error = NSErrorPointer()
        let exists = managedContext.countForFetchRequest(fetch_request, error: error) > 0
        return exists
    }
    
    func newEntity(name: String) -> NSManagedObject {
        return NSEntityDescription.insertNewObjectForEntityForName(name, inManagedObjectContext: managedContext)
    }
    
    func getEntity(name: String, entityType entity: String, nameField field: String = "name") -> [NSManagedObject] {
        let predicate = NSPredicate(format: "\(field) == \(name)")
        return getEntities(name, predicate: predicate)
    }
    
    func getEntities(name: String, predicate: NSPredicate? = nil) -> [NSManagedObject] {
        let fetch_request = NSFetchRequest(entityName: name)
        if let p = predicate {
            fetch_request.predicate = p
        }
        
        let values: [NSManagedObject]
        do {
            values = try managedContext.executeFetchRequest(fetch_request) as! [NSManagedObject]
            return values
        }
        catch {
            print("An error occured while fetching \(name)'s.  The error was: \(error)")
            return [NSManagedObject]()
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
            //todo: Catch any errors
            NSLog("Error Occurred \n\(error)")
        }
    }
    
    // MARK: - Helper Methods
    
    func getMaxFor(exercice ex: Exercice, num_reps reps: Int) -> Rep{
        let reps = loadAllRepsFor(exercice: ex)
        var max: Rep?
        for rep in reps {
            if max != nil {
                max = rep;
            }
            else if rep.num_reps == reps && max!.weight?.integerValue > rep.weight?.integerValue {
                max = rep
            }
        }
        return max!;
    }
    
    func getMaxFor(exercice ex: Exercice) -> Rep{
        let reps = loadAllRepsFor(exercice: ex)
        var max: Rep?
        for rep in reps {
            if max != nil {
                max = rep;
            }
            else if max!.weight?.integerValue < rep.weight?.integerValue {
                max = rep
            }
        }
        return max!;
    }
    
    func estimatedMax(ex: Exercice, reps: Int) -> Double {
        let orm = estimatedMax(ex)
        
        if reps < 12{
            return orm * conversions[reps]!
        }
        return orm*0.6
    }
    
    func estimatedMax(ex: Exercice) -> Double{
        var max: Double = 0.0;
        let reps = loadAllRepsFor(exercice: ex)
        for rep in reps{
            let temp_max = estimatedMaxa(rep)
            if temp_max > max {
                max = temp_max
            }
        }
        return max
    }
    
    private func estimatedMaxa(rep: Rep) -> Double{
        let formula = NSUserDefaults.standardUserDefaults().valueForKey("max_rep_calculator") as! String
        switch (formula){
        case epley:
            return epleyMax(rep)
        case brzycki:
            return brzyckiMax(rep)
        case lander:
            return landerMax(rep)
        case lombardi:
            return lombardiMax(rep)
        case mayhew:
            return mayhewMax(rep)
        default:
            return epleyMax(rep)
        }
    }
    
    func epleyMax(rep: Rep) -> Double{
        let (weight, numReps) = values(rep)
        return weight * ( 1 + numReps/30)
    }
    
    func brzyckiMax(rep: Rep) -> Double {
        let (weight, numReps) = values(rep)
        return weight * (36 / (37 - numReps))
    }
    
    func landerMax(rep: Rep) -> Double {
        let (weight, numReps) = values(rep)
        return (100 * weight) / (101.3 - 2.67123*numReps)
    }
    
    func lombardiMax(rep: Rep) -> Double{
        let (weight, numReps) = values(rep)
        return weight * pow(numReps, 0.10)
    }
    
    func mayhewMax(rep: Rep) -> Double{
        let (weight, numReps) = values(rep)
        return (100*weight)/(52.2 + 41.9 * pow(M_E, -0.055*numReps)) //M_E == mathematical constant e
    }
    
    //MARK: - Useful Numbers
    func bmi(weight: Double) -> Double {
        let weight = UserPrefs.getUnitString() == "Lbs" ?
                        lbsToKilograms(weight) :
                        weight
        let height = ftToCm(feet: UserPrefs.getHeight_ft(),
                            inches: UserPrefs.getHeight_in())
        return weight / pow(height, 2)
    }
    
    //MARK: - Unit Conversions
    
    func lbsToKilograms(value: Double) -> Double {
        return value * (1/2.204)
    }
    
    func kilogramsToLbs(value: Double) -> Double {
        return value * 2.204
    }
    
    func ftInToInch(feet ft: Int, inches inn: Int) -> Int {
        return (ft * 12) + inn
    }
    
    func ftToCm(feet ft: Int, inches inn: Int) -> Double {
        return inchToCm(
                    ftInToInch(feet: ft, inches: inn))
    }
    
    func inchToCm(inches: Int) -> Double {
        return Double(inches) * 2.54
    }
    
    func cmToIn(cm: Double) -> Int {
        return Int(cm/2.54)
    }
    
    // these are rough approximations since these units do not need to be exact for any calculations I am performing.
    
    func galToLiter(gal: Double) -> Double {
        return gal*3.7854118
    }
    
    func literToGal(liter: Double) -> Double {
        return liter/3.7854118
    }
}