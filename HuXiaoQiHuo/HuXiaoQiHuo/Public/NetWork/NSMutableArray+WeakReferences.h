//
//  NSMutableArray+WeakReferences.h
//  yhcServerCoreLib
//
//  Created by liukai on 14-11-3.
//  Copyright (c) 2014年 yhc. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 *弱引用，不会retain release
 */
@interface NSMutableArray (WeakReferences)
/*
 *弱引用对象数组，但是对象释放，字典中的对象并不为nil，存在也野指针
 */
+ (id)noRetainingArray;
+ (id)noRetainingArrayWithCapacity:(NSUInteger)capacity;

@end
