//
// Created by John McAvey on 3/5/16.
// Copyright (c) 2016 John McAvey. All rights reserved.
//

import Foundation

class MayhewEstimator : WeightEstimator {
    override func estimatedMaxFor(weight: Double, num_reps: Double) -> Double {
        return (100 * weight) / (52.2 + 41.9 * pow( M_E, -0.055*num_reps))
    }
}
