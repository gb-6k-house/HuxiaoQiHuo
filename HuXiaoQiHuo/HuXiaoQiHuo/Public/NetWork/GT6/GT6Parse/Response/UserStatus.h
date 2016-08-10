//
//  UserStatus.h
//  XMClient
//
//  Created by wenbo.fan on 12-10-26.
//  Copyright (c) 2012年 wenbo.fan. All rights reserved.
//

#import "GT6Response.h"

@interface UserStatus :  GT6ResponseData
@property int userID;
@property NSString * username;
@property NSString * bankAccount;
@property int status;
@property int delayTime;


@property int SUGradeId; //1表示普通用户 4表示代理用户
@property int UserType;				//1:个人账户  2:企业账户

@end
