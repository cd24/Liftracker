//
//	Schedule.h
//
//	Create by John McAvey on 18/9/2016
//	Copyright © 2016. All rights reserved.
//	Model file Generated using Realm Object Editor: https://github.com/Ahmed-Ali/RealmObjectEditor


#import <Realm/Realm.h>

@interface Schedule : RLMObject

@property NSString * name;
@property NSInteger day;
@property NSInteger hour;
@property NSInteger minute;

@end
RLM_ARRAY_TYPE(Schedule)