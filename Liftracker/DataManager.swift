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
    let epley = "Epley", brzycki = "Brzycki", lander = "Lander", lombardi = "Lombardi", mayhew = "Mahew"
    
    let userNameKey = "user_name", genderKey = "user_gender", claculatorKey = "max_rep_calculator", weightUnitKey = "weight_units", fluidUnitsKey = "fuild_units", backgroundColorKey = "background_color", tintColorKey = "tint_color"

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
    
    func newRep(weight w: Double, repetitions reps: Double, exercice ex: Exercice) -> Rep {
        return newRep(weight: w, repetitions: reps, exercice: ex, date: getDayOfWeek())
    }
    
    func newRep(weight w: Double, repetitions reps: Double, exercice ex: Exercice, var date day: NSDate) -> Rep{
        let rep = NSEntityDescription.insertNewObjectForEntityForName("Rep", inManagedObjectContext: managedContext) as! Rep
        day = startOfDay(day)
        rep.weight = w
        rep.num_reps = reps
        rep.date = "\(day)"
        rep.exercice = ex
        rep.unit = getUnitString()
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
        formatter.dateFormat = NSDateFormatter.dateFormatFromTemplate("EdMMMyyyy", options: 0, locale: NSLocale.systemLocale())
        formatter.timeZone = NSTimeZone.systemTimeZone()
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
    
    func getUnitString() -> String{
        return NSUserDefaults.standardUserDefaults().objectForKey(weightUnitKey) as! String //todo: Use setting interface
    }
    
    func getMainColor() -> UIColor {
        let colorString = NSUserDefaults.standardUserDefaults().objectForKey(backgroundColorKey) as! String
        let color = colorWithHexString(colorString)
        return color
    }
    
    func getTintColor() -> UIColor {
        let colorString = NSUserDefaults.standardUserDefaults().objectForKey(tintColorKey) as! String
        let color = colorWithHexString(colorString)
        return color
    }
    
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
        let conversions = [1: 1, 2: 0.95, 3:0.9, 4: 0.88, 5: 0.86, 6:0.83, 7: 0.80, 8:0.78, 9:0.76, 10:0.75, 11:0.72, 12:0.70]
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
        let formula = epley //NSUserDefaults.standardUserDefaults().valueForKey("max_rep_calculator") as! String //todo: Configure settings
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
        return (100*weight)/(52.2 + 41.9 * pow(2.7182, -0.055*numReps)) // couldn't find math.e, so I estimated :)
    }
    
    func values(rep: Rep) -> (Double, Double){
        return (rep.weight!.doubleValue, rep.num_reps!.doubleValue)
    }
    
    func getRepWeightString(rep: Rep) -> String {
        let weight = getUnitString()
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
    
    func saveToFile(){
        
    }
    
    func openShareMenu(){
        
    }
}