//
//	Exercice.h
//
//	Create by John McAvey on 18/9/2016
//	Copyright © 2016. All rights reserved.
//	Model file Generated using Realm Object Editor: https://github.com/Ahmed-Ali/RealmObjectEditor


#import <Realm/Realm.h>
@class Type;
@protocol Type;

@interface Exercice : RLMObject

@property NSString * name;
@property Type * type;

@end
RLM_ARRAY_TYPE(Exercice)