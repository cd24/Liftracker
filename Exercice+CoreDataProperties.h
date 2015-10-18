//
//  Exercice+CoreDataProperties.h
//  Liftracker
//
//  Created by John McAvey on 10/14/15.
//  Copyright © 2015 MCApps. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Exercice.h"

NS_ASSUME_NONNULL_BEGIN

@interface Exercice (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *best;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) MuscleGroup *muscle_group;

@end

NS_ASSUME_NONNULL_END
