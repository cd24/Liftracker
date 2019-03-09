//
//  Exercice.swift
//  Liftracker
//
//  Created by John McAvey on 5/13/18.
//  Copyright © 2018 John McAvey. All rights reserved.
//

import Foundation
import RealmSwift

public class Exercice: Object {
    public var name: String = ""
    public var type: String = ""
    public var category: Category? = nil
}
