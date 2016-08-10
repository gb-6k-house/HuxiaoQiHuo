//
//  OpenCloseTime_Obj.h
//  Trader
//
//  Created by easyfly on 2/12/14.
//  Copyright (c) 2014 easyfly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OpenCloseTime_Obj : NSObject

@property(nonatomic,copy)NSString * strOpentime;
@property(nonatomic,copy)NSString * strClosetime;
@property int nDay;   //往后推的天数
@property(nonatomic,copy)NSString *strSign;   //如果为"+"开盘时间往前推 如果为"-"收盘时间往后推
@end
