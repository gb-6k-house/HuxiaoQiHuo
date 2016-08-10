//
//  NSMutableDictionary+WeakReferences.h
//  yhcServerCoreLib
//
//  Created by liukai on 14-11-27.
//  Copyright (c) 2014年 yhc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (WeakReferences)
/*
 *弱引用对象数据字典，但是对象释放时，字典中的对象并不为nil，存在也野指针
 */
+ (id)noRetainingDictionary;
+ (id)noRetainingDictionaryWithCapacity:(NSUInteger)capacity;

//设置弱引用对象
- (void)setWeakReferenceObj:(id)obj forKey:(id <NSCopying>)aKey;
//获取弱引用对象
- (id)weakObjectForKey:(id)aKey;
- (void)removeDeallocRef;
@end
