//
//  UpdateUserResponse.m
//  Test
//
//  Created by wenbo.fan on 12-10-12.
//  Copyright (c) 2012年 wenbo.fan. All rights reserved.
//

#import "UpdateUserResponse.h"
@implementation UpdateUserResponseData
@synthesize bankRoll,orderlist,positionlist;
-(NSString *)description
{
    return [NSString stringWithFormat:@"banroll:%@ orderlist:%@ positionlist:%@", bankRoll, orderlist,positionlist];
}
@end

@implementation UpdateUserResponse
-(void)parseResponse:(NSString *)response
{
}

-(GT6ResponseData *)createResponseData
{
    return [[UpdateUserResponseData alloc] init];
}
@end
