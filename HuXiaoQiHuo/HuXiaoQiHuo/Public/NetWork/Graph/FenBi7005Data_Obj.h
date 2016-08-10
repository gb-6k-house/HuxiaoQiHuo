//
//  FenBi7005Data_Obj.h
//  Trader
//
//  Created by EasyFly on 14-8-27.
//  Copyright (c) 2014年 easyfly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FenBi7005Data_Obj : NSObject

@property NSInteger nTime;

@property(nonatomic, copy) NSString * strTime;

@property(nonatomic, copy) NSString * strOpenPrice;						//开盘价
@property(nonatomic, copy) NSString * strClosePrice;					//收盘价


@property(nonatomic, copy) NSString * strHighestPrice;                    //最高价
@property(nonatomic, copy) NSString * strLowestPrice;					//最低价


@property(nonatomic, copy) NSString * strVolume;						// 成交量
@property(nonatomic, copy) NSString * strAmount;						// 成交额
@property(nonatomic, assign)double MA5;						// 5日均线，客户端计算的，我操他妈，服务器干啥的
@property(nonatomic, assign)double MA10;						//
@property(nonatomic, assign)double MA20;						// 

@end
