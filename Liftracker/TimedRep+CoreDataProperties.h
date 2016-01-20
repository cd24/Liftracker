//
//  TimedRep+CoreDataProperties.h
//  
//
//  Created by John McAvey on 1/19/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "TimedRep.h"

NS_ASSUME_NONNULL_BEGIN

@interface TimedRep (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *start_time;
@property (nullable, nonatomic, retain) NSDate *end_time;
@property (nullable, nonatomic, retain) NSNumber *duration_minutes;
@property (nullable, nonatomic, retain) NSNumber *weight;
@property (nullable, nonatomic, retain) NSNumber *duration_seconds;
@property (nullable, nonatomic, retain) NSNumber *duration_hours;
@property (nullable, nonatomic, retain) Exercice *exercice;

@end

NS_ASSUME_NONNULL_END
