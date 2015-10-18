//
//  Rep+CoreDataProperties.h
//  Liftracker
//
//  Created by John McAvey on 10/14/15.
//  Copyright © 2015 MCApps. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Rep.h"

NS_ASSUME_NONNULL_BEGIN

@interface Rep (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *num_reps;
@property (nullable, nonatomic, retain) NSNumber *weight;
@property (nullable, nonatomic, retain) Exercice *exercice;
@property (nullable, nonatomic, retain) Day *day;

@end

NS_ASSUME_NONNULL_END
