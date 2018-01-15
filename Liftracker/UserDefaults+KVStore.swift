//
//  UserDefaults+KVStore.swift
//  Liftracker
//
//  Created by John McAvey on 1/14/18.
//  Copyright © 2018 John McAvey. All rights reserved.
//

import Foundation
import os.log

struct Coding {
    public static let encoder = JSONEncoder()
    public static let decoder = JSONDecoder()
}

extension UserDefaults: KVStore {
    public func put<T>(_ object: T, for key: KVEntry<T>) {
        do {
            let data = try Coding.encoder.encode(object)
            self.set(data, forKey: key.rawValue)
        } catch {
            os_log("UserDefaults: Unable to encode object of type %s. Not saved to preferences",
                   log: storeLog,
                   type: .error,
                   "\(T.self)")
        }
        self.set(object, forKey: key.rawValue)
    }
    
    public func get<T>(for key: KVEntry<T>) -> T? {
        os_log("Attempting to retrieve value for entry %s in store %s",
               log: entryLog,
               type: .debug,
               key.rawValue,
               "\(UserDefaults.self)")
        guard let storedData = self.data(forKey: key.rawValue) else {
            os_log("No value found",
                   log: storeLog,
                   type: .debug)
            return nil
        }
        os_log("Retrieved value... attempting decoding",
               log: storeLog,
               type: .debug,
               key.rawValue)
        do {
            let decoded = try Coding.decoder.decode(T.self, from: storedData)
            os_log("Decoded value %s",
                   log: storeLog,
                   type: .debug,
                   "\(decoded)")
            return decoded
        } catch {
            os_log("UserDefaults: Unable to decode object type %s from data: %s",
                   log: storeLog,
                   type: .error,
                   "\(T.self)", storedData.base64EncodedString())
            return nil
        }
    }
}
