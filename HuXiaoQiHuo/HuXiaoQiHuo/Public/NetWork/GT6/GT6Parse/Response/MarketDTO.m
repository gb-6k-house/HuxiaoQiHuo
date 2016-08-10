//
//  MarketDTO.m
//  XMClient
//
//  Created by wenbo.fan on 12-10-26.
//  Copyright (c) 2012年 wenbo.fan. All rights reserved.
//

#import "MarketDTO.h"

@implementation MarketDTO
@synthesize mtid,mtname,mttype;

-(NSString *)description
{
    return [NSString stringWithFormat:@"id:%d, name:%@ type:%d", self.mtid,self.mtname, self.mttype];
}
@end
