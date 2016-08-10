//
//  CRegisterClientSocket.h
//  HuXiaoQiHuo
//
//  Created by niupark on 16/5/20.
//  Copyright © 2016年 fukeng. All rights reserved.
//

#import "CClientSocket.h"

@interface CRegisterClientSocket : CClientSocket
//获取验证码
- (void) getRegisterCode:(NSString *) strPhone;
- (void) getRegisterCode:(NSString *) strPhone userName:(NSString*)userName;

//注册
- (void) sendRegisterInfo:(NSString *) userName
                 Password:(NSString *) password
              PhoneNumber:(NSString *) phoneNumber
                    EMail:(NSString *) eMail
                  Captcha:(NSString *) captcha
                 Checksum:(NSString *) checksum
               AndAgentID:(NSString *) agentID;
//修改密码
- (void)    modifyUser:(NSString *) userName
            newPassword:(NSString *) newPassword
            PhoneNumber:(NSString *) phoneNumber
                Captcha:(NSString *) captcha
               Checksum:(NSString *) checksum;
@end
