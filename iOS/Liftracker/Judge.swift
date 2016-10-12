//
//  Judge.swift
//  Liftracker
//
//  Created by John McAvey on 10/11/16.
//  Copyright © 2016 John McAvey. All rights reserved.
//

import Foundation

/**
 The judge class is responsible for evaluating some combination of data and producing a score for it.  The Judge is allowed to consider data as relative or absolute.  There are no data accessors around judging, only the requirement that by the end you produce some integer value.  If possible, you can provide a maximum and minimum value to give context to the score.
*/
@objc protocol Judge {
    
    /**
     This function is used to distinguish judges in the judge pool.  This will be used to cache and update the judges results.
     */
    static func identifier() -> String
    
    /**
     A new instance of this object will be instantiated as needed.  The object will be deallocated after the score function terminates.
    */
    init()
    
    /**
     This function is expected to be long running - and will be run on a background thread.  At the end of this function, the object will be deallocated.
     
     @parameter completionHandler - Caches and display the result of this calculation.
    */
    func score(completionHandler: (Double) -> Void)
}
