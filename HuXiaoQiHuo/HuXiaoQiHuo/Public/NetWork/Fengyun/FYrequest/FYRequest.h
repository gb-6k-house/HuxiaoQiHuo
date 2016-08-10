//
//  FYRequest.h
//  traderex
//
//  Created by cssoft on 15/9/10.
//  Copyright (c) 2015年 EasyFly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Request.h"

@interface FYRequest : Request

-(FYRequest *) initWithCmd:(int)Cmd AndSID:(int)SID;


@end
