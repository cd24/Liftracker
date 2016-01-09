//
//  MuscleGroup+CoreDataProperties.h
//  
//
//  Created by John McAvey on 1/8/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "MuscleGroup.h"

NS_ASSUME_NONNULL_BEGIN

@interface MuscleGroup (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;

@end

NS_ASSUME_NONNULL_END
