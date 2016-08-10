//
//  LoadUserInfoResponse.h
//  Test
//
//  Created by wenbo.fan on 12-10-11.
//  Copyright (c) 2012年 wenbo.fan. All rights reserved.
//

#import "GT6Response.h"
#import "BankRoll.h"
#import "COrderDTO_Match.h"
#import "COrderDTO_Market.h"
#import "CPositionsDTO_Market.h"
#import "CPositionsDTO_Match.h"

@interface LoadUserInfoResponseData : GT6ResponseData
@property int user;
@property NSString *name;
@property double price;
@property double loan;
@property double outfreezing;
@property double positionsfreezing;

@property double orderfreezing;

@property NSArray *orderlist;
@property NSArray *positionlist;
@end

@interface LoadUserInfoResponse : GT6Response
@end
