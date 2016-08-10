//
//  Subscription_Search_Obj.h
//  traderex
//
//  Created by cssoft on 15/11/30.
//  Copyright © 2015年 EasyFly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Subscription_Search_Obj : NSObject

@property NSInteger nUid;//主账户ID
@property NSInteger nbeSubscriberInvesttype;//市场类型
@property NSInteger nMuid;//子账户ID
@property (nonatomic ,retain) NSString *strUserName;//主账户名
@property (nonatomic ,retain) NSString *strAccountName;//子账户名
@property (nonatomic ,retain) NSString *strHeaderUrl;//头像url

@end
