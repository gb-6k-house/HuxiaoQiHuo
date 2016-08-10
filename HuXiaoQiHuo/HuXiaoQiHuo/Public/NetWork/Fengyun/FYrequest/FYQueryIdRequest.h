//
//  FYQueryIdRequest.h
//  traderex
//
//  Created by cssoft on 15/11/3.
//  Copyright © 2015年 EasyFly. All rights reserved.
//

#import "FYRequest.h"

@interface FYQueryIdRequest : FYRequest

-(FYQueryIdRequest *) initWithBillboard_DiscoverSubscribe:(NSInteger)nQuery_uid;

@end
