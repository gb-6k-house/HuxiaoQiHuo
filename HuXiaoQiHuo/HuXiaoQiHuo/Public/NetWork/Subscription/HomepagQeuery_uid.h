//
//  HomepagQeuery_uid.h
//  traderex
//
//  Created by cssoft on 15/11/3.
//  Copyright © 2015年 EasyFly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomepagQeuery_uid : NSObject

@property NSInteger nUid;
@property NSInteger nbeSubscriberInvesttype;//市场类型
@property NSInteger nMuid;
@property (nonatomic ,retain) NSString *strAccountName;//子账户名
@property NSInteger nSelectBtn; //0观点 1 持仓 2 成交历史

@end
