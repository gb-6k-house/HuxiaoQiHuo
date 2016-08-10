//
//  FYQueryIdRequest.m
//  traderex
//
//  Created by cssoft on 15/11/3.
//  Copyright © 2015年 EasyFly. All rights reserved.
//

#import "FYQueryIdRequest.h"

@implementation FYQueryIdRequest

-(FYQueryIdRequest *) initWithBillboard_DiscoverSubscribe:(NSInteger)nQuery_uid
{
    if(self = [super initWithCmd:121 AndSID:119])
    {
        [dicPara setValue:[NSNumber numberWithInteger:nQuery_uid] forKey:@"query_uid"];
    }
    return self;
}
@end
