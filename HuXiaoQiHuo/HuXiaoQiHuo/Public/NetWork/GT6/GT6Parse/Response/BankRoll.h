//
//  BankRoll.h
//  Test
//
//  Created by wenbo.fan on 12-10-12.
//  Copyright (c) 2012年 wenbo.fan. All rights reserved.
//

#import "GT6Response.h"

@interface BankRoll : GT6ResponseData
@property int user;
@property double price;              //账户资金
@property int status;                //用户状态
@property double outfreezing;        //出金冻结资金
@property double orderfreezing;      //订单冻结资金
@property double positionsfreezing;  //持仓冻结资金
@end
