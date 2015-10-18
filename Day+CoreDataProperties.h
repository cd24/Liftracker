//
//  Day+CoreDataProperties.h
//  Liftracker
//
//  Created by John McAvey on 10/18/15.
//  Copyright © 2015 MCApps. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Day.h"

NS_ASSUME_NONNULL_BEGIN

@interface Day (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *date;

@end

NS_ASSUME_NONNULL_END
