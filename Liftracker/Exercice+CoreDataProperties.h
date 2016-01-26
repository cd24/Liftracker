//
//  Exercice+CoreDataProperties.h
//  
//
//  Created by John McAvey on 1/24/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Exercice.h"

NS_ASSUME_NONNULL_BEGIN

@interface Exercice (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *best;
@property (nullable, nonatomic, retain) NSNumber *isTimed;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) MuscleGroup *muscle_group;

@end

NS_ASSUME_NONNULL_END
