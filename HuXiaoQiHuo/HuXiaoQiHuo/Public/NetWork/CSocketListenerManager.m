//
//  CSocketListenerManager.m
//  HuXiaoQiHuo
//
//  Created by niupark on 16/5/20.
//  Copyright © 2016年 fukeng. All rights reserved.
//

#import "CSocketListenerManager.h"
#import "NSMutableArray+WeakReferences.h"
@interface CSocketListenerManager() {
    NSMutableArray *_listenerArray;
}
@end
@implementation CSocketListenerManager
-(instancetype)init{
    self = [super init];
    if (self) {
        _listenerArray = [NSMutableArray noRetainingArray];
    }
    return self;
}

+ (instancetype)sharedInstance
{
    static CSocketListenerManager *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc ] init];
    });
    return _sharedInstance;
}


-(void)registerListener:(NSObject *)observer{
    [_listenerArray addObject:observer];
}
-(void)unregisterListener:(NSObject *)observer{
    [_listenerArray removeObject:observer];
}
-(void)callBack:(SEL)sel withObjcet:(id)object{
    dispatch_async(dispatch_get_main_queue(), ^{
        for (NSObject *obj in _listenerArray) {
            if ([obj respondsToSelector:sel]) {
                //使用[obj performSelector:sel withObject:object]会有警告"performselector may cause a leak"
                [obj performSelector:sel withObject:object afterDelay:0.0f];
            }
        }

    });
}

@end
