//
//  AddOrderResponse.m
//  Test
//
//  Created by wenbo.fan on 12-10-12.
//  Copyright (c) 2012年 wenbo.fan. All rights reserved.
//

#import "AddOrderResponse.h"
@implementation AddOrderResponseData

@end

@implementation AddOrderResponse
-(GT6ResponseData *)createResponseData
{
    return [[AddOrderResponseData alloc] init];
}
-(BOOL)ifSucess{
    if ([((AddOrderResponseData*)self.responseData).RST isEqualToString:@"T"]) {
        return YES;
    }
    return NO;
}
@end
