//
//  Rep.swift
//  Liftracker
//
//  Created by John McAvey on 5/13/18.
//  Copyright © 2018 John McAvey. All rights reserved.
//

import Foundation
import RealmSwift

public class Rep: Object {
    public var count: Double = 0.0
    public var performedAt: Date = Date()
    public var duration: Double = 0
}
