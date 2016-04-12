//
//  AppDelegate.swift
//  Liftracker
//
//  Created by John McAvey on 10/9/15.
//  Copyright © 2015 John McAvey. All rights reserved.
//

import UIKit
import CoreData
import CocoaLumberjack

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let loadOnceKey = "DefaultDataLoad_3"


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        setupLogger()
        setupDefault()
        if let shortcut = launchOptions?[UIApplicationLaunchOptionsShortcutItemKey] as? UIApplicationShortcutItem {
            LaunchAddExercice(shortcut)
            return false
        }
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
    }

    func applicationDidEnterBackground(application: UIApplication) {
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "MCA.Liftracker" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("Liftracker", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            let migrationOptions = [
                NSMigratePersistentStoresAutomaticallyOption : true,
                NSInferMappingModelAutomaticallyOption : true,
                NSPersistentStoreUbiquitousContentNameKey : "LiftrackerStore"
            ]
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: migrationOptions)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason

            dict[NSUnderlyingErrorKey] = error as! NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()

    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    func setupDefault(){
        if NSUserDefaults().boolForKey(loadOnceKey) {
            return //Already run - should be good!
        }
        let manager = DataManager.getInstance()
        if let values = readInDefaults() {
            setupPreferenceDefaults()
            let muscle_groups = values["MuscleGroup"] as! [String:Array<String>]
            for key in muscle_groups.keys{
                let new_group = manager.newMuscleGroup(name: key)
                let exercices = muscle_groups[key]
                let cardio = key == "Cardio"
                for exercice: String in exercices!{
                    let new_exercice = manager.newExercice(name: exercice, muscle_group: new_group, isTimed: cardio)
                    new_exercice.best = 0;
                }
            }
            NSUserDefaults().setBool(true, forKey: loadOnceKey)
        }
        manager.save_context()
    }
    
    func readInDefaults() -> NSDictionary? {
        var myDict: NSDictionary?
        if let path = NSBundle.mainBundle().pathForResource("DefaultData", ofType: "plist"){
            myDict = NSDictionary(contentsOfFile: path)
        }
        
        return myDict
    }

    // MARK: - Core Data Saving support

    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
    
    func setupPreferenceDefaults() {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject("John Doe", forKey: "user_name")
        defaults.setObject("Undisclosed", forKey: "user_gender")
        defaults.setObject("Epley", forKey: "max_rep_calculator")
        defaults.setObject("Lbs", forKey: "weight_units")
        defaults.setObject("Liter", forKey: "fuild_units")
        defaults.setObject("#4dd6ef", forKey: "background_color")
        defaults.setObject("#ffffff", forKey: "tint_color")
        defaults.setObject("5", forKey: "height_feet")
        defaults.setObject("10", forKey: "height_inches")
    }

    func setupLogger() {
        DDLog.addLogger(DDTTYLogger.sharedInstance())
        DDLog.addLogger(DDASLLogger.sharedInstance())

        let fileLogger = DDFileLogger()
        fileLogger.rollingFrequency = 60*60*24
        fileLogger.logFileManager.maximumNumberOfLogFiles = 7
        DDLog.addLogger(fileLogger)
        DDTTYLogger.sharedInstance().colorsEnabled = true
        setLoggerColors()
    }
    
    func setLoggerColors() {
        let background = UIColor.whiteColor()
        let info_color = UIColor.darkGrayColor()
        let verbose_color = UIColor.cyanColor()
        let debug_color = UIColor.blueColor()
        let setup: [UIColor:DDLogFlag] = [
            info_color: .Info,
            debug_color: .Debug,
            verbose_color: .Verbose
        ]
        
        for (color, level) in setup {
            //TODO: Figure out how this works now!
            //DDTTYLogger.sharedInstance().setForegroundColor(color, backgroundColor: background, forTag: level)
        }
    }
    
    func LaunchAddExercice(shortCutItem: UIApplicationShortcutItem) -> Bool {
        let scid = shortCutItem.type
        guard let launch_type = QuickLaunchType(fullIdentified: scid) else {
            return false
        }
        
        switch launch_type{
        case .AddExercice:
            DDLogInfo("Opening Add Exercice View from App Shortcut Launch")
        case .OpenStats:
            DDLogInfo("Opening Statistics View from App Shortcut Launch")
        case .OpenHistory:
            DDLogInfo("Opening History View from App Shortcut Launch")
        }
        
        return true
    }

}

