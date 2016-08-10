//
//  Tags_Obj.h
//  Trader
//
//  Created by zhouqing on 15/5/4.
//  Copyright (c) 2015年 easyfly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tags_Obj : NSObject
@property(nonatomic,copy)NSString * name;
@property NSUInteger ID;
@property(nonatomic, strong)NSNumber * order;
@property NSUInteger parentID;
@end
