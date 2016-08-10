//
//  GT6LoginResponse.h
//  MarketClient
//
//  Created by XXJ on 15/9/9.
//  Copyright (c) 2015年 easyfly. All rights reserved.
//

#import "GT6Response.h"
#import "UserStatus.h"
#import "MerpDTO.h"
#import "MarketDTO.h"

@interface GT6LoginResponseData : GT6ResponseData
@property NSString * rst;
@property int uid;
@property NSString *reason;
@end

@interface GT6LoginResponse : GT6Response
@property GT6LoginResponseData * loginResponseData;
@property UserStatus * userStatus;
-(GT6ResponseData *)createResponseData;
-(BOOL) isLoginSucess;
@end