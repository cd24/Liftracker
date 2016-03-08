//
// Created by John McAvey on 3/5/16.
// Copyright (c) 2016 John McAvey. All rights reserved.
//

import Foundation

class LanderEstimator : WeightEstimator {
    override func estimatedMaxFor(weight: Double, num_reps: Double) -> Double {
        return (100 * weight) / (101.3 - 2.67123*num_reps)
    }
}
