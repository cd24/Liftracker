//
//  Rep+CoreDataProperties.h
//  
//
//  Created by John McAvey on 11/12/15.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Rep.h"

NS_ASSUME_NONNULL_BEGIN

@interface Rep (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *date;
@property (nullable, nonatomic, retain) NSNumber *num_reps;
@property (nullable, nonatomic, retain) NSString *unit;
@property (nullable, nonatomic, retain) NSNumber *weight;
@property (nullable, nonatomic, retain) Exercice *exercice;

@end

NS_ASSUME_NONNULL_END
