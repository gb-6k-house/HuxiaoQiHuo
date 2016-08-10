//
//  FYSubscriotionSearchRequest.h
//  traderex
//
//  Created by cssoft on 15/12/1.
//  Copyright © 2015年 EasyFly. All rights reserved.
//

#import "FYRequest.h"

@interface FYSubscriotionSearchRequest : FYRequest

-(FYSubscriotionSearchRequest *) initWithBillboard_DiscoverSubscribe:(int)nSID AndUsername:(NSString *)username AndAccount:(NSString *)account AndInvesttype:(NSInteger)ninvesttype AndPagenum:(NSInteger)npagenum;

@end
