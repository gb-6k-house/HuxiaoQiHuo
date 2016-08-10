//
//  LoadUserInfoResponse.m
//  Test
//
//  Created by wenbo.fan on 12-10-11.
//  Copyright (c) 2012年 wenbo.fan. All rights reserved.
//

#import "LoadUserInfoResponse.h"

@implementation LoadUserInfoResponseData

@end

@implementation LoadUserInfoResponse
-(GT6ResponseData *)createResponseData
{
    return [[LoadUserInfoResponseData alloc] init];
}

- (void) parseResponse:(NSString *)response
{
      [self parseResponse_Market:response];

}

-(void) parseResponse_Market:(NSString *)response
{
    [super parseResponse:response];
}


@end
