
//
//  Promise+Alternative.swift
//  Liftracker
//
//  Created by John McAvey on 6/12/17.
//

import PromiseKit
import Runes

/**
 Alternative acts as a way to cascade through failing promises. If the first member of `<|>` fails, then the next is
 evaluated in its stead.
 Example:
 ```
 func doSomeRemoteOperation() -> Promise<String> { return Promise(error: NSError()) }
 func doSomeLocalOperation() -> Promise<String> { return Promise(value: "Local") }
 func doMyThing() {
 // Always "Local"
 let defaultToLocal = doSomeRemoteOperation() <|> doSomeLocalOperation()
 defaultToLocal.then { print($0) }
 .catch { print("Encountered error: \($0)") }
 }
 ```
 Observe that this operation is chainable, with left associativity. In this way, you can chain the operations
 together with defaults to help prevent the need for error catching on the UI.
 Example:
 Suppose we have some additional string `K` which we want to be returned if both our remote and local operations
 fail.
 Then we can wrap `K` in pure to return it in place:
 ```
 ...
 let defaultsToK = doSomeRemoteOperation() <|> doSomeLocalOperation() <|> pure( K )
 ...
 ```
 Note that this will always be a promise, you must still check and catch errors at the end.
 */
public func <|> <T>(_ first: Promise<T>, _ second: Promise<T> ) -> Promise<T> {
    return first.alternative( second )
}

extension Promise {
    
    public enum PromiseError: Error {
        case empty
    }
    
    /**
     Alternative acts as a wrapper to `recover` for Promises. If the reciever fails, then the provided Promise will be
     returned instead.
     - parameters with: The Promise to recover with.
     */
    public func alternative(_ with: Promise<T>) -> Promise<T> {
        return self.recover { (error: Error) -> Promise<T> in
            return with
        }
    }
    
    public static func empty<T>() -> Promise<T> {
        return Promise(error: PromiseError.empty) as! Promise<T>
    }
}
