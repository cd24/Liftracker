//
//  Exercice+CoreDataProperties.swift
//  
//
//  Created by John McAvey on 5/6/17.
//
//

import Foundation
import CoreData


extension Exercice {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Exercice> {
        return NSFetchRequest<Exercice>(entityName: "Exercice")
    }

    @NSManaged public var name: String?
    @NSManaged public var type: String?
    @NSManaged public var category: Category?

}
