//
//  LoginRequest.h
//  Test
//
//  Created by wenbo.fan on 12-10-11.
//  Copyright (c) 2012年 wenbo.fan. All rights reserved.
//

#import "GT6Request.h"

@interface GT6LoginRequest : GT6Request
-(GT6LoginRequest *) initWithUsername:(NSString *)username AndPassword:(NSString *)password;
@end
