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

public func <^> <T, U>( _ f: @escaping (T) -> U, _ a: Promise<T>) -> Promise<U> {
    return a.fmap( f )
}

extension Promise where T: Any {
    public func fmap<U>(_ f: @escaping (T)->U) -> Promise<U> {
        let ret: Promise<U> = self.then { value in
            return Promise<U>(value: f(value) )
        }
        return ret
    }
}
