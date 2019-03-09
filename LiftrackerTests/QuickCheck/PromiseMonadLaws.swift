//
//  PromiseMonadLaws.swift
//  LiftrackerTests
//
//  Created by John McAvey on 2/19/18.
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

public class PromiseMonadLaws: XCTestCase {
    typealias PC = Int
    typealias AP = ArbitraryPromise<PC>
    
    func testMonadIdentity() {
        property("Promise obeys the Monad left identity law", arguments: sizeArgs) <- forAll { (a : PC, fa : ArrowOf<PC, AP>) in
            let f = { $0.getPromise } • fa.getArrow
            return (pure(a) >>- f).contentsEqual( f(a) )
        }
        property("Promise obeys the Monad right identity law", arguments: sizeArgs) <- forAll { (m : AP) in
            return (m.getPromise >>- pure).contentsEqual( m.getPromise )
        }
    }
    
    func testMonadAssociativity() {
        property("Promise obeys the Monad associativity law", arguments: sizeArgs) <- forAll { (fa : ArrowOf<PC, AP>, ga : ArrowOf<PC, AP>) in
            let f = { $0.getPromise } • fa.getArrow
            let g = { $0.getPromise } • ga.getArrow
            return forAll { (m : AP) in
                return ((m.getPromise >>- f) >>- g).contentsEqual( (m.getPromise >>- { x in f(x) >>- g }) )
            }
        }
    }
}


