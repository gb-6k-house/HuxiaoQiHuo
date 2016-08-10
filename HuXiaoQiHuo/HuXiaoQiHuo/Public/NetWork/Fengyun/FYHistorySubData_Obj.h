//
//  FYHistoricalData_subObj.h
//  traderex
//
//  Created by cssoft on 15/10/20.
//  Copyright © 2015年 EasyFly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FYHistorySubData_Obj : NSObject

@property NSInteger nOheid;//编号

@property NSInteger nOheoid;//持仓号

@property (nonatomic,retain) NSString * strOhemcode;//商品码

@property (nonatomic,retain) NSString *strOhedealtime;//成交时间

@property NSInteger nOhetype;//类型 1买 0卖

@property float fOhenumber;//成交手数

@property float fOheprice;//成交价

@property float fOheoddnum;//剩余手数

@property float fOhedealcost;//手续费

@property NSInteger nOheadverse;//建平仓类型 1平仓 其他建仓

@property float fOheProfit;//获利

@property float fOheNBalance;//本次结余

@property NSInteger nModeType;//模式

@property NSInteger nMakerType ;//成交模式  0委托 1即时 2止损止盈 其他 爆仓

@property NSInteger nUDTypet;//

@property float fOheLossP;//止损
@property float fOheProfitP;//止盈



@end
