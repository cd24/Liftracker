//
// Created by John McAvey on 3/5/16.
// Copyright (c) 2016 John McAvey. All rights reserved.
//

import Foundation

class EplyEstimator : WeightEstimator {
    override func estimatedMaxFor(weight: Double, num_reps: Double) -> Double {
        return weight * ( 1 + num_reps/30)
    }
}
