//
//  FYRequest.m
//  traderex
//
//  Created by cssoft on 15/9/10.
//  Copyright (c) 2015年 EasyFly. All rights reserved.
//

#import "FYRequest.h"
@implementation FYRequest

-(FYRequest *) initWithCmd:(int )Cmd AndSID:(int )SID
{
    if (self = [super init])
    {
        dicHead = [[NSMutableDictionary alloc] init];
        [dicHead setValue:[NSNumber numberWithInt:Cmd] forKey:@"cmd"];
        [dicHead setValue:[NSNumber numberWithInt:0] forKey:@"UID"];
        [dicHead setValue:[NSNumber numberWithInt:SID] forKey:@"SID"];
        
        dicPara = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}



@end
