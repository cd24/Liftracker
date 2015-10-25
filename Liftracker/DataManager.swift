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
        let cleanded_date = startOfDay(day)
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
        let cleanded_date: NSDate = startOfDay(date)
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
    
    func loadAllMuscleGroups() -> [MuscleGroup]{
        let fetch_request = NSFetchRequest(entityName: "MuscleGroup")
        fetch_request.sortDescriptors = sortDescriptorName()
        var results: [MuscleGroup] = []
        do {
            results = try managedContext.executeFetchRequest(fetch_request) as! [MuscleGroup]
        }
        catch{
            NSLog("Error while loading muscle groups: \(error)")
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
    
    func newRep(weight w: Int, repetitions reps: Int, exercice ex: Exercice) -> Rep {
        return newRep(weight: w, repetitions: reps, exercice: ex, date: getDayOfWeek())
    }
    
    func newRep(weight w: Int, repetitions reps: Int, exercice ex: Exercice, date day: NSDate) -> Rep{
        let rep = NSEntityDescription.insertNewObjectForEntityForName("Rep", inManagedObjectContext: managedContext) as! Rep
        rep.weight = w
        rep.num_reps = reps
        rep.date = "\(day)"
        rep.exercice = ex
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
        return startOfDay(NSDate())
    }
    
    func startOfDay(date: NSDate) -> NSDate{
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let startOfDay = calendar.startOfDayForDate(date)
        return startOfDay
    }
    
    func dateToString(date: NSDate) -> String{
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"
        
        return formatter.stringFromDate(date)
    }
    
    func colorWithHexString (hex:String) -> UIColor {
        var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).uppercaseString
        
        if (cString.hasPrefix("#")) {
            cString = cString.substringFromIndex(cString.startIndex)
        }
        
        if (cString.characters.count != 6) {
            return UIColor.grayColor()
        }

        let rString = cString.substringToIndex(cString.startIndex.advancedBy(2))
        let gString = cString.substringFromIndex(cString.startIndex.advancedBy(2)).substringToIndex(cString.startIndex.advancedBy(4))
        let bString = cString.substringFromIndex(cString.startIndex.advancedBy(4)).substringToIndex(cString.startIndex.advancedBy(6))
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        NSScanner(string: rString).scanHexInt(&r)
        NSScanner(string: gString).scanHexInt(&g)
        NSScanner(string: bString).scanHexInt(&b)
        
        let colour = UIColor(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: CGFloat(1.0))
        return colour
    }
}