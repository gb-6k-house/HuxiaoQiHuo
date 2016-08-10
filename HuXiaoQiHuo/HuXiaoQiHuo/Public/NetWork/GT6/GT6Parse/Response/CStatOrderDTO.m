//
//  CStatOrderDTO.m
//  XMClient
//
//  Created by wenbo.fan on 12-10-29.
//  Copyright (c) 2012年 wenbo.fan. All rights reserved.
//

#import "CStatOrderDTO.h"

@implementation CStatOrderDTO
@synthesize mcode, isbuy, count, price, number;
-(NSString *) description
{
    return [NSString stringWithFormat:@"mcode:%@, isbuy:%@, count:%d, price:%f, number:%d", self.mcode, self.isbuy?@"buy":@"sell", self.count, self.price,self.number];
}
@end
