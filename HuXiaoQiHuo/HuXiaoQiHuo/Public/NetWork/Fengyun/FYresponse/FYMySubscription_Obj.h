//
//  FYMySubscription_Obj.h
//  traderex
//
//  Created by cssoft on 15/10/23.
//  Copyright © 2015年 EasyFly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FYMySubscription_Obj : NSObject
/*
uid	Int	被订阅人ID
muid	String	子账户ID
account	string	子账户名称
endDate	string	结束时间
 */

@property NSInteger nUid;
@property NSInteger nMuid;
@property NSInteger nbeSubscriberInvesttype;//市场类型
@property (nonatomic,retain) NSString *strUserName;
@property (nonatomic,retain) NSString *strAccountName;
@property (nonatomic,retain) NSString *strEndDate;
@property (nonatomic,retain) NSString *strModifyTime;
@property (nonatomic,retain) NSString *strImageURL;
@property NSInteger nbeSubscriberNum;//被订阅的信息条数


@end
