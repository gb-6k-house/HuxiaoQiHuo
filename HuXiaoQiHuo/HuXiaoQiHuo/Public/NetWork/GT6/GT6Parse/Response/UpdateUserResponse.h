//
//  UpdateUserResponse.h
//  Test
//
//  Created by wenbo.fan on 12-10-12.
//  Copyright (c) 2012年 wenbo.fan. All rights reserved.
//

#import "GT6Response.h"
#import "BankRoll.h"
@interface UpdateUserResponseData : GT6ResponseData
@property BankRoll * bankRoll;
@property NSArray * orderlist;
@property NSArray * positionlist;
@end

@interface UpdateUserResponse : GT6Response
@end
