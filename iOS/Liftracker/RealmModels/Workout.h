//
//	Workout.h
//
//	Create by John McAvey on 11/10/2016
//	Copyright © 2016. All rights reserved.
//	Model file Generated using Realm Object Editor: https://github.com/Ahmed-Ali/RealmObjectEditor


#import <Realm/Realm.h>
@class Schedule;
@protocol Schedule;

@interface Workout : RLMObject

@property NSString * name;
@property NSDate * created;
@property NSDate * modified;
@property RLMArray<Schedule> * schedules;

@end
RLM_ARRAY_TYPE(Workout)
