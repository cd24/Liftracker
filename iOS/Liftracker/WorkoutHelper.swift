//
//  WorkoutHelper.swift
//  Liftracker
//
//  Created by John McAvey on 10/14/16.
//  Copyright © 2016 John McAvey. All rights reserved.
//

import Foundation

/**
 Provides an interface for working with workouts which is independent of the database
 */
class WorkoutHelper {
    
    /**
     Adds the default workouts which are not present and have not been deleted by the user.
    */
    static func addDefaultWorkouts() {
        // Right now adds a test workout
        // TODO: create files and add to bundle - use decode to create and insert the objects.
        // TODO: Update workout model to have an identifier which can be the primary key
        let freeForm = Workout()
        freeForm.name = "Free Form"
        freeForm.created = Date()
        freeForm.modified = freeForm.created
        
        RLMRealm.default().write(block: { realm in
            realm.add( freeForm )
        })
    }
    
    /**
     Retrieves all the workouts from the data store
    */
    static func getAll() -> [Workout] {
        let results = Workout.allObjects()
        var workouts = [Workout]()
        
        for result in results {
            if let item = result as? Workout {
                workouts.append( item )
            }
        }
        
        return workouts
    }
    
    /**
     Retrieves all the exercices which are tied to the provided workout
     - Parameter workout: the workout to search against
     - Returns: All exercices which match the provided workout
    */
    static func getExercices( workout: Workout ) -> [Exercice] {
        
        let predicate = NSPredicate(format: "workout == %@", workout)
        let results = Exercice.objects(with: predicate)
        
        var exercices = [Exercice]()
        
        for result in results {
            if let exercice = result as? Exercice {
                exercices.append( exercice )
            }
        }
        
        return exercices
    }
    
    /**
     Encodes a workout for preservation.  Largely intended for sharing functionality - is not garunteed to be human readable
     
     - Parameter workout: the workout to encode as a string
     - Returns: a `String` containing the encoded data
    */
    static func encode( workout: Workout ) -> String {
        // TODO: Encode the workout for preservation to file.
        return ""
    }
    
    /**
     Restores a workout object from the provided file path.  
     
     - Parameter path: path to the file to be decoded
     - Returns: a workout object if it can be retrieved or nil if there was an issue decoding the object
    */
    static func decode( atPath path: URL ) -> Workout? {
        // TODO: Retrieve workout from file at provided path and attempt to decode it into a workout
        return nil
    }
}
