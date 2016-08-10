//
//  TradeResponse.m
//  Test
//
//  Created by wenbo.fan on 12-10-10.
//  Copyright (c) 2012年 wenbo.fan. All rights reserved.
//

#import "TradeMainResponse.h"

@implementation TradeResponseData
@synthesize ScId,UId,Bc,IP,check,para;
- (NSString *)description
{
    return [NSString stringWithFormat:@"Scid:%@ Uid %d Bc %@ IP %@ , check %@, para %@", self.ScId, self.UId, self.Bc, self.IP, self.check, self.para];
}
@end

@implementation TradeMainResponse
-(GT6ResponseData *)createResponseData
{
    return [[TradeResponseData alloc] init];
}
@end