//
//  Promise+FunctorTests.swift
//  Liftracker
//
//  Created by John McAvey on 2/25/17.
//  Copyright © 2017 John McAvey. All rights reserved.
//

import Foundation
import XCTest
import PromiseKit
import Runes

// Get a compile error for this.
//class PromiseFunctorTests: FunctionalTestBase {
//    
//    func testAddDoubles() {
//        let function: (Double) -> Double =  { $0 + 10 }
//        let value: Promise<Double> = Promise(value: 30)
//        let error: Promise<Double> = Promise(
//            error: NSError()
//        )
//        
//        let result = function <^> value
//        result.then { value in
//            XCTAssertEqual(value, 40)
//        }
//        .catch {
//            XCTAssertFalse(true, "Adding should not have produced the error: \($0)")
//        }
//        
//        let errored = function <^> error
//        errored.then {
//            XCTAssertFalse(true, "Errored add should have produced an error. Instead it produced: \($0)")
//        }
//        .catch { _ in
//            // In this block, we're good to go. Since there was an error.
//        }
//    }
//}
