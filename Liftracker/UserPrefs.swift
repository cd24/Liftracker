//
//  UserPrefs.swift
//  Liftracker
//
//  Created by John McAvey on 1/9/16.
//  Copyright © 2016 John McAvey. All rights reserved.
//

import Foundation
import UIKit
import HealthKit

class UserPrefs {
    static let userNameKey = "user_name",
        genderKey = "user_gender",
        claculatorKey = "max_rep_calculator",
        weightUnitKey = "weight_units",
        fluidUnitsKey = "fuild_units",
        backgroundColorKey = "background_color",
        tintColorKey = "tint_color",
        height_ft = "height_feet",
        height_in = "height_inches"
    
    static func getUnitString() -> String{
        return getForKey(weightUnitKey) as! String
    }
    
    static func getMainColor() -> UIColor {
        let color = UIColor.whiteColor()
        return color
    }
    
    static func getTintColor() -> UIColor {
        let color = UIColor.blackColor()
        return color
    }
    
    static func getHeight_ft() -> Int {
        let height = getForKey(height_ft) as! String
        return Int(height)!
    }
    
    static func getHeight_in() -> Int {
        let height = getForKey(height_in) as! String
        return Int(height)!
    }
    
    static func getForKey(key: String) -> AnyObject{
        let result = NSUserDefaults.standardUserDefaults().objectForKey(key)
        return result!
    }
    
    static func putAtKey(obj: AnyObject, key: String) {
        NSUserDefaults.standardUserDefaults().setObject(obj, forKey: key)
    }
    
    static func getHKWeightUnit() -> HKUnit {
        return getUnitString() == "Lbs" ? HKUnit.poundUnit() : HKUnit.gramUnit()
    }
}