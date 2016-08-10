//
//  VerifyCodeRequest.m
//  HuXiaoQiHuo
//
//  Created by niupark on 16/5/20.
//  Copyright © 2016年 fukeng. All rights reserved.
//

#import "VerifyCodeRequest.h"

@implementation VerifyCodeRequest
-(instancetype) initWithPhoneNumber:(NSString *) phoneNumber{
    if(self = [super initWithCmd:MsgCode_Captcha AndSID:2001]){

        [dicPara setValue:phoneNumber forKey:@"phoneNumber"];
    }
    return self;
}
-(instancetype) initWithPhoneNumber:(NSString *) phoneNumber userName:(NSString*)username{
    if(self = [super initWithCmd:MsgCode_CaptchaForModiyPSW AndSID:2004]){
        [dicPara setValue:phoneNumber forKey:@"mobile"];
        [dicPara setValue:username forKey:@"username"];

    }
    return self;
}

@end
