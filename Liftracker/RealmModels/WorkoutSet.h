//
//	WorkoutSet.h
//
//	Create by John McAvey on 18/9/2016
//	Copyright © 2016. All rights reserved.
//	Model file Generated using Realm Object Editor: https://github.com/Ahmed-Ali/RealmObjectEditor


#import <Realm/Realm.h>
@class Exercice;
@protocol Exercice;
@class WorkoutRep;
@protocol WorkoutRep;

@interface WorkoutSet : RLMObject

@property double target_time;
@property Exercice * exercice;
@property WorkoutRep * target_reps;

@end
RLM_ARRAY_TYPE(WorkoutSet)