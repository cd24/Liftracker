//
//  LiftrackerNotification.swift
//  Liftracker
//
//  Created by John McAvey on 10/9/16.
//  Copyright © 2016 John McAvey. All rights reserved.
//

import Foundation
import UserNotifications

/**
 This protocol describes a type of notification which can be sent from the Liftracker app.  Any implementation of this protocol will be added to the notification utility when the utility is created in application(:didFinishLaunching:withOptions).
 
 In short, objects of this type will be instantiated when a remote notification of a matching identifier is recieved using init(incoming:).  The object will have handle() invoked on it to perform and processing of the notification.  All instances are shown as alerts.  The object will be deallocated when the notification loop completed.
 
 All methods are invoked on the main thread.
 */
@objc protocol LiftrackerNotification {
    
    /**
     Perform and intitialization of the object required to handle the notification.  This object will be deallocated once the handler has completed.
    */
    init(incoming: UNNotificationResponse)
    
    
    /**
     This ID will be used to associate incoming system notifications with the current notification.  This should be a unique identifier not based on the content it contains.
     */
    static func getID() -> String
    
    /**
     Handle registering the category and actions for this notification type in this method.  Called when the class is registered with the Notification Utility.
     */
    static func register()
    
    /**
     This method will be called after the notification has been processed, and is the last step before the object is deallocated.
    */
    func complete()
    
    /**
     This method will be invoked when the identifier of an incoming notification matches the identifier from this object.  This method should respond appropriately to the incoming notification, with the assumption that the identifiers match.  This method will only be invoked if a user taps on the notification.
     */
    func handle()
    
}
