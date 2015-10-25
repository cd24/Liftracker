//
//  HistoryViewController.swift
//  Liftracker
//
//  Created by John McAvey on 10/24/15.
//  Copyright © 2015 MCApps. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {

    var left = IDTableView(), right = IDTableView(), current = IDTableView()
    var pages: [IDTableView] = []
    let leftID = 1, rightID = 2, centerID = 3
    let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
    var leftData = [Exercice:[Rep]](), rightData = [Exercice:[Rep]](), centerData = [Exercice:[Rep]]()
    var leftKeys = [Exercice](), rightKeys = [Exercice](), centerKeys = [Exercice]()
    var dayFocus = NSDate()
    @IBOutlet var mainView: UIScrollView!
    @IBOutlet var pageController: UIPageControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createTableviews()
        addIDs()
        addDelegates()
        addDatasources()
        registerXibsinTableviews()
        
        loadAllData()
        configurePageController()
    }
    
    func createTableviews(){
        let framea = mainView.frame
        let frame = CGRectMake(framea.size.width * CGFloat(floatLiteral: 0.0), 0.0, framea.width * 0.9, framea.height)
        right = IDTableView(frame: frame, style: UITableViewStyle.Grouped)
        left = IDTableView(frame: frame, style: UITableViewStyle.Grouped)
        current = IDTableView(frame: frame, style: UITableViewStyle.Grouped)
    }
    
    func configurePageController(){
        pages = [left, current, right]
        pageController = UIPageControl(frame: mainView.frame)
        loadPages()
        pageController.numberOfPages = 3
        pageController.currentPage = 1
        lock_zoom()
    }
    
    func makeTableviewsGrouped(){
        
    }
    
    func addIDs(){
        left.id = leftID
        right.id = rightID
        current.id = centerID
    }
    
    func addDelegates(){
        right.delegate = self
        current.delegate = self
        left.delegate = self
    }
    
    func addDatasources(){
        left.dataSource = self
        current.dataSource = self
        right.dataSource = self
    }
    
    func registerXibsinTableviews(){
        left.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "Cell")
        right.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "Cell")
        current.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "Cell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let table = tableView as? IDTableView{
            //update for each tableview
            if table.id == leftID{
                return leftKeys.count
            }
            else if table.id == rightID{
                return rightKeys.count
            }
            else if table.id == centerID{
                return centerKeys.count
            }
        }
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let table = tableView as? IDTableView{
            if table.id == leftID{
                let key = leftKeys[section]
                return leftData[key]!.count
            }
            else if table.id == rightID{
                let key = rightKeys[section]
                return rightData[key]!.count
            }
            else if table.id == centerID{
                let key = centerKeys[section]
                return centerData[key]!.count
            }
        }
        
        return 0
    }
    
    func lock_zoom(){
        mainView?.maximumZoomScale = 1.0
        mainView?.minimumZoomScale = 1.0
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        var weight: Int = 0
        var num_reps: Int = 0
        let rep: Rep
        let key: Exercice
        
        if let table = tableView as? IDTableView{
            if table.id == leftID{
                key = leftKeys[indexPath.section]
                rep = leftData[key]![indexPath.row]
                weight = rep.weight!.integerValue
                num_reps = rep.num_reps!.integerValue
            }
            else if table.id == rightID{
                key = rightKeys[indexPath.section]
                rep = rightData[key]![indexPath.row]
                weight = rep.weight!.integerValue
                num_reps = rep.num_reps!.integerValue
            }
            else if table.id == centerID{
                key = centerKeys[indexPath.section]
                rep = centerData[key]![indexPath.row]
                weight = rep.weight!.integerValue
                num_reps = rep.num_reps!.integerValue
            }
            cell.textLabel?.text = "Weight: \(weight), Num Reps: \(num_reps)"
        }
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let table = tableView as? IDTableView{
            if table.id == leftID{
                return leftKeys[section].name
            }
            else if table.id == rightID{
                return rightKeys[section].name
            }
            else if table.id == centerID{
                return centerKeys[section].name
            }
        }
        return ""
    }
    
    func loadAllData(){
        let yesterday = calendar.dateByAddingUnit(NSCalendarUnit.Day, value: -1, toDate: dayFocus, options: NSCalendarOptions(rawValue: 0))!
        let tomorrow = calendar.dateByAddingUnit(NSCalendarUnit.Day, value: 1, toDate: dayFocus, options: NSCalendarOptions(rawValue: 0))!
        (leftData, leftKeys) = fill_data(yesterday)
        (centerData, centerKeys) = fill_data(dayFocus)
        (rightData, rightKeys) = fill_data(tomorrow)
        reload_all()
    }
    
    func shiftForward(){
        dayFocus = calendar.dateByAddingUnit(NSCalendarUnit.Day, value: 1, toDate: dayFocus, options: NSCalendarOptions(rawValue: 0))!
        (leftData, leftKeys) = (centerData, centerKeys)
        (centerData, centerKeys) = (rightData, rightKeys)
        let tomorrow = calendar.dateByAddingUnit(NSCalendarUnit.Day, value: 1, toDate: dayFocus, options: NSCalendarOptions(rawValue: 0))!
        (rightData, rightKeys) = fill_data(tomorrow)
    }
    
    func shiftBackward(){
        dayFocus = calendar.dateByAddingUnit(NSCalendarUnit.Day, value: -1, toDate: dayFocus, options: NSCalendarOptions(rawValue: 0))!
        (rightData, rightKeys) = (centerData, centerKeys)
        (centerData, centerKeys) = (leftData, leftKeys)
        let yesterday = calendar.dateByAddingUnit(NSCalendarUnit.Day, value: -1, toDate: dayFocus, options: NSCalendarOptions(rawValue: 0))!
        (leftData, leftKeys) = fill_data(yesterday)
    }
    
    func reload_all(){
        right.reloadData()
        left.reloadData()
        current.reloadData()
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
        var frame1 = mainView.bounds,
            frame2 = mainView.bounds,
            frame3 = mainView.bounds
        
        frame1 = CGRectMake(frame1.size.width * CGFloat(floatLiteral: 0.0), 0.0, frame1.width * 0.9, mainView.frame.height)
        
        frame2 = CGRectMake(frame2.size.width * CGFloat(floatLiteral: 1.0), 0.0, frame2.width * 0.9, mainView.frame.height)
        
        frame3 = CGRectMake(frame3.size.width * CGFloat(floatLiteral: 2.0), 0.0, frame3.width * 0.9, mainView.frame.height)
        
        let newPageOne = pages[0], newPageTwo = pages[1], newPageThree = pages[2]
        newPageOne.frame = frame1
        newPageTwo.frame = frame2
        newPageThree.frame = frame3
        
        mainView.addSubview(newPageOne)
        mainView.addSubview(newPageTwo)
        mainView.addSubview(newPageThree)
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
