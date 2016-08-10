//
//  DeleteOrderResponse.m
//  Test
//
//  Created by wenbo.fan on 12-10-12.
//  Copyright (c) 2012年 wenbo.fan. All rights reserved.
//

#import "DeleteOrderResponse.h"
@implementation DeleteOrderResponseData
@synthesize user,result,orderid,info,clidoid;
-(NSString *)description
{
    return [NSString stringWithFormat:@"userID:%d, result:%d, orderid:%d, info:%@, clidoid:%@", self.user,self.result,self.orderid,self.info,self.clidoid];
}
@end

@implementation DeleteOrderResponse
-(GT6ResponseData *)createResponseData
{
    return [[DeleteOrderResponseData alloc] init];
}
@end
