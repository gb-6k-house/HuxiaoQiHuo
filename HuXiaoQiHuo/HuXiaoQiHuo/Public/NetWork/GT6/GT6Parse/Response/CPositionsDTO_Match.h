//
//  CPositionsDTO.h
//  XMClient
//
//  Created by wenbo.fan on 12-10-30.
//  Copyright (c) 2012年 wenbo.fan. All rights reserved.
//

#import "GT6Response.h"

@interface CPositionsDTO_Match  : GT6ResponseData
@property int id;					//ID
@property BOOL Isbuy;				//类型 1买  0卖
@property NSString * mmcode;		//商品码
@property double price;			//成交均价

@property NSInteger number;				//持仓手数

@property double loss;        //止损价
@property double accrual;
@property NSString * time;

@property double firstprice;
@end

