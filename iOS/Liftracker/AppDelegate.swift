//
//  AppDelegate.swift
//  Liftracker
//
//  Created by John McAvey on 9/18/16.
//  Copyright © 2016 John McAvey. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let notFirstRun = "First Run"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        Fabric.with([Crashlytics.self])
        LoggingUtil.setup( SwiftyLogger.self )
        AnalyticsUtil.shared.setup()
        addLaunchActions()
        if #available(iOS 10.0, *) {
            NotificationUtil.shared.register()
        }
        
        let diff = VersionUtil.versionDifference()
        AppActions.shared.trigger( .launch( diff ) )
        VersionUtil.updateVersionStore()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        AppActions.shared.trigger( .suspend )
    }
    
    

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    /// Adds all app actions
    func addLaunchActions() {
        let actions: [AppAction] = [
            SetDefaultsAction()
        ]
        actions.forEach { AppActions.shared.add(action: $0) }
    }
}
