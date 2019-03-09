//
//  PromiseApplicativeLaws.swift
//  LiftrackerTests
//
//  Created by John McAvey on 2/17/18.
//  Copyright © 2018 John McAvey. All rights reserved.
//

import Foundation
import XCTest
import Nimble
import PromiseKit
import Swiftz
import SwiftCheck
import Curry
@testable import Liftracker

#if LARGE_TEST
let sizeArgs = CheckerArguments(replay: nil, maxAllowableSuccessfulTests: 10000, maxAllowableDiscardedTests: 10000, maxTestCaseSize: 10000)
#else
let sizeArgs = CheckerArguments(replay: nil, maxAllowableSuccessfulTests: 100, maxAllowableDiscardedTests: 100, maxTestCaseSize: 100)
#endif

public class PromiseApplicativeLaws: XCTestCase {
    typealias PC = Int
    typealias AP = ArbitraryPromise<PC>
    
    func testApplicativeIdentity() {
        property("Promise obeys the Applicative identity law", arguments: sizeArgs) <- forAll { (promise: AP) in
            return (pure(identity) <*> promise.getPromise).contentsEqual(promise.getPromise)
        }
    }
    
    func testApplicativeHomomorphism() {
        property("Promise obeys the Applicative homomorphism law", arguments: sizeArgs) <- forAll { (_ f : ArrowOf<Int, Int>, x : Int) in
            return (pure(f.getArrow) <*> pure(x)).contentsEqual(pure(f.getArrow(x)))
        }
    }
    
    func testApplicativeInterchange() {
        property("Promise obeys the Applicative interchange law", arguments: sizeArgs) <- forAll {  (fl: ArrowOf<PC, PC>) in
            let f = pure(fl.getArrow)
            return forAll { (q: PC) in
                return (f <*> pure(q)).contentsEqual( pure({ g in g(q) }) <*> f )
            }
        }
    }
    
    func testApplicativeComposition() {
        property("Promise obeys the Applicative composition law", arguments: sizeArgs) <- forAll { (fl: ArrowOf<PC, PC>, gl: ArrowOf<PC, PC>, xl: AP) in
            let f = pure(fl.getArrow)
            let g = pure(gl.getArrow)
            let x = xl.getPromise
            return (curry(•) <^> f <*> g <*> x).contentsEqual(f <*> (g <*> x))
        }
        property("Promise obeys the lifted Applicative composition law", arguments: sizeArgs) <- forAll { (fl: ArrowOf<PC, PC>, gl: ArrowOf<PC, PC>, xl: AP) in
            let f = pure(fl.getArrow)
            let g = pure(gl.getArrow)
            let x = xl.getPromise
            return (pure(curry(•)) <*> f <*> g <*> x).contentsEqual(f <*> (g <*> x))
        }
    }
}


