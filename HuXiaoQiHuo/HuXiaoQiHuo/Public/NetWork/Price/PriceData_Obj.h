//
//  PriceData_Obj.h
//  Trader
//
//  Created by EasyFly on 14-7-30.
//  Copyright (c) 2014年 easyfly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PriceData_Obj : NSObject

@property(nonatomic, copy) NSString * strMapID;

@property float fLatestPrice;						// 最新报价/卖价

@property float fLatestBuyPrice;					// 最新买价

@property float fHighestPrice;                    //最高价

@property float fLowestPrice;						//最低价

@property float fOpenPrice;						//开盘价

@property float fClosePrice;						//收盘价

@property float fVolume;							// 成交量

@property float fAmount;							// 成交额

@property float	fBuyPrice1;						// 申买价1
@property float	fBuyPrice2;						// 申买价2
@property float	fBuyPrice3;						// 申买价3
@property float	fBuyPrice4;						// 申买价4
@property float	fBuyPrice5;						// 申买价5

@property float	fBuyVolume1;						// 申买量1
@property float	fBuyVolume2;						// 申买量2
@property float	fBuyVolume3;						// 申买量3
@property float	fBuyVolume4;						// 申买量4
@property float	fBuyVolume5;						// 申买量5

@property float	fSellPrice1;						// 申卖价1
@property float	fSellPrice2;						// 申卖价2
@property float	fSellPrice3;						// 申卖价3
@property float	fSellPrice4;						// 申卖价4
@property float	fSellPrice5;						// 申卖价5

@property float	fSellVolume1;						// 申卖量1
@property float	fSellVolume2;						// 申卖量2
@property float	fSellVolume3;						// 申卖量3
@property float	fSellVolume4;						// 申卖量4
@property float	fSellVolume5;						// 申卖量5
@property float fChg;							// 涨跌幅 ，客户端计算的
@property float fChgPrice;							// 涨跌幅价

@property(nonatomic, copy) NSString * strTime;
@property NSInteger nTime;


@end
