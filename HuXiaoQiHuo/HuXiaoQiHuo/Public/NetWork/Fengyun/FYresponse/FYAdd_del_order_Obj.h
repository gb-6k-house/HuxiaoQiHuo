//
//  FYAdd_del_order_Obj.h
//  traderex
//
//  Created by cssoft on 15/9/10.
//  Copyright (c) 2015年 EasyFly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FYAdd_del_order_Obj : NSObject
//下单、撤单对象
@property NSInteger nId;//订单编号

@property NSInteger nMatchid;//指定成交订单id

@property (nonatomic,retain) NSString *strIp;//IP地址

@property NSInteger nUserId;//用户id

@property (nonatomic,retain) NSString * strMmcode;//商品编码

@property (nonatomic,retain) NSString *strTime;//下单时间

@property NSInteger nIsbuy;//买卖类型 1:买0:卖

@property float fNumber;//订立数量

@property float fOddnumber;//未成交数量

@property NSInteger nAdverse;//模式 0:建仓 1:平仓

@property float fPrice;//价格

@property (nonatomic,retain) NSString *strClidoid;//客户端唯一编码

@property NSInteger nModetype;//0 撮合  1 不撮合  2 做市商

@property NSInteger nMakertype;//成交模式 0 挂单  1 即时成交

@property NSInteger nUdtype;//0 向下  1 向上

@property float fLoss;//止损价格

@property float fProfit;//止盈价格

@property float fBtprice;//挂单时价格


@end
