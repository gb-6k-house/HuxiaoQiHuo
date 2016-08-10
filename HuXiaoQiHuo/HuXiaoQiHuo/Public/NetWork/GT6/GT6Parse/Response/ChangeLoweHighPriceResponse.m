//
//  ChangeLoweHighPriceResponse.m
//  XMClient
//
//  Created by wenbo.fan on 12-11-8.
//  Copyright (c) 2012年 wenbo.fan. All rights reserved.
//

#import "ChangeLoweHighPriceResponse.h"
@implementation ChangeLoweHighPriceResponseData
@synthesize user, result, info, clidoid;
-(NSString *)description
{
    return [NSString stringWithFormat:@"user:%d result:%d info:%@ clidoid:%@",user, result, info, clidoid];
}
@end

@implementation ChangeLoweHighPriceResponse
-(GT6ResponseData *)createResponseData
{
    return [[ChangeLoweHighPriceResponseData alloc] init];
}
@end
