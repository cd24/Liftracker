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

/**
 Allows composition of promise functions by lifting the value of a success and forwarding it to the second.
 Example:
 ```
 func executeIf(able: Bool) -> Promise<Double> {
    return able ?
        Promise(value: 10) :
        Promise(error: NSError())
 }
 
 func sendMyMessage(_ message: Double) -> Promise<String> {
    return Promise(value: "Sent! I swear.")
 }
 
 class myClass {
    let test = executeIf >-> sendMyMessage // Type: (Bool) -> Promise<String>
 }

 ```
 - parameters:
    - first: A function taking some input type T and returning a promise of an intermediate value U
    - second: A function taking some intermediate type U and returning a promise of the result type Z
 - returns: A function taking some input T and returning a promise of type Z.
 - SeeAlso: <-<
 */
public func >-> <T, U, Z>(_ first: @escaping (T) -> Promise<U>, _ second: @escaping (U) -> Promise<Z>) -> (T) -> Promise<Z> {
    return {
        first($0)
        .then { result in
            return second(result)
        }
    }
}

/**
 Allows composition of promise functions by lifting the value of a success and forwarding it to the second.
 Example:
 ```
 func executeIf(able: Bool) -> Promise<Double> {
    return able ?
        Promise(value: 10) :
        Promise(error: NSError())
 }
 
 func sendMyMessage(_ message: Double) -> Promise<String> {
    return Promise(value: "Sent! I swear.")
 }
 
 class myClass {
    let test = executeIf >-> sendMyMessage // Type: (Bool) -> Promise<String>
 }
 
 ```
 - parameters:
    - second: A function taking some intermediate type U and returning a promise of the result type Z
    - first: A function taking some input type T and returning a promise of an intermediate value U
 - returns: A function taking some input T and returning a promise of type Z.
 - SeeAlso: >->
 */
public func <-< <T, U, Z>(_ second: @escaping (U) -> Promise<Z>, _ first: @escaping (T) -> Promise<U>) -> (T) -> Promise<Z> {
    return first >-> second
}

public func >>- <T, U>(_ a: Promise<T>, _ fn: @escaping (T)->Promise<U>) -> Promise<U> {
    return a.bind( fn )
}

public func -<< <T, U>(_ fn: @escaping (T)->Promise<U>, _ a: Promise<T>) -> Promise<U> {
    return a >>- fn
}

public func >> <T, U>(_ a: Promise<T>, _ next: Promise<U>) -> Promise<U> {
    return a.forward( next )
}

public func << <T, U>(_ next: Promise<U>, _ a: Promise<T>) -> Promise<U> {
    return a >> next
}

extension Promise {
    public func bind<U>(_ fn: @escaping (T)->Promise<U>) -> Promise<U> {
        return self.then { value in
            return fn( value )
        }
    }

    public func forward<U>(_ next: Promise<U>) -> Promise<U> {
        return self.then { value in
            return next
        }
    }
}
