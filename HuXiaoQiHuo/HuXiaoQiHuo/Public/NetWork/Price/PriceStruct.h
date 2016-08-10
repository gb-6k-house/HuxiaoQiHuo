//
//  PriceStruct.h
//  Trader
//
//  Created by EasyFly on 14-7-29.
//  Copyright (c) 2014年 easyfly. All rights reserved.
//

#ifndef Trader_PriceStruct_h
#define Trader_PriceStruct_h

#pragma pack(1)
typedef struct{
	__int32_t time;
    unsigned short mapID;
	float fLatestPrice;						// 最新报价/卖价
	float fLatestBuyPrice;					// 最新买价
	float fHighestPrice;                    //最高价
	float fLowestPrice;						//最低价
	float fOpenPrice;						//开盘价
	float fClosePrice;						//收盘价
	float fVolume;							// 成交量
	float fAmount;							// 成交额
	float	fBuyPrice[5];						// 申买价1,2,3
	float	fBuyVolume[5];						// 申买量1,2,3
	float	fSellPrice[5];						// 申卖价1,2,3
	float	fSellVolume[5];						// 申卖量1,2,3
}PriceBody02_st;

typedef struct{
    unsigned short mapID;
	float	fBuyPrice[5];						// 申买价1,2,3
	float	fBuyVolume[5];						// 申买量1,2,3
	float	fSellPrice[5];						// 申卖价1,2,3
	float	fSellVolume[5];						// 申卖量1,2,3
}PriceBody03_st;

typedef struct{
	__int32_t time;
    unsigned short mapID;
	float fLatestPrice;						// 最新报价/卖价
	float fLatestBuyPrice;					// 最新买价
	float fVolume;							// 成交量
	float fAmount;							// 成交额
}PriceBody04_st;


typedef struct
{
    short   nItem; //
    char	cType; //’B’，‘S’ 值为‘B’ nItem代表brokerID，为’S‘时，nTtem为非零代表档位，为0代表此档broker
    char	resever;
    
}BrokerItem_st;

typedef struct
{
    unsigned short mapID;
    short nSide; // 1买， 2卖
    short nItemCount;//items有效数据数
    BrokerItem_st  items[40];
    
}PriceBody06_st;//BrokerList;

#pragma pack()

#endif
