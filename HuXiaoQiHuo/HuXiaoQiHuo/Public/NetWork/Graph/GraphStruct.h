//
//  GraphStruct.h
//  Trader
//
//  Created by EasyFly on 14-7-31.
//  Copyright (c) 2014年 easyfly. All rights reserved.
//

#ifndef Trader_GraphStruct_h
#define Trader_GraphStruct_h

#pragma pack(1)

typedef struct{
	__int32_t time;
	float	fLatestPrice;						// 最新
	float	fVolume;							// 成交量
	float	fAmount;							// 成交额
    
}GraphBody01_st;

typedef struct {
    __int32_t time;
	float fOpenPrice;						//开盘价
	float fClosePrice;					//收盘价
    float fHighestPrice;                    //最高价
	float fLowestPrice;					//最低价
	float fVolume;						// 成交量
	float fAmount;						// 成交额


}GraphBody05_st;



#pragma pack()

#endif
