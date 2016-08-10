//
//  FYSubscriotionSearchRequest.m
//  traderex
//
//  Created by cssoft on 15/12/1.
//  Copyright © 2015年 EasyFly. All rights reserved.
//

#import "FYSubscriotionSearchRequest.h"

@implementation FYSubscriotionSearchRequest

-(FYSubscriotionSearchRequest *) initWithBillboard_DiscoverSubscribe:(int)nSID AndUsername:(NSString *)username AndAccount:(NSString *)account AndInvesttype:(NSInteger)ninvesttype AndPagenum:(NSInteger)npagenum
{
    if(self = [super initWithCmd:125 AndSID:nSID])
    {
        [dicPara setValue:username forKey:@"user_name"];
        [dicPara setValue:account forKey:@"account"];
        [dicPara setValue:[NSNumber numberWithInteger:ninvesttype] forKey:@"investtype"];
        [dicPara setValue:[NSNumber numberWithInteger:npagenum] forKey:@"pagenum"];
        
    }
    return self;

}

@end
