//
//  FYMarketTypeData_Obj.m
//  traderex
//
//  Created by XXJ on 15/10/27.
//  Copyright © 2015年 EasyFly. All rights reserved.
//

#import "FYMarketTypeData_Obj.h"

@implementation FYMarketTypeData_Obj

- (void)setValue:(id)value forKey:(NSString *)key
{
    if ([key isEqualToString:@"name"]) {
        self.strName = value;
    } else if ([key isEqualToString:@"marketId"]) {
        self.arrayMarketId = value;
    } else {
        self.orderId = value;
    }
}

@end
