//
//  COrderDTO.h
//  XMClient
//
//  Created by wenbo.fan on 12-10-30.
//  Copyright (c) 2012年 wenbo.fan. All rights reserved.
//

#import "GT6Response.h"

@interface COrderDTO_Market : GT6ResponseData
@property int           id;		//订单编号
@property double        price;		//价格
@property NSString      *ip;	//IP地址
@property int           user;		//用户编号
@property NSString      *mmcode;		//商品码
@property NSString      *time;		//下单时间
@property BOOL           isbuy;		//订单类型 1:买 0:卖


@property double        number;

@property int           oddnumber;	//未成交量
@property int           adverse;		//0:建仓 1:平仓
@property int           matchid;		//指定成交订单id
@property int           modetype;	//0 撮合  1 不撮合  2 做市商
@property int           udtype;		//0 向下  1 向上


@property double        loss;
@property double        profit;

@end

