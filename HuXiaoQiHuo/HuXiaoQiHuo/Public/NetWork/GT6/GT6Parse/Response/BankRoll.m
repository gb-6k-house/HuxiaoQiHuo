//
//  BankRoll.m
//  Test
//
//  Created by wenbo.fan on 12-10-12.
//  Copyright (c) 2012年 wenbo.fan. All rights reserved.
//

#import "BankRoll.h"

@implementation BankRoll
@synthesize user,price,status,outfreezing,orderfreezing,positionsfreezing;
-(NSString *)description
{
    return [NSString stringWithFormat:@"userID:%d, price:%f, status:%d, outfreezing:%f orderfreezing:%f positionsfreezing:%f", user,price,status,outfreezing,orderfreezing,positionsfreezing];
}
@end
