//
//  Promise+Applicative.swift
//  Liftracker
//
//  Created by John McAvey on 2/13/17.
//  Copyright © 2016 John McAvey. All rights reserved.
//

import Foundation
import Runes
import PromiseKit

public func <*> <T, Q>(_ f: Promise<(T)->Q>, _ a: Promise<T>) -> Promise<Q> {
    return a.apply( f )
}

public func <* <T>(_ keep: Promise<T>, _ discard: AnyPromise) -> Promise<T> {
    return keep.applyDiscardingResult(from: discard)
}

public func *> <T>(_ discard: AnyPromise, _ keep: Promise<T>) -> Promise<T> {
    return keep <* discard
}

public func pure<T>(_ value: T) -> Promise<T> {
    return Promise(value: value)
}

extension Promise {
    public func apply<Q>(_ f: Promise<(T)->Q>) -> Promise<Q> {
        return f.then { (fn: @escaping (T)->Q) -> Promise<Q> in
            return fn <^> self
        }
    }
    
    public func applyDiscardingResult(from next: AnyPromise) -> Promise<T> {
        return self.then { value in
            next.then { _ in
                return Promise(value: value)
            }
        }
    }
}
