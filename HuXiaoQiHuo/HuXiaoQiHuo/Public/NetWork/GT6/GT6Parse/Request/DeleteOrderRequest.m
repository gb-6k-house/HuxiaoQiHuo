//
//  DeleteOrderRequest.m
//  XMClient
//
//  Created by wenbo.fan on 12-11-1.
//  Copyright (c) 2012年 wenbo.fan. All rights reserved.
//

#import "DeleteOrderRequest.h"

@implementation DeleteOrderRequest
-(DeleteOrderRequest *)initWithUserID:(NSString *)userID AndOrderID:(NSString *)orderID
{
    if(self = [super initWithBc:@"del_order_net_real" AndTag:@"data"])
    {
        [dicPara setValue:userID forKey:@"user"];
        [dicPara setValue:orderID forKey:@"orderid"];
    }
    return self;
}
@end
