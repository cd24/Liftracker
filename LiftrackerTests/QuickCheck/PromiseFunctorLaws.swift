//
//  PromiseFunctorLaws.swift
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
@testable import Liftracker

public class PromiseFunctorLaws: XCTestCase {
    func testInvariants() {
        property("preserves errors", arguments: sizeArgs) <- forAll { (p1: ArbitraryPromiseError<Int>, f: ArrowOf<Int, Int>) in
            return (f.getArrow <^> p1.getPromise).errorsEqual(p1.getPromise)
        }
    }
    
    func testFunctorIdentity() {
        property("Promise obeys Functor identity law", arguments: sizeArgs) <- forAll { (p: ArbitraryPromise<Int>) in
            let promise = p.getPromise
            let mapping = identity <^> promise
            let idOnly = identity(promise)
            return mapping.contentsEqual(idOnly)
        }
    }
    
    func testFunctorComposition() {
        property("Promise obeys functor composition law", arguments: sizeArgs) <- forAll { (p: ArbitraryPromise<Int>, f1: ArrowOf<Int, Int>, f2: ArrowOf<Int, String>) in
            let f = f1.getArrow
            let g = f2.getArrow
            let promise = p.getPromise
            
            let fmap_g_f: (Promise<Int>) -> Promise<String> = { (g • f) <^> $0 }
            let fmap_g_fmap_f: (Promise<Int>) -> Promise<String> = { g <^> $0 } • { f <^> $0 }
            return (fmap_g_f(promise)).contentsEqual(fmap_g_fmap_f(promise))
        }
    }
}

