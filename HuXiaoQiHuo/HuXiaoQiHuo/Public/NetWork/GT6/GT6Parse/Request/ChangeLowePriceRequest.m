//
//  ChangeLowePriceRequest.m
//  XMClient
//
//  Created by wenbo.fan on 12-12-13.
//  Copyright (c) 2012年 wenbo.fan. All rights reserved.
//

#import "ChangeLowePriceRequest.h"

@implementation ChangeLowePriceRequest
-(ChangeLowePriceRequest *)initWithLoss:(NSString *)loss
                                 mpcode:(NSString *)mpcode
                                  isBuy:(NSString *)isBuy
{
    
    if(self = [super initWithBc:@"update_position" AndTag:@"data"])
    {
        [dicPara setValue:loss forKey:@"loss"];
        [dicPara setValue:mpcode forKey:@"mmcode"];
        [dicPara setValue:isBuy forKey:@"Isbuy"];
    }
    return self;
}
@end
