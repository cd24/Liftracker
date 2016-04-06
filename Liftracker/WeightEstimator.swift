//
// Created by John McAvey on 3/5/16.
// Copyright (c) 2016 John McAvey. All rights reserved.
//

import Foundation

class WeightEstimator {
    func getConversionConstant(num_reps: Double) -> Double{
        //This function is the best fit for data found on the internet
        //If you have a better constant for rep estimates, let me know!
        return -0.000172235 * pow(num_reps, 3) +
                0.00445998 * pow(num_reps, 2) -
                0.0579785 * num_reps +
                1.0501
    }

    func estimatedMaxFor(weight: Double, num_reps: Double) -> Double{
        return weight * ( 1 + num_reps/30)
    }

    func estimatedMaxFor(reps: [WeightRep]) -> Double{
        var max_val: Double = -1
        reps.forEach({ rep in
            let weight = rep.weight!.doubleValue
            let num_reps = rep.reps!.doubleValue
            let curr_max = self.estimatedMaxFor(weight, num_reps: num_reps)
            max_val = max(curr_max, max_val)
        })
        return max_val
    }

    func estimatedMax(sources: [WeightRep], targeted_reps: Double) -> Double {
        return self.estimatedMaxFor(sources) *
                getConversionConstant(targeted_reps)
    }
}
