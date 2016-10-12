//
//	WorkoutRep.h
//
//	Create by John McAvey on 11/10/2016
//	Copyright © 2016. All rights reserved.
//	Model file Generated using Realm Object Editor: https://github.com/Ahmed-Ali/RealmObjectEditor


#import <Realm/Realm.h>
@class Exercice;
@protocol Exercice;

@interface WorkoutRep : RLMObject

@property NSInteger target;
@property Exercice * exercie;

@end
RLM_ARRAY_TYPE(WorkoutRep)