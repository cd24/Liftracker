//
//  PreferenceStore.swift
//  Liftracker
//
//  Created by John McAvey on 2/12/17.
//  Copyright © 2017 John McAvey. All rights reserved.
//

import Foundation

public protocol PreferenceStore {
    func put(_ object: Any, for key: Preference)
    func get<T>(for key: Preference) -> T?
}

extension UserDefaults: PreferenceStore {
    public func put(_ object: Any, for key: Preference) {
        self.set(object, forKey: key.rawValue)
    }
    
    public func get<T>(for key: Preference) -> T? {
        return  self.object(forKey: key.rawValue) as? T
    }
}
