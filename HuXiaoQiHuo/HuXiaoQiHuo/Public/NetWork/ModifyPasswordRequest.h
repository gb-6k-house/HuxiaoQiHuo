//
//  ModifyPasswordRequest.h
//  HuXiaoQiHuo
//
//  Created by niupark on 16/6/6.
//  Copyright © 2016年 fukeng. All rights reserved.
//

#import "Request.h"

@interface ModifyPasswordRequest : Request
-(ModifyPasswordRequest *) initWithUserName:(NSString *) userNmae
                                newPassword:(NSString *) newPassword
                                PhoneNumber:(NSString *) phoneNumber
                                    Captcha:(NSString *) captcha
                                   Checksum:(NSString *) checksum;
@end
