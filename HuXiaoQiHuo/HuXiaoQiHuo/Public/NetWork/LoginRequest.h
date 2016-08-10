//
//  LoginRequest.h
//  HuXiaoQiHuo
//
//  Created by niupark on 16/5/19.
//  Copyright © 2016年 fukeng. All rights reserved.
//

#import "Request.h"

@interface LoginRequest : Request
-(LoginRequest *) initWithUsername:(NSString *)username AndPassword:(NSString *)password;

@end
