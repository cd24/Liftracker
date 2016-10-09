//
//  ReflectionTests.swift
//  Liftracker
//
//  Created by John McAvey on 10/8/16.
//  Copyright © 2016 John McAvey. All rights reserved.
//

import XCTest
@testable import Liftracker

class ReflectionTests : XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGetProtocol() {
        
        var cls: [AnyClass] = ReflectionUtil.getImplementing( FirstTestProtocol.self )
        
        XCTAssert(cls.count == 3, "Returned the wrong number of First Protocol classes")
        NSLog("Retrieved the following classes: \(cls)")
        
        cls = ReflectionUtil.getImplementing( SecondTestProtocol.self )
        XCTAssert(cls.count == 0, "Returned the wrong number of Second Protocol classes")
    }
}

@objc protocol FirstTestProtocol {
    
    func getName() -> String
}

@objc protocol SecondTestProtocol {
    
    func myName() -> String
}

class FirstTestClass : FirstTestProtocol {
    
    func getName() -> String {
        return "First"
    }
}

class SecondTestClass : FirstTestProtocol {
    
    func getName() -> String {
        return "Second"
    }
}

class ThirdTestClass : FirstTestProtocol {
    
    func getName() -> String {
        return "Third"
    }
}

