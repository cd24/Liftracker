//
//  PromisedRealm.swift
//  Liftracker
//
//  Created by John McAvey on 5/13/18.
//  Copyright © 2018 John McAvey. All rights reserved.
//

import Foundation
import PromiseKit
import RealmSwift

public enum DataError: Error {
    case unkownError
}

/**
 Wraps Realms async open in a promise.
 - parameter config: The configuration to supply for generating the realm. Defaults to the current default.
 */
public func realm(config: Realm.Configuration = Realm.Configuration.defaultConfiguration) -> Promise<Realm> {
    return Promise {
        do {
            let realm = try Realm()
            $0.fulfill(realm)
        } catch {
            $0.reject(error)
        }
    }
}
