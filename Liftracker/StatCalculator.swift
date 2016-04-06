//
//  StatCalculator.swift
//  Liftracker
//
//  Created by John McAvey on 10/22/15.
//  Copyright © 2015 John McAvey. All rights reserved.
//

import Foundation

class StatCalculator {
    static let manager = DataManager.getInstance();
    static let epley = "Epley", brzycki = "Brzycki", lander = "Lander", lombardi = "Lombardi", mayhew = "Mahew"
    static let estimators = [
        StatCalculator.epley     : EplyEstimator(),
        StatCalculator.brzycki   : BrzyckiEstimator(),
        StatCalculator.lander    : LanderEstimator(),
        StatCalculator.lombardi  : LombardiEstimator(),
        StatCalculator.mayhew    : MayhewEstimator()
    ]
    
    static func getMaxFor(exercice ex: Exercice, num_reps reps: Int) -> Rep{
        let reps = manager.loadAllWeightedRepsFor(exercice: ex)
        var max: Rep?
        for rep in reps {
            if max != nil {
                max = rep;
            }
            else if rep.reps == reps && max!.weight?.integerValue > rep.weight?.integerValue {
                max = rep
            }
        }
        return max!;
    }
    
    static func estimatedMax(ex: Exercice, reps: Double) -> Double {
        let exrep = manager.loadAllWeightedRepsFor(exercice: ex)
        let formula = NSUserDefaults.standardUserDefaults().valueForKey("max_rep_calculator") as! String
        if let estimator = estimators[formula] {
            return estimator.estimatedMax(exrep, targeted_reps: reps)
        }
        else {
            return estimators[DataManager.epley]!.estimatedMax(exrep, targeted_reps: reps)
        }
    }
    
    static func estimatedMax(ex: Exercice) -> Double{
        let formula = NSUserDefaults.standardUserDefaults().valueForKey("max_rep_calculator") as! String
        let reps = manager.loadAllWeightedRepsFor(exercice: ex)
        if let estimator = estimators[formula] {
            return estimator.estimatedMaxFor(reps)
        }
        else {
            return defaultEstimator().estimatedMaxFor(reps)
        }
    }
    
    static func estimatedMax(rep: WeightRep) -> Double{
        let formula = NSUserDefaults.standardUserDefaults().valueForKey("max_rep_calculator") as! String
        let (weight, reps) = (rep.weight!.doubleValue, rep.reps!.doubleValue)
        if let estimator = estimators[formula] {
            return estimator.estimatedMaxFor(weight, num_reps: reps)
        }
        else {
            return defaultEstimator().estimatedMaxFor(weight, num_reps: reps)
        }
        
    }
    
    private static func defaultEstimator() -> WeightEstimator {
        return estimators[DataManager.epley]!
    }
}