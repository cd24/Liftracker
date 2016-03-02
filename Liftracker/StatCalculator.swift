//
//  StatCalculator.swift
//  Liftracker
//
//  Created by John McAvey on 10/22/15.
//  Copyright © 2015 John McAvey. All rights reserved.
//

import Foundation

class StatCalculator {
    let manager = DataManager.getInstance();
    let epley = "Epley", brzycki = "Brzycki", lander = "Lander", lombardi = "Lombardi", mayhew = "Mahew"
    
    func getMaxFor(exercice ex: Exercice, num_reps reps: Int) -> Rep{
        let reps = manager.loadAllRepsFor(exercice: ex)
        var max: Rep?
        for rep in reps {
            if max != nil {
                max = rep;
            }
            else if rep.num_reps == reps && max!.weight?.integerValue > rep.weight?.integerValue {
                max = rep
            }
        }
        return max!;
    }
    
    func getMaxForAllReps(exercice ex: Exercice) -> [Int:Rep]{
        let reps = manager.loadAllRepsFor(exercice: ex)
        var map = [Int:Rep]()
        for rep in reps {
            let (weight, num_reps) = intValues(rep)
            if weight > map[num_reps]!.weight?.integerValue {
                map[num_reps] = rep
            }
            else {
                map[num_reps] = rep
            }
        }
        
        return map
    }
    
    func estimatedMax(rep: Rep) -> Double{
        let formula = NSUserDefaults.standardUserDefaults().valueForKey("max_rep_calculator") as! String
        switch (formula){
        case epley:
            return epleyMax(rep)
        case brzycki:
            return brzyckiMax(rep)
        case lander:
            return landerMax(rep)
        case lombardi:
            return lombardiMax(rep)
        case mayhew:
            return mayhewMax(rep)
        default:
            return epleyMax(rep)
        }
    }
    
    func epleyMax(rep: Rep) -> Double{
        let (weight, numReps) = values(rep)
        return weight * ( 1 + numReps/30)
    }
    
    func brzyckiMax(rep: Rep) -> Double {
        let (weight, numReps) = values(rep)
        return weight * (36 / (37 - numReps))
    }
    
    func landerMax(rep: Rep) -> Double {
        let (weight, numReps) = values(rep)
        return (100 * weight) / (101.3 - 2.67123*numReps)
    }
    
    func lombardiMax(rep: Rep) -> Double{
        let (weight, numReps) = values(rep)
        return weight * pow(numReps, 0.10)
    }
    
    func mayhewMax(rep: Rep) -> Double{
        let (weight, numReps) = values(rep)
        return (100*weight)/(52.2 + 41.9 * pow(2.7182, -0.055*numReps)) // couldn't find math.e, so I estimated :) 
    }
    
    func values(rep: Rep) -> (Double, Double){
        return (rep.weight!.doubleValue, rep.num_reps!.doubleValue)
    }
    
    func intValues(rep: Rep) -> (Int, Int){
        return (rep.weight!.integerValue, rep.num_reps!.integerValue)
    }
}