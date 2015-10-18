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

    static func getInstance() -> DataManager {
        return manager;
    }
    
    func loadAllRepsFor(exercice exercice: Exercice) -> [Rep]{
        let fetch_request = NSFetchRequest(entityName: "Rep")
        let sort_predicate = NSPredicate(format: "exercice.name == '\(exercice.name!)'")
        fetch_request.predicate = sort_predicate
        //fetch_request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
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
    
    func loadAllMuscleGroups() -> [MuscleGroup]{
        let fetch_request = NSFetchRequest(entityName: "MuscleGroup")
        fetch_request.sortDescriptors = sortDescriptorName()
        var results: [MuscleGroup] = []
        do {
            results = try managedContext.executeFetchRequest(fetch_request) as! [MuscleGroup]
        }
        catch{
            //NSLog(String(format: "Error while loading muscle groups: %s", error.stringValue()))
        }
        
        return results
    }
    
    func loadExercicesFor(muscle_group group: MuscleGroup) -> [Exercice] {
        let fetch_request = NSFetchRequest(entityName: "Exercice")
        let predicate = NSPredicate(format: "muscle_group.name == '\(group.name!)'")
        fetch_request.predicate = predicate
        fetch_request.sortDescriptors = sortDescriptorName()
        var results: [Exercice] = []
        do {
            results = try managedContext.executeFetchRequest(fetch_request) as! [Exercice]
        }
        catch {
            
        }
        
        return results
    }
    
    func loadDays() -> [Day]{
        let fetch_request = NSFetchRequest(entityName: "Day")
        fetch_request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        var results: [Day] = []
        do {
            results = try managedContext.executeFetchRequest(fetch_request) as! [Day]
        }
        catch
        {
            
        }
        return results
    }
    
    func loadDayFor(date date: NSDate) -> [Day]{
        return [] // todo: Implement me :)
    }
    
    func newExercice(name name: String, muscle_group group: MuscleGroup) -> Exercice{
        let exercice = NSEntityDescription.insertNewObjectForEntityForName("Exercice", inManagedObjectContext: managedContext) as! Exercice
        exercice.name = name
        exercice.muscle_group = group
        save_context()
        return exercice
    }
    
    func newRep(weight weight: Int, repetitions reps: Int) -> Rep {
        let rep = NSEntityDescription.insertNewObjectForEntityForName("Rep", inManagedObjectContext: managedContext) as! Rep
        rep.weight = weight
        rep.num_reps = reps
        rep.day = getToday()
        save_context()
        return rep
    }
    
    func newDay(date: NSDate) -> Day {
        let day = NSEntityDescription.insertNewObjectForEntityForName("Day", inManagedObjectContext: managedContext) as! Day
        day.date = "\(date)"
        save_context()
        return day
    }
    
    func newMuscleGroup(name name: String) -> MuscleGroup {
        let group = NSEntityDescription.insertNewObjectForEntityForName("MuscleGroup", inManagedObjectContext: managedContext) as! MuscleGroup
        group.name = name
        save_context()
        return group
    }
    
    func sortDescriptorName() -> [NSSortDescriptor]{
        return [NSSortDescriptor(key: "name", ascending: true)]
    }
    
    func getToday() -> Day {
        let today = getDayOfWeek()
        
        let fetch_request = NSFetchRequest(entityName: "Day")
        let search_predicate = NSPredicate(format: "date=='\(today)'")
        fetch_request.predicate = search_predicate
        do {
            let results = try managedContext.executeFetchRequest(fetch_request)
            if (results.count > 0){
                return results[0] as! Day
            }
        }
        catch {
            NSLog("Error Occurred \n\(error)")
        }
        
        let new_day = NSEntityDescription.insertNewObjectForEntityForName("Day", inManagedObjectContext: managedContext) as! Day
        new_day.date = "\(getDayOfWeek())"
        save_context()
        return new_day
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
    
    func getDayOfWeek() -> NSDate {
        let today = NSDate()
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let startOfDay = calendar.startOfDayForDate(today)
        return startOfDay
    }
    
    func dateToString(){
        
    }
}