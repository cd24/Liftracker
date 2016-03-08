//
// Created by John McAvey on 3/5/16.
// Copyright (c) 2016 John McAvey. All rights reserved.
//

import Foundation

class WeightEstimator {
    func getConversionConstant(num_reps: Double) -> Double{
        return -0.000172235 * pow(num_reps, 3) +
                0.00445998 * pow(num_reps, 2) -
                0.0579785 * num_reps +
                1.0501
    }

    func estimatedMaxFor(weight: Double, num_reps: Double) -> Double{
        return weight * ( 1 + num_reps/30)
    }

    func estimatedMaxFor(reps: [Rep]) -> Double{
        var max_val: Double = Double.infinity
        try! reps.forEach({ rep in
            let weight = rep.weight!.doubleValue
            let num_reps = rep.num_reps!.doubleValue
            let curr_max = estimatedMaxFor(weight, num_reps: num_reps)
            max_val = max(curr_max, max_val)
        })
        return max_val
    }

    func estimatedMax(sources: [Rep], targeted_reps: Double) -> Double {
        return estimatedMaxFor(sources) *
                getConversionConstant(targeted_reps)
    }
}
