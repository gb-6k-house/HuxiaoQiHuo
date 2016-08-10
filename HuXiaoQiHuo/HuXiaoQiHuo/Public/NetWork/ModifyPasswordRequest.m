//
//  ModifyPasswordRequest.m
//  HuXiaoQiHuo
//
//  Created by niupark on 16/6/6.
//  Copyright © 2016年 fukeng. All rights reserved.
//

#import "ModifyPasswordRequest.h"

@implementation ModifyPasswordRequest
-(ModifyPasswordRequest *) initWithUserName:(NSString *) userNmae
                                newPassword:(NSString *) newPassword
                                PhoneNumber:(NSString *) phoneNumber
                                    Captcha:(NSString *) captcha
                                   Checksum:(NSString *) checksum{
    if(self = [super initWithCmd:MsgCode_ModifyPassword AndSID:2003])
    {
        
        [dicPara setValue:newPassword forKey:@"password"];
        [dicPara setValue:userNmae forKey:@"username"];
        [dicPara setValue:phoneNumber forKey:@"phoneNumber"];
        [dicPara setValue:captcha forKey:@"captcha"];
        [dicPara setValue:checksum forKey:@"checksum"];
    }
    return self;
}
@end
