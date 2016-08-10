//
//  OCTDic_Obj.h
//  Trader
//
//  Created by cssoft on 14-7-14.
//  Copyright (c) 2014年 easyfly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OCTDic_Obj : NSObject

@property(nonatomic, strong) NSArray *arrayOTCT;
@property(nonatomic, strong) NSArray *arrayWeek;
//@property NSMutableDictionary *dicWeek;  //礼拜几为key,value为需推迟的天数
//@property NSMutableDictionary *dicWeekSign;   //如果为"+"就把收盘时间往后推"-"把开盘时间往前推,如果为“0”按原来的逻辑，找到合适的礼拜几

@end
