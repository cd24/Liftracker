//
//  FunctionalTestBase.swift
//  Liftracker
//
//  Created by John McAvey on 2/25/17.
//  Copyright © 2017 John McAvey. All rights reserved.
//

import Foundation
import XCTest
import PromiseKit
import Runes

class FunctionalTestBase: XCTestCase {

    func createBlockFor(first: Double) -> (Double) -> Promise<Double> {
        return { second in
            let answer = first + second
            return Promise(value: answer)
        }
    }
    
    func createConversionBlock(from: AnyPromise) -> Promise<String> {
        return from.then { val in
            return Promise(value: "\(val)")
        }
    }
}
