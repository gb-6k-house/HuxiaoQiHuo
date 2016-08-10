//
//  FYRaceData_Obj.h
//  traderex
//
//  Created by XXJ on 15/10/26.
//  Copyright © 2015年 EasyFly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FYRaceData_Obj : NSObject


@property (nonatomic, strong) NSString *rewardvalue;    //活动最高奖励


@property (nonatomic, strong) NSString *startdate;         //活动开始时间


@property (nonatomic, strong) NSString *enddate;        //活动结束时间

@property (nonatomic, assign) long id;                 //活动id

@property (nonatomic, assign) long orderby;                 //

@property (nonatomic, strong) NSString *joinfee;        //活动参加费用（暂未用）

@property (nonatomic, strong) NSString *racename;       //活动名字

@property (nonatomic, assign) long racetype;      //活动市场类型

@property (nonatomic, assign) long ranktype;      //活动排行类型  0余额 1收益 2利润率 3胜率

@property (nonatomic, assign) long rewardtype;

@end
