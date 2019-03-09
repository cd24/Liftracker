//
//  PromiseAlternativeLaws.swift
//  LiftrackerTests
//
//  Created by John McAvey on 5/11/18.
//  Copyright © 2018 John McAvey. All rights reserved.
//

import Foundation
import XCTest
import Nimble
import PromiseKit
import Swiftz
import SwiftCheck
import Curry
import Runes
@testable import Liftracker

public class PromiseAlternativeLaws: XCTestCase {
    typealias PC = Int
    typealias AP = ArbitraryPromise<PC>
    
    public func testEmptyIsNeutral() {
        property("Empty is Neutral", arguments: sizeArgs) <- forAll() { (promise: AP) in
            let p = promise.getPromise
            return (Promise<Int>.empty() <|> p).contentsEqual(p) &&
                   (p <|> Promise<Int>.empty()).contentsEqual(p)
        }
    }
    public func testAltIsAssociative() {
        property("Alternative is associative", arguments: sizeArgs) <- forAll() { (promise: AP) in
            let p = promise.getPromise
            let l = (Promise<Int>.empty() <|> Promise<Int>.empty()) <|> p
            let r = Promise<Int>.empty() <|> (Promise<Int>.empty() <|> p)
            return l.contentsEqual(r)
        }
    }
}
