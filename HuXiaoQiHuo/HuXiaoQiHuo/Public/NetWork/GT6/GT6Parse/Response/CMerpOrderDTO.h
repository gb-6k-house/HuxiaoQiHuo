//
//  CMerpOrderDTO.h
//  XMClient
//
//  Created by wenbo.fan on 12-10-26.
//  Copyright (c) 2012年 wenbo.fan. All rights reserved.
//

#import "GT6Response.h"

@interface CMerpOrderDTO : GT6ResponseData
@property int mpid;				//交易品种ID
@property NSString * mpcode;		//交易编码
@property NSString * mpname;		//商品名称
@property double mpnowpic;			//最近一次成交价格
@property double firstprice;	//开盘价格
@property double maxprice;			//最高价格
@property double minprice;			//最低价格
@property int		alltrannumber;	//当天成交总量
@property double	alltranprice;	//当天成交总金额
@property double	buyprice;		//买入价格*
@property double	sellprice;		//卖出价格*
@property int		buynumber;		//买1量*
@property int		sellnumber;		//卖1量*
@property int		buyallnumber;	//买盘总量*
@property int		sellallnumber;	//卖盘总量*
@property double avgtranprice;		//平均成交价格
@property double yeprice;			//昨日收盘价格
@end
