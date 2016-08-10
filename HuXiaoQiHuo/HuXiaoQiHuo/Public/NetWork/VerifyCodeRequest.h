//
//  VerifyCodeRequest.h
//  HuXiaoQiHuo
//
//  Created by niupark on 16/5/20.
//  Copyright © 2016年 fukeng. All rights reserved.
//

#import "Request.h"

@interface VerifyCodeRequest : Request
-(instancetype) initWithPhoneNumber:(NSString *) phoneNumber;
-(instancetype) initWithPhoneNumber:(NSString *) phoneNumber userName:(NSString*)username;

@end
