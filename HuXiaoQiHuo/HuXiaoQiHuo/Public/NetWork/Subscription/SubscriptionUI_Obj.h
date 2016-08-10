//
//  SubscriptionUI_Obj.h
//  traderex
//
//  Created by cssoft on 15/10/27.
//  Copyright © 2015年 EasyFly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SubscriptionUI_Obj : NSObject

@property NSInteger nbeSubscriberInvesttype;//市场类型
@property (nonatomic ,retain) NSString *strUserHeaderImageURL;//头像
@property (nonatomic ,retain) NSString *strUserName;//主账户名
@property (nonatomic ,retain) NSString *strAccountName;//子账户名
@property (nonatomic ,retain) NSString *strMarketName;//市场名称
@property NSInteger nMuid;
@property NSInteger nUid;


@property NSInteger nSubscriptionNum;//订阅数量

@property NSInteger nIsbuy;//买卖类型
@property (nonatomic ,retain) NSString *strMarketProductName;//市场商品名
@property (nonatomic ,retain) NSString *strMarketProductCode;//市场商品编码
@property (nonatomic ,retain) NSString *strDealtime;//订阅时间
@property float fProfit;//盈亏
@property float fPrice;//价格
@property float fNumber;//成交数量

@end
