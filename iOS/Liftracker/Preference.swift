//
//  Preference.swift
//  Liftracker
//
//  Created by John McAvey on 2/12/17.
//  Copyright © 2017 John McAvey. All rights reserved.
//

import Foundation

/**
 Preferences provide a simple way to interact with the key-value store for the application.
 To use a Preference, you need to declare the preference. Declare a preference as follows:
 ```
 extension Preference {
 static let myPreference = Preference("com.myapp.keyname")
 }
 ```
 Then interacting with your preference is as simple as:
 ```
 Preference.myPreference.set("Store this value")
 let storedPhrase: String = Preference.myPreference.get() // will be "Store this value"
 ```
 */
public struct Preference: RawRepresentable, Equatable, Hashable, Comparable {
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
    public func set(_ value: Any) {
        PreferenceUtil.put(value, for: self)
    }
    
    /**
     Retrieves the requested value. Requires that the retrieved type is specified.
     Example
     ```
     let myInfo: String? = Preference.myPreference.get()
     ```
     */
    public func get<T: Any>() -> T? {
        return PreferenceUtil.get(for: self)
    }
    
    /// Defaults to false
    public func bool() -> Bool {
        if let boolValue: Bool = self.get() {
            return boolValue
        }
        return false
    }
    
    /// Defaults to 0
    public func int() -> Int {
        if let intVal: Int = self.get() {
            return intVal
        }
        return 0
    }
    
    /// Defaults to 0
    public func long() -> Int64 {
        if let intVal: Int64 = self.get() {
            return intVal
        }
        return 0
    }
    
    /// Defaults to empty string
    public func string() -> String {
        if let strVal: String = self.get() {
            return strVal
        }
        return ""
    }
    
    /// If the value cannot be converted to a date (is non-numeric, non-date) then this method with return the current date
    public func date() -> Date {
        if let date: Date = self.get() {
            return date
        }
        let ts: TimeInterval
        if let doubleTS: Double = self.get() {
            ts = TimeInterval( doubleTS )
        } else if let intTS: Int = self.get() {
            ts = TimeInterval( intTS )
        } else if let floatTS: Float = self.get() {
            ts = TimeInterval( floatTS )
        } else if let intTS: Int64 = self.get() {
            ts = TimeInterval( intTS )
        } else if let floatTS: Float64 = self.get() {
            ts = TimeInterval( floatTS )
        } else {
            ts = Date().timeIntervalSince1970
        }
        return Date(timeIntervalSince1970: ts)
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
