//
//  Preference.swift
//  Liftracker
//
//  Created by John McAvey on 2/12/17.
//  Copyright © 2017 John McAvey. All rights reserved.
//

import Foundation

/**
 This struct acts as a wrapper around storing user preferences. It uses the `PreferenceUtil` class to interact with the specified user preference store.
 Declaring the type of the preference in T allows us to compile-time check the use of preference stores. This will, however, be limited to the scope of the definition of the preference.
 - Type T: The type of data stored in the preference.
 */
public struct Preference<T>: RawRepresentable, Equatable, Hashable, Comparable {
    public var rawValue: String {
        didSet {
            self.hashValue = self.rawValue.hashValue
        }
    }
    public var hashValue: Int
    public typealias RawValue = String
    
    public init(_ rawValue: String){
        self.rawValue = rawValue
        self.hashValue = rawValue.hashValue
    }
    public init(rawValue: String) {
        self.rawValue = rawValue
        self.hashValue = rawValue.hashValue
    }
    
    // MARK :- Convinience Operators
    
    /**
     Sets the provided value for the preference.
     - parameter value: The value to set for the prefeence
     */
    public func set(_ value: T) {
        PreferenceUtil.put(value, for: self)
    }
    
    /**
     Retrieves the requested value. Requires that the retrieved type is specified.
     Example
     ```
     let myInfo = myPreference.get()
     ```
     - returns: The value at the preference, if it exists
     */
    public func get() -> T? {
        return PreferenceUtil.get(for: self)
    }
    
    /**
     Provided for when it's inconvinient to use the `??` operator.
     - parameter def: the value to return if the pereference is empty.
     - returns: The preference value if possible, or the provided default value
    */
    public func getOrDefault(_ def: T) -> T {
        return get() ?? def
    }
    
    // MARK: - Equatable, Comparable
    
    public static func ==(lhs: Preference, rhs: Preference) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
    
    public static func <(lhs: Preference, rhs: Preference) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
    
    public static func <=(lhs: Preference, rhs: Preference) -> Bool {
        return lhs.rawValue <= rhs.rawValue
    }
    
    public static func >(lhs: Preference, rhs: Preference) -> Bool {
        return lhs.rawValue > rhs.rawValue
    }
    
    public static func >=(lhs: Preference, rhs: Preference) -> Bool {
        return lhs.rawValue >= rhs.rawValue
    }
}
