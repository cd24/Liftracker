//
//  Promise+SimpleEquality+Arbitrary.swift
//  LiftrackerTests
//
//  Created by John McAvey on 2/18/18.
//  Copyright © 2018 John McAvey. All rights reserved.
//

import Foundation
import PromiseKit
import Nimble
import SwiftCheck

extension Promise where T: Equatable {
    // THIS IS NOT EXHAUSTIVE. this only works for promises which do not error.
    public func contentsEqual(_ rhs: Promise<T>) -> Bool {
        var v1: T? = nil
        var v2: T? = nil
        self.then { v1_r in
            v1 = v1_r
        }
        expect(v1).toEventuallyNot(beNil())
        rhs.then { v2_r in
            v2 = v2_r
        }
        expect(v2).toEventuallyNot(beNil())
        return v1! == v2!
    }
    
    // THIS IS NOT EXHAUSTIVE. this only works for PropertyTestError.
    public func errorsEqual(_ rhs: Promise<T>) -> Bool {
        var e1: PropertyTestError? = nil
        var e2: PropertyTestError? = nil
        self.catch { v1_r in
            e1 = v1_r as? PropertyTestError
        }
        expect(e1).toEventuallyNot(beNil())
        rhs.catch { v2_r in
            e2 = v2_r as? PropertyTestError
        }
        expect(e2).toEventuallyNot(beNil())
        switch e1! {
        case .testError1:
            switch e2! {
            case .testError1:
                return true
            default:
                return false
            }
        case .testError2:
            switch e2! {
            case .testError2:
                return true
            default:
                return false
            }
        case .testError3:
            switch e2! {
            case .testError3:
                return true
            default:
                return false
            }
        }
    }
}

public enum PropertyTestError: Error {
    case testError1
    case testError2
    case testError3
}

public struct ArbitraryPromise<T: Arbitrary>: Arbitrary {
    public let getPromise: Promise<T>
    init(_ p: Promise<T>) { getPromise = p }
    
    public static var arbitrary : Gen<ArbitraryPromise<T>> { return T.arbitrary.map(Promise.init).map(ArbitraryPromise.init) }
}

public struct ArbitraryPromiseError<T: Arbitrary>: Arbitrary {
    public let getPromise: Promise<T>
    init(_ p: Promise<T>) { getPromise = p }
    
    public static var arbitrary : Gen<ArbitraryPromiseError<T>> {
        return Gen.fromElements(of: [PropertyTestError.testError1, PropertyTestError.testError2, PropertyTestError.testError3])
            .map { Promise(error: $0 )}
            .map(ArbitraryPromiseError.init)
    }
}
