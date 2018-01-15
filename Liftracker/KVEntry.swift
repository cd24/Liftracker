//
//  Preference.swift
//  Liftracker
//
//  Created by John McAvey on 2/12/17.
//  Copyright © 2017 John McAvey. All rights reserved.
//

import Foundation
import os.log

public let preferencesLogs = logSystem("preferences")
public let entryLog = preferencesLogs("Entry")
public let storeLog = preferencesLogs("Store")

/**
 KVEntry provide a simple way to interact with the key-value store for the application.
 To use a KVEntry, you need to declare a reference in the required scope. Declare a preference as follows:
 ```
 let myKVEntry: KVEntry<String> = myKVStore.entry("com.myapp.keyname")
 ```
 Then interacting with your entry is as simple as:
 ```
 myKVEntry.set("Store this value")
 let storedPhrase: String = myKVEntry.get() // will be "Store this value"
 ```
 */
public struct KVEntry<T: Codable>: RawRepresentable, Equatable, Hashable, Comparable {
    public var rawValue: String {
        didSet {
            self.hashValue = self.rawValue.hashValue
            os_log("Changed hash for KVEntry named %s to %d",
                   log: entryLog,
                   type: .debug,
                   self.rawValue,
                   self.hashValue)
        }
    }
    public var hashValue: Int
    public var store: KVStore? = nil
    
    public typealias RawValue = String
    
    public init(_ rawValue: String, store: KVStore) {
        self.rawValue = rawValue
        self.hashValue = rawValue.hashValue
        self.store = store
        os_log("Created new KVEntry with name: %s, hashValue: %d",
               log: entryLog,
               type: .debug,
               rawValue,
               hashValue)
    }
    
    public init(rawValue: String) {
        self.rawValue = rawValue
        self.hashValue = rawValue.hashValue
        os_log("Created new KVEntry with name: %s, hashValue: %d",
               log: entryLog,
               type: .debug,
               rawValue,
               hashValue)
    }
    
    // MARK :- Convinience Operators
    
    /**
     Sets the provided value for the KVEntry.
     - parameter value: The value to set for the KVEntry
     */
    public func set(_ value: T) {
        guard let store = self.store else {
            os_log("Store not set for KVEntry named '%s'",
                   log: entryLog,
                   type: .error,
                   self.rawValue)
            return
        }
        store.put(value, for: self)
    }
    
    /**
     Retrieves the requested value. Requires that the retrieved type is specified.
     Example
     ```
     let myInfo: String? = myKVEntry.get()
     ```
     */
    public func get() -> T? {
        guard let store = self.store else {
            os_log("Store not set for KVEntry named '%s'",
                   log: entryLog,
                   type: .error,
                   self.rawValue)
            return nil
        }
        let val = store.get(for: self)
        return val
    }
    
    // MARK: - Equatable, Comparable
    
    public static func ==(lhs: KVEntry, rhs: KVEntry) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
    
    public static func <(lhs: KVEntry, rhs: KVEntry) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
    
    public static func <=(lhs: KVEntry, rhs: KVEntry) -> Bool {
        return lhs.rawValue <= rhs.rawValue
    }
    
    public static func >(lhs: KVEntry, rhs: KVEntry) -> Bool {
        return lhs.rawValue > rhs.rawValue
    }
    
    public static func >=(lhs: KVEntry, rhs: KVEntry) -> Bool {
        return lhs.rawValue >= rhs.rawValue
    }
}

// MARK :- Convinience

public func defaultsEntry<T>(_ name: String) -> KVEntry<T> {
    return UserDefaults.standard.entry(name)
}
