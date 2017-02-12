//
//  File.swift
//  Liftracker
//
//  Created by John McAvey on 12/4/16.
//  Copyright © 2016 John McAvey. All rights reserved.
//

import Foundation
import RealmSwift

class Exercice: Object {
    
    dynamic var name = ""
    dynamic var type = ""
    dynamic var category: Category?
}
