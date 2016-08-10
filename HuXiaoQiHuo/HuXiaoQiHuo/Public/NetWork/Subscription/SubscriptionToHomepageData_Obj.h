//
//  SubscriptionToHomepageData_Obj.h
//  traderex
//
//  Created by cssoft on 15/10/30.
//  Copyright © 2015年 EasyFly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SubscriptionToHomepageData_Obj : NSObject

@property NSInteger nUid;
@property NSInteger nbeSubscriberInvesttype;//市场类型
@property NSInteger nMuid;
@property (nonatomic ,retain) NSString *strUserName;//主账户名
@property (nonatomic ,retain) NSString *strAccountName;//子账户名
@property NSInteger nSelectBtn; //0观点  1 成交历史 2 持仓
@end
