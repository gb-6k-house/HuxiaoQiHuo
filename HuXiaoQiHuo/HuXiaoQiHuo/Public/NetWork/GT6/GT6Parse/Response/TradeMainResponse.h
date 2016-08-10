//
//  TradeResponse.h
//  Test
//
//  Created by wenbo.fan on 12-10-10.
//  Copyright (c) 2012年 wenbo.fan. All rights reserved.
//

#import "GT6Response.h"

@interface TradeResponseData : GT6ResponseData

@property NSString * ScId;
@property int UId;
@property NSString *Bc;
@property NSString *IP;
@property NSString *check;
@property NSString *para;
@end

@interface TradeMainResponse : GT6Response
-(TradeResponseData *) createResponseData;
@end