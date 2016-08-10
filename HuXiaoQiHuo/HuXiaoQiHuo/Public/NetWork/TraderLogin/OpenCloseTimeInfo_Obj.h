//
//  OpenCloseTimeInfo_Obj.h
//  traderex
//
//  Created by XXJ on 15/11/26.
//  Copyright © 2015年 EasyFly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OpenCloseTimeInfo_Obj : NSObject

@property (nonatomic, assign) NSInteger nCount;  //开收盘时间往前推的天数
@property (nonatomic, assign) NSInteger nWeek;  //开收盘时间Week
@property (nonatomic, strong) NSArray *arrayOpenCloseTime; //开收盘时间

@end
