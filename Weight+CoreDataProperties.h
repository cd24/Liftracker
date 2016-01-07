//
//  Weight+CoreDataProperties.h
//  
//
//  Created by John McAvey on 1/6/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Weight.h"

NS_ASSUME_NONNULL_BEGIN

@interface Weight (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *value;
@property (nullable, nonatomic, retain) NSString *notes;

@end

NS_ASSUME_NONNULL_END
