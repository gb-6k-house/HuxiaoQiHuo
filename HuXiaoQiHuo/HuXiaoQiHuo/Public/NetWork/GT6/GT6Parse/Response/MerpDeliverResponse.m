//
//  MerpDeliverResponse.m
//  XMClient
//
//  Created by wenbo.fan on 12-11-7.
//  Copyright (c) 2012年 wenbo.fan. All rights reserved.
//

#import "MerpDeliverResponse.h"
@implementation MerpDeliverResponseData
@synthesize result,user,info,clidoid;
-(NSString *)description
{
    return [NSString stringWithFormat:@"usrID:%d result:%d info:%@ clidoid:%@", user, result, info, clidoid];
}
@end

@implementation MerpDeliverResponse
-(GT6ResponseData *)createResponseData
{
    return [[MerpDeliverResponseData alloc] init];
}

@end
