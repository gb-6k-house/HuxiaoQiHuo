//
//  NSMutableArray+WeakReferences.m
//  yhcServerCoreLib
//
//  Created by liukai on 14-11-3.
//  Copyright (c) 2014年 yhc. All rights reserved.
//

#import "NSMutableArray+WeakReferences.h"

@implementation NSMutableArray (WeakReferences)
// No-ops for non-retaining objects.
static const void * __TTRetainNoOp( CFAllocatorRef allocator, const void * value ) { return value; }
static void         __TTReleaseNoOp( CFAllocatorRef allocator, const void * value ) { }


+ (id)noRetainingArray
{
    return [self noRetainingArrayWithCapacity:0];
}

+ (id)noRetainingArrayWithCapacity:(NSUInteger)capacity
{
    CFArrayCallBacks callbacks = kCFTypeArrayCallBacks;
    callbacks.retain = __TTRetainNoOp;
    callbacks.release = __TTReleaseNoOp;
    return (__bridge_transfer NSMutableArray*)CFArrayCreateMutable(nil, capacity, &callbacks);
}

@end
