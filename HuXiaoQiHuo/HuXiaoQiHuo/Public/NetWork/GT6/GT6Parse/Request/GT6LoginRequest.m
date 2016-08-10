//
//  LoginRequest.m
//  Test
//
//  Created by wenbo.fan on 12-10-11.
//  Copyright (c) 2012年 wenbo.fan. All rights reserved.
//

#import "GT6LoginRequest.h"
@implementation GT6LoginRequest
-(GT6LoginRequest *)initWithUsername:(NSString *)username AndPassword:(NSString *)password
{
    if(self = [super initWithBc:@"login" AndTag:@"login"])
    {
        [dicPara setValue:username forKey:@"loginname"];
        [dicPara setValue:[GT6LoginRequest getPassword:password] forKey:@"loginpwd"];
    }
    return self;
}
@end
