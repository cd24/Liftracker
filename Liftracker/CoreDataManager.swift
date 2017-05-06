//
//  CoreDataManager.swift
//  Liftracker
//
//  Created by John McAvey on 2/27/17.
//  Copyright © 2017 John McAvey. All rights reserved.
//

import Foundation
import CoreData
import PromiseKit

class CoreDataManager: NSObject {
    var context: NSManagedObjectContext
    public static let shared: CoreDataManager = CoreDataManager(modelName: "Liftracker2Model")
    
    private init(modelName: String, databaseName: String = "CoreData.sqlite") {
        guard let url = Bundle.main.url(forResource: modelName, withExtension: "momd") else {
            fatalError("Core Data model could not be retrieved from the bundle.")
        }
        guard let objectModel = NSManagedObjectModel(contentsOf: url) else {
            fatalError("Failed to initialize Object model from url: \(url)")
        }
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: objectModel)
        context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.persistentStoreCoordinator = coordinator
        DispatchQueue.global(qos: .background).async {
            let storeURL = FileUtil
                            .getDocumentDirectory()
                            .appendingPathComponent(databaseName)
            
            do {
                try coordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                                   configurationName: nil,
                                                   at: storeURL,
                                                   options: nil)
            } catch {
                fatalError("Failed to migrate store: \(error)")
            }
        }
    }
    
    func saveContext() -> Bool {
        do {
            try context.save()
            return true
        } catch {
            log.error("Error saving context")
            log.error(error)
            return false
        }
    }
    
    func createObject<T: NSManagedObject>() -> T? {
        let name = nameFor(entity: T.self)
        log.verbose("Requesting entity of type: \(name)")
        return NSEntityDescription.insertNewObject(forEntityName: name, into: context) as? T
    }
    
    func delete(objects: [NSManagedObject]) {
        objects.forEach {
            self.context.delete($0)
        }
    }
    
    func delete(object: NSManagedObject) {
        delete(objects: [object])
    }
    
    func nameFor<T: NSManagedObject>(entity: T.Type) -> String {
        return "\(T.self)"
    }
    
    func getEntities<T: NSManagedObject>(of type: T.Type, withSortDescriptors descriptors: [NSSortDescriptor] = [], withPredicate predicate: NSPredicate? = nil) -> Promise<[T]> {
        return Promise { fufill, reject in
            let name = self.nameFor(entity: type)
            let request: NSFetchRequest<T> = NSFetchRequest(entityName: name)
            request.sortDescriptors = descriptors
            request.predicate = predicate
            do {
                let results = try context.fetch(request)
                fufill( results )
            } catch {
                reject( error )
            }
        }
    }
}
