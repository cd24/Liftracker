//
//  UnitCalculator.swift
//  Liftracker
//
//  Created by John McAvey on 4/3/16.
//  Copyright © 2016 John McAvey. All rights reserved.
//

import Foundation

class UnitCalculator {
    static func lbsToKilograms(value: Double) -> Double {
        return value * (1/2.204)
    }
    
    static func kilogramsToLbs(value: Double) -> Double {
        return value * 2.204
    }
    
    static func ftInToInch(feet ft: Int, inches inn: Int) -> Int {
        return (ft * 12) + inn
    }
    
    static func ftToCm(feet ft: Int, inches inn: Int) -> Double {
        return inchToCm(
            ftInToInch(feet: ft, inches: inn))
    }
    
    static func inchToCm(inches: Int) -> Double {
        return Double(inches) * 2.54
    }
    
    static func cmToIn(cm: Double) -> Int {
        return Int(cm/2.54)
    }
    
    static func galToLiter(gal: Double) -> Double {
        return gal*3.7854118
    }
    
    static func literToGal(liter: Double) -> Double {
        return liter/3.7854118
    }
}