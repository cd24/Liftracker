//
//	Set.h
//
//	Create by John McAvey on 7/10/2016
//	Copyright © 2016. All rights reserved.
//	Model file Generated using Realm Object Editor: https://github.com/Ahmed-Ali/RealmObjectEditor


#import <Realm/Realm.h>
@class Exercice;
@protocol Exercice;
@class Repetition;
@protocol Repetition;

@interface Set : RLMObject

@property NSInteger target;
@property NSInteger actual;
@property BOOL from_workout;
@property Exercice * exercice;
@property RLMArray<Repetition> * reps;

@end
RLM_ARRAY_TYPE(Set)