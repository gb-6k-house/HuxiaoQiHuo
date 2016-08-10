//
//  LoadUserInfoRequest.m
//  Test
//
//  Created by wenbo.fan on 12-10-11.
//  Copyright (c) 2012年 wenbo.fan. All rights reserved.
//

#import "LoadUserInfoRequest.h"

@implementation LoadUserInfoRequest
-(LoadUserInfoRequest *)initWithUserID:(int)userid
{
    if(self = [super initWithBc:@"load_userinfo" AndTag:@"data"])
    {
        [dicPara setValue:[NSString stringWithFormat:@"%d",userid] forKey:@"user"];
    }
    return self;
}
@end
