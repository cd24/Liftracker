//
//	Repetition.h
//
//	Create by John McAvey on 11/10/2016
//	Copyright © 2016. All rights reserved.
//	Model file Generated using Realm Object Editor: https://github.com/Ahmed-Ali/RealmObjectEditor


#import <Realm/Realm.h>
@class Exercice;
@protocol Exercice;

@interface Repetition : RLMObject

@property NSDate * date;
@property double actual_weight;
@property double target_weight;
@property Exercice * exercice;

@end
RLM_ARRAY_TYPE(Repetition)