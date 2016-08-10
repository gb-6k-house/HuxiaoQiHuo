//
//  LoginJson_Tags_Obj.h
//  Trader
//
//  Created by zhouqing on 15/5/4.
//  Copyright (c) 2015年 easyfly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Login_Tags_Obj : NSObject
@property NSUInteger ID;
@property(nonatomic,copy)NSString * name;
@property(nonatomic, strong) NSNumber * order;
@property NSUInteger parentID;
@end
