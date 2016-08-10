//
//  ChangeLowePriceRequest.h
//  XMClient
//
//  Created by wenbo.fan on 12-12-13.
//  Copyright (c) 2012年 wenbo.fan. All rights reserved.
//

#import "GT6Request.h"

@interface ChangeLowePriceRequest : GT6Request

-(ChangeLowePriceRequest *)initWithLoss:(NSString *)loss
                            mpcode:(NSString *)mpcode
                             isBuy:(NSString *)isBuy;
@end
