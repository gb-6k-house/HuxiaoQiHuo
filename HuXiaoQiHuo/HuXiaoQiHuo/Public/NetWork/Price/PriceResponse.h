//
//  PriceResponse.h
//  Trader
//
//  Created by easyfly on 2/14/14.
//  Copyright (c) 2014 easyfly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PriceResponse : NSObject <NSCoding>

@property(nonatomic, copy) NSString * strMarketID;
@property(nonatomic, copy) NSString * strProductCode;
@property(nonatomic, copy) NSString * strProductName;

@property(nonatomic, copy) NSString * strLastPrice; // 撮合用
@property(nonatomic, copy) NSString * strSellPrice;
@property(nonatomic, copy) NSString * strBuyPrice;

@property(nonatomic, copy) NSString * strAmplitude ; // 振幅
@property(nonatomic, copy) NSString * strRiseFallRatio; //涨跌幅
@property(nonatomic, copy) NSString * strRiseFallPrice; //涨跌幅值


@property(nonatomic, copy) NSString * strMaxPrice;
@property(nonatomic, copy) NSString * strMinPrice;

@property(nonatomic, copy) NSString * strOpenPrice;
@property(nonatomic, copy) NSString * strClosePrice;

@property(nonatomic, copy) NSString * strAllTranNumber;
@property(nonatomic, copy) NSString * strAllTranPrice;

@property(nonatomic, copy) NSString * strAvgPrice;

@property(nonatomic, copy) NSString * strBuyNumber1;
@property(nonatomic, copy) NSString * strBuyPrice1;

@property(nonatomic, copy) NSString * strBuyNumber2;
@property(nonatomic, copy) NSString * strBuyPrice2;

@property(nonatomic, copy) NSString * strBuyNumber3;
@property(nonatomic, copy) NSString * strBuyPrice3;

@property(nonatomic, copy) NSString * strSellNumber1;
@property(nonatomic, copy) NSString * strSellPrice1;

@property(nonatomic, copy) NSString * strSellNumber2;
@property(nonatomic, copy) NSString * strSellPrice2;

@property(nonatomic, copy) NSString * strSellNumber3;
@property(nonatomic, copy) NSString * strSellPrice3;

@property(nonatomic, copy) NSString * strTime;

@end
