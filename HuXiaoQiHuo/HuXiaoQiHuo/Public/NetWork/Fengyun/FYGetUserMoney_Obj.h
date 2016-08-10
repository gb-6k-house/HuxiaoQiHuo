//
//  FYGetUserMoney_Obj.h
//  traderex
//
//  Created by cssoft on 15/10/27.
//  Copyright © 2015年 EasyFly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FYGetUserMoney_Obj : NSObject

@property (nonatomic,retain) NSString *strCode;//成功  其它失败

@property (nonatomic,retain) NSString *strMsg;//输出信息

@property (nonatomic,retain) NSString *strsucceed;//是否调用到接口 "true"或"false"

@property float fAmount_money;//可用余额
@property float fToday_money;//今日收益余额
@property float fFree_money;//冻结余额



@property float fAmount_cjb;//可用财经币
@property float fToday_cjb;//今日收益财经币
@property float fFree_cjb;//冻结财经币

@property int nPoint;//积分
@property int nlevelmaxpoint;//级别最高分
@property (nonatomic,retain) NSString *strlevelname;//等级字符串

@property (nonatomic,retain) NSString *tgcode;//推荐码

@property float myracecount;//我参加的比赛数目

@property float alltimes;//订阅人数

@end
