//
//  RegisterRequest.m
//  HuXiaoQiHuo
//
//  Created by niupark on 16/5/20.
//  Copyright © 2016年 fukeng. All rights reserved.
//

#import "RegisterRequest.h"

@implementation RegisterRequest
-(RegisterRequest *) initWithUserName:(NSString *) userNmae
                             Password:(NSString *) password
                          PhoneNumber:(NSString *) phoneNumber
                                EMail:(NSString *) eMail
                              Captcha:(NSString *) captcha
                             Checksum:(NSString *) checksum
                           AndAgentID:(NSString *) agentID
{
    if(self = [super initWithCmd:MsgCode_Register AndSID:2002])
    {
        
        [dicPara setValue:password forKey:@"password"];
        [dicPara setValue:userNmae forKey:@"username"];
        [dicPara setValue:phoneNumber forKey:@"phoneNumber"];
        [dicPara setValue:eMail forKey:@"EMail"];
        [dicPara setValue:captcha forKey:@"captcha"];
        [dicPara setValue:checksum forKey:@"checksum"];
        [dicPara setValue:agentID forKey:@"AgentID"];
    }
    return self;
}
@end
