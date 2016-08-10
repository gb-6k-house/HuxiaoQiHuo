//
//  LoginRequest.m
//  HuXiaoQiHuo
//
//  Created by niupark on 16/5/19.
//  Copyright © 2016年 fukeng. All rights reserved.
//

#import "LoginRequest.h"

@implementation LoginRequest
-(LoginRequest *) initWithUsername:(NSString *)username AndPassword:(NSString *)password{
    if(self = [super initWithCmd:MsgCode_Login AndSID:1001])
    {
        NSString * strPassword = [LoginRequest getMD5:password];
        [dicPara setValue:username forKey:@"username"];
        [dicPara setValue:strPassword forKey:@"password"];
        [dicPara setValue:[NSNumber numberWithInt:2] forKey:@"machineType"];
        [dicPara setValue:[NSNumber numberWithInt:1] forKey:@"userType"];
    }
    return self;
}

@end
