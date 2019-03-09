//
//  WorkoutTableViewController.swift
//  Liftracker
//
//  Created by John McAvey on 2/26/17.
//  Copyright © 2017 John McAvey. All rights reserved.
//

import UIKit
import os.log
import Bond
import ReactiveKit
import PromiseKit
import RealmSwift
import Swiftz

class WorkoutTableViewController: UITableViewController {
    public var workouts: MutableObservableArray2D<String, Workout> = MutableObservableArray2D()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addWorkout))
//        workouts.bind(to: self.tableView) { array, indexPath, table in
//            let cell = table.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
//            let workout = array[indexPath.item]
//
//            cell.textLabel?.text = workout.name
//            let sch = Schedule(workout.schedule.byte())
//            let detailText = sch.days.compactMap { "\($0)" }.joined(separator: ", ")
//            cell.detailTextLabel?.text = detailText
//
//            return cell
//        }
        workouts.bind(to: self.tableView) { array, indexPath, table in
            let cell = table.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            let workout = array.item(at: indexPath)
            let info = self.display(workout)
            cell.textLabel?.text = info.title
            cell.detailTextLabel?.text = info.detail
            
            return cell
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        os_log("Workouts view will appear", log: ui_log, type: .debug)
        updateData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getWorkouts(_ realm: Realm) -> [Workout] {
        return realm.objects(Workout.self).map { $0 }
    }
    
    func sepToday(_ workouts: [Workout]) -> (today: [Workout], all: [Workout]) {
        let today = workouts.filter { $0.getSchedule().active() }
        let others = workouts.filter { !$0.getSchedule().active() }
        return (today, others)
    }
    
    func display(_ wkt: Workout) -> (title: String, detail: String) {
        let sch = Schedule(wkt.schedule.byte())
        let detailText = sch.days.compactMap { "\($0)" }.joined(separator: ", ")
        return (wkt.name, detailText)
    }
    
    func updateData() {
        let workouts = (sepToday • getWorkouts) <^> realm()
        workouts.done { (wkts) -> Void in
            let arr = Array2D(sectionsWithItems: [("All", wkts.all), ("Today", wkts.today)])
            self.workouts.replace(with: arr, performDiff: false, areValuesEqual: { _, _ in false })
        }.catch { (e: Error) -> Void in
            os_log("Encountered error while refreshing workouts: %s",
                   log: ui_log,
                   type: .error,
                   "\(e)")
        }
    }
    
    @objc func addWorkout() {
        self.performSegue(withIdentifier: "add", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "start" {
            // Prepare destination
            // TODO
            os_log("Starting workout", log: ui_log, type: .debug)
        }
    }
}
