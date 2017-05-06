//
//  Analyist.swift
//  Liftracker
//
//  Created by John McAvey on 10/9/16.
//  Copyright © 2016 John McAvey. All rights reserved.
//

import Foundation
import UIKit
import PromiseKit

/**
    This protocol is where all the fun stuff happens.  Implementations of this protocol should query for information and produce informtion for display to the user.  Instances are created when the user selects the view.  The init should not be a fast operation.  Analysts should use Realm and Realm extensions to interact with the data.  To read more about realm queries and models, visit their site (https://realm.io/docs/objc/latest/)
 */
protocol Analyst {

    
    init()
    
    /**
        This method will be invoked when the view is requested, and will be executed on a background thread.  However, this operation will still provide a waiting experience for the user.  Taking too long may cause them to exit the view, which will interrupt the operation.  Errors encountered should be handled using the reject model of promises.
     
        - parameter completion: Invoke at the end of your calculations to display the result to the user.
    */
    func analyze() -> Promise<AnalystResult>
    
    /**
        This method will be invoked before the thread running analyze is killed.  This could be caused by the user navigating away, or the app being sent to the background.  If you need to do any cleanup, perform it here - you will have 5 seconds to cleanup in the thread before it is killed.
    */
    func interrupt()
    
    // MARK :- Getters for the display
    
    /**
        This method allows us to use reflection to get all of the Analysts at runtime and associate them with their artists.
        - Returns: The artist used to render the results from this analyst.
     */
    func getArtist() -> Artist
    
    
    func getTitle() -> String
    func getDescription() -> String
}

/**
    Classes implementing this protocol are responsible for rendering the results from an Analyst to the user.
    It is recommended that implementations of this protocol also extend UIView, but it is not required.
 */
protocol Artist {
    
    init()
    
    /**
        This method should take the results provided and render a view to display to the user. Invoking the completion handle with a view will update the display accordingly. If the completion handler is invoked with nil, then the controller will present a standard error page to the user. View size may change, so the use of layout constraints is encouraged.
     
        - Parameters:
            - result: The results of the calulcations which should be rendered
        - returns: The promise which will fufill with the rendered view.
    */
    func render(result: AnalystResult) -> Promise<UIView>
}

/**
    This is a data class used to transfer data between Analysts and Artists.  
    New Artists should Extend this class to define the input they're expecting.
 */
class AnalystResult : NSObject {
    
    var title: String?
    var desc: String?
}

public enum AnalystError: Error {
    case generic
    case mathematicalError
    case invalidData
}

public enum ArtistError: Error {
    case generic
    case unkownData
}
