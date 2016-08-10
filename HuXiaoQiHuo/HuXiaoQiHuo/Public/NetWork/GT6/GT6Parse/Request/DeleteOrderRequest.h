//
//  DeleteOrderRequest.h
//  XMClient
//
//  Created by wenbo.fan on 12-11-1.
//  Copyright (c) 2012年 wenbo.fan. All rights reserved.
//

#import "GT6Request.h"

@interface DeleteOrderRequest : GT6Request
-(DeleteOrderRequest *)initWithUserID:(NSString *)usernameid AndOrderID:(NSString *)orderID;
@end
