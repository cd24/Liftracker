//
//  KVSpec.swift
//  LiftrackerTests
//
//  Created by John McAvey on 2/20/18.
//  Copyright © 2018 John McAvey. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import Liftracker

public class KVSpec: QuickSpec {
    public override func spec() {
        describe("UserDefaults dependencies") {
            it("can store a string for a string key") {
                UserDefaults.standard.set("test.key", forKey: "test.key")
            }
            it("can store and retrieve a string") {
                let v = "test.key"
                UserDefaults.standard.set(v, forKey: v)
                expect(UserDefaults.standard.string(forKey: v)).to(equal(v))
            }
        }
        describe("KVStore") {
            it("can create a KVEntry from a key") {
                let key = "k"
                let _: KVEntry<String> = UserDefaults.standard.entry(key)
            }
        }
        describe("KVEntry") {
            it("is polymorphic") {
                let _: KVEntry<Int> = UserDefaults.standard.entry("test.key")
                let _: KVEntry<String> = UserDefaults.standard.entry("test.key")
                let _: KVEntry<Double> = UserDefaults.standard.entry("test.key")
            }
            it("stores and retrieves the same value") {
                let value = 2
                let entry: KVEntry<Int> = UserDefaults.standard.entry("test.key")
                expect(entry.get()).to(beNil())
                entry.set(value)
                expect(entry.get()).to(equal(value))
            }
            it("can reset the value to nil") {
                let entry: KVEntry<Int> = UserDefaults.standard.entry("test.key")
                entry.clear()
                expect(entry.get()).to(beNil())
                entry.set(2)
                expect(entry.get()).to(equal(2))
                entry.clear()
                expect(entry.get()).to(beNil())
            }
        }
    }
}
