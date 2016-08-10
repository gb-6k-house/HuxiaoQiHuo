//
//  CRegisterClientSocket.m
//  HuXiaoQiHuo
//
//  Created by niupark on 16/5/20.
//  Copyright © 2016年 fukeng. All rights reserved.
//

#import "CRegisterClientSocket.h"
#import "VerifyCodeRequest.h"
#import "TraderResponse.h"
#import "RegisterRequest.h"
#import "ModifyPasswordRequest.h"
@implementation CRegisterClientSocket
//处理socket返回的数据
-(void) handelSocketJSON:(NSString *)tradeMsg{
    if ([tradeMsg isEqualToString:[self symbolString]])
        return;
    
    if (tradeMsg.length < 2)
        return;
    
    NSError * error = nil;
    NSData * dataMsg = [tradeMsg dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary * dicResponse = [NSJSONSerialization JSONObjectWithData:dataMsg options:NSJSONReadingAllowFragments error:&error];
    
    
    TraderResponse * objTraderResponse = [[TraderResponse alloc] init];
    
    [objTraderResponse setValuesForKeysWithDictionary:dicResponse];
    
    
    switch (objTraderResponse.cmd)
    {
        case MsgCode_Register:
            
            [self parseRegisterResponse:objTraderResponse];
            
            break;
            
        case MsgCode_Captcha:
        case MsgCode_CaptchaForModiyPSW:
            [self parseCaptchaResponse:objTraderResponse];
            
            break;
        case MsgCode_ModifyPassword:
            
            [[CSocketListenerManager sharedInstance] callBack:PROTOCOL_SEL(ModifyPassword) withObjcet:objTraderResponse];
            
            break;
        default:
            break;
            
    }
    
}
- (void) parseRegisterResponse: (TraderResponse *) objTraderResponse{
    [[CSocketListenerManager sharedInstance] callBack:PROTOCOL_SEL(Register) withObjcet:objTraderResponse];

}


- (void) parseCaptchaResponse: (TraderResponse *) objTraderResponse{
    [[CSocketListenerManager sharedInstance] callBack:PROTOCOL_SEL(RegisterCode) withObjcet:objTraderResponse];

}
- (void) getRegisterCode:(NSString *) strPhone{
    VerifyCodeRequest * objPhoneNumRequest = [[VerifyCodeRequest alloc] initWithPhoneNumber:strPhone];
    [self sendData:[objPhoneNumRequest getJSONString]];
}
- (void) getRegisterCode:(NSString *) strPhone userName:(NSString*)userName{
    VerifyCodeRequest * objPhoneNumRequest = [[VerifyCodeRequest alloc] initWithPhoneNumber:strPhone userName:userName];
    [self sendData:[objPhoneNumRequest getJSONString]];

}

- (void) sendRegisterInfo:(NSString *) userName
                 Password:(NSString *) password
              PhoneNumber:(NSString *) phoneNumber
                    EMail:(NSString *) eMail
                  Captcha:(NSString *) captcha
                 Checksum:(NSString *) checksum
               AndAgentID:(NSString *) agentID{
    
    RegisterRequest * objRegisterRequest = [[RegisterRequest alloc] initWithUserName:userName
                                                                            Password:password
                                                                         PhoneNumber:phoneNumber
                                                                               EMail:eMail
                                                                             Captcha:captcha
                                                                            Checksum:checksum
                                                                          AndAgentID:agentID];
    
    [self sendData:[objRegisterRequest getJSONString]];
}
//修改密码
- (void) modifyUser:(NSString *) userName
            newPassword:(NSString *) newPassword
            PhoneNumber:(NSString *) phoneNumber
                Captcha:(NSString *) captcha
               Checksum:(NSString *) checksum{
    ModifyPasswordRequest * objRegisterRequest = [[ModifyPasswordRequest alloc] initWithUserName:userName
                                                                            newPassword:newPassword
                                                                         PhoneNumber:phoneNumber
                                                                             Captcha:captcha
                                                                            Checksum:checksum
                                ];
    
    [self sendData:[objRegisterRequest getJSONString]];

}
@end
