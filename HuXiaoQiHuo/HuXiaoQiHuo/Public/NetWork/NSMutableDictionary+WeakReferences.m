//
//  NSMutableDictionary+WeakReferences.m
//  yhcServerCoreLib
//
//  Created by liukai on 14-11-27.
//  Copyright (c) 2014年 yhc. All rights reserved.
//

#import "NSMutableDictionary+WeakReferences.h"
// No-ops for non-retaining objects.
static const void * __TTRetainNoOp( CFAllocatorRef allocator, const void * value ) { return value; }
static void         __TTReleaseNoOp( CFAllocatorRef allocator, const void * value ) { }

@interface WeakReferenceObj : NSObject
@property (nonatomic, weak) NSObject *weakRef;
@property (nonatomic, weak) NSMutableDictionary *dicContainal;
@end

@implementation WeakReferenceObj
+ (id)weakReferenceWithObj:(id)obj forDictionary:(NSMutableDictionary *)dictionary{
    WeakReferenceObj *weakObj = [[WeakReferenceObj alloc] init];
    weakObj.weakRef = obj;
    weakObj.dicContainal = dictionary;
    return weakObj;
}

-(id)init{
    self = [super init];
    if (self) {
        /*使用观察者模式无效, weak对象，被系统设置为nil时，不会触发属性改变通知*/
        //监听weaRef对象的变化，当对象赋值为nil时，则从数据字典中删除自己
        //[self addObserver:self forKeyPath:@"weakRef" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    }
    return self;
}
-(void)dealloc{
   // [self removeObserver:self forKeyPath:@"weakRef"];
}

#pragma mark kvo
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"weakRef"])
    {
        if (!self.weakRef) {
            //从数据字典中删除自己
            [self.dicContainal removeObjectForKey:self];
        }
    }
}

@end


@implementation NSMutableDictionary (WeakReferences)
+ (id)noRetainingDictionary
{
    return [self noRetainingDictionaryWithCapacity:0];
}

+ (id)noRetainingDictionaryWithCapacity:(NSUInteger)capacity
{
    CFDictionaryKeyCallBacks keyCallbacks = kCFTypeDictionaryKeyCallBacks;
    CFDictionaryValueCallBacks callbacks = kCFTypeDictionaryValueCallBacks;
    callbacks.retain = __TTRetainNoOp;
    callbacks.release = __TTReleaseNoOp;
    return (__bridge_transfer NSMutableDictionary*)CFDictionaryCreateMutable(nil, capacity, &keyCallbacks, &callbacks);
}

- (void)setWeakReferenceObj:(id)obj forKey:(id <NSCopying>)aKey{
    [self setObject:[WeakReferenceObj weakReferenceWithObj:obj forDictionary:self] forKey:aKey];
}
- (id)weakObjectForKey:(id)aKey{
    WeakReferenceObj *value = [self objectForKey:aKey];
    return value.weakRef;
}

- (void)removeDeallocRef{
    NSMutableArray *deallocKeys = nil;
    for (NSObject *weakRefObj in [self allKeys]) {
        if ([weakRefObj isKindOfClass:[WeakReferenceObj class]]
            &&
            !((WeakReferenceObj*)weakRefObj).weakRef) {
            if (!deallocKeys) {
                deallocKeys = [NSMutableArray array];
            }
            [deallocKeys addObject:weakRefObj];
        }
    }
    if (deallocKeys) {
        [self removeObjectsForKeys:deallocKeys];
    }
    
}

@end
