//
//  HistoryViewController.swift
//  Liftracker
//
//  Created by John McAvey on 10/24/15.
//  Copyright © 2015 MCApps. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController,UIScrollViewDelegate {

    var //left = HistoryTableViewController(style: UITableViewStyle.Grouped)//,
        //right = HistoryTableViewController(style: UITableViewStyle.Grouped),
        current = HistoryTableViewController(style: UITableViewStyle.Grouped)
    var pages: [HistoryTableViewController] = []
    let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
    var dayFocus = NSDate()
    @IBOutlet var mainView: UIScrollView!
    @IBOutlet var pageController: UIPageControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadAllData()
        configurePageController()
        centerView()
        loadPages()
        setTitle()
    }
    
    func configurePageController(){
        //pages = [left, current, right]
        pageController = UIPageControl(frame: mainView.frame)
        loadPages()
        pageController.numberOfPages = 3
        pageController.currentPage = 1
        lock_zoom()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func lock_zoom(){
        mainView?.maximumZoomScale = 1.0
        mainView?.minimumZoomScale = 1.0
    }

    func loadAllData(){
        let yesterday = calendar.dateByAddingUnit(NSCalendarUnit.Day, value: -1, toDate: dayFocus, options: NSCalendarOptions(rawValue: 0))!
        let tomorrow = calendar.dateByAddingUnit(NSCalendarUnit.Day, value: 1, toDate: dayFocus, options: NSCalendarOptions(rawValue: 0))!
        updateView(fill_data(dayFocus), controller: current, day: dayFocus)
        //updateView(fill_data(yesterday), controller: left, day: yesterday)
        //updateView(fill_data(tomorrow), controller: right, day: tomorrow)
    }
    
    @IBAction func shiftForward(){
        let leftD = calendar.dateByAddingUnit(NSCalendarUnit.Day, value: 1, toDate: dayFocus, options: NSCalendarOptions(rawValue: 0))!
        let centerD = calendar.dateByAddingUnit(NSCalendarUnit.Day, value: 1, toDate: dayFocus, options: NSCalendarOptions(rawValue: 0))!
        let rightD = dayFocus
        //updateView((current.data, current.keys), controller: left, day: leftD)
        updateView(fill_data(centerD), controller: current, day: centerD)
        //updateView(fill_data(rightD), controller: right, day: rightD)
        //centerView()
        dayFocus = centerD
        setTitle()
    }
    
    @IBAction func shiftBackward(){
        let leftD = dayFocus
        let rightD = calendar.dateByAddingUnit(NSCalendarUnit.Day, value: -1, toDate: dayFocus, options: NSCalendarOptions(rawValue: 0))!
        let centerD = calendar.dateByAddingUnit(NSCalendarUnit.Day, value: -1, toDate: dayFocus, options: NSCalendarOptions(rawValue: 0))!
        //updateView((current.data, current.keys), controller: right, day: rightD)
        updateView(fill_data(centerD), controller: current, day: centerD)
        //updateView(fill_data(leftD), controller: left, day: leftD)
        //centerView()
        dayFocus = centerD
        setTitle()
    }
    
    func centerView(){
        let x = view.bounds.width
        let y = CGFloat(0.0)
        let point = CGPointMake(x, y)
        mainView.contentOffset = point
    }
    
    func updateView(info: (data: [Exercice:[Rep]], keys: [Exercice]), controller: HistoryTableViewController, day: NSDate){
        controller.keys = info.keys
        controller.data = info.data
        controller.day = day
        controller.tableView.reloadData()
    }
    
    func fill_data(day: NSDate)-> (data: [Exercice:[Rep]], keys: [Exercice]){
        var store = [Exercice:[Rep]]()
        var keys = [Exercice]()
        let manager = DataManager.getInstance()
        let muscle_groups = manager.loadAllMuscleGroups()
        for mg in muscle_groups{
            let exercices = manager.loadExercicesFor(muscle_group: mg)
            for exercice in exercices{
                let reps = manager.loadAllRepsFor(exercice: exercice, date: day)
                if reps.count == 0{
                    continue
                }
                store[exercice] = reps
                keys.append(exercice)
            }
        }
        return (store, keys)
    }
    
    func updateView(){
        let pageWidth = mainView.frame.size.width
        let page = Int(floor((mainView.contentOffset.x * 2.0 + pageWidth) / (pageWidth * 2.0))) + 1
        if page == 2{
            shiftForward()
        }
        else if page == 0 {
            shiftBackward()
        }
        pageController.currentPage = 1
    }
    
    func loadPages(){
        /*
        for i in 0...2 {
            let page = pages[i]
            var frame = mainView.frame
            frame.origin.x = frame.size.width * CGFloat(i)
            frame.origin.y = 0.0
            
            page.view.frame = frame
            mainView.addSubview(page.view)
        }*/
        var frame = mainView.frame
        var bounds = mainView.bounds
        frame.origin.x = 0.0
        frame.origin.y = -65.0
        current.view.bounds = mainView.bounds
        current.view.frame = frame
        mainView.addSubview(current.view)
    }
    
    func setTitle() {
        ///title = "\(DataManager.getInstance().dateToString(dayFocus))"
        title = "History"
    }
    
    func configureTableViewConstraints(table: UITableView){
        let topConstraint = NSLayoutConstraint(item: table, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.mainView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: table, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.mainView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
        let leftConstraint = NSLayoutConstraint(item: table, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.mainView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 10)
        let rightConstraint = NSLayoutConstraint(item: table, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.mainView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 10)
            
        table.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activateConstraints([topConstraint, bottomConstraint, leftConstraint, rightConstraint])
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        updateView()
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

class IDTableView: UITableView {
    var id: Int = 0;
}
