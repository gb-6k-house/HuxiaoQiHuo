//
//  RegisterRequest.h
//  HuXiaoQiHuo
//
//  Created by niupark on 16/5/20.
//  Copyright © 2016年 fukeng. All rights reserved.
//

#import "Request.h"

@interface RegisterRequest : Request
-(RegisterRequest *) initWithUserName:(NSString *) userNmae
                             Password:(NSString *) password
                          PhoneNumber:(NSString *) phoneNumber
                                EMail:(NSString *) eMail
                              Captcha:(NSString *) captcha
                             Checksum:(NSString *) checksum
                           AndAgentID:(NSString *) agentID;

@end
