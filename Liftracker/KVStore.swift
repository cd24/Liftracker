//
//  PreferenceStore.swift
//  Liftracker
//
//  Created by John McAvey on 2/12/17.
//  Copyright © 2017 John McAvey. All rights reserved.
//

import Foundation
import os.log

public protocol KVStore {
    func put<T>(_ object: T, for key: KVEntry<T>)
    func get<T>(for key: KVEntry<T>) -> T?
    func clear<T>(for key: KVEntry<T>)
}

extension KVStore {
    // TODO: Document
    public func entry<T: Codable>(_ name: String) -> KVEntry<T> {
        os_log("Creating new entry named %s in store %s",
               log: storeLog,
               type: .debug,
               name,
               "\(type(of: self))")
        return KVEntry(name, store: self)
    }
}
