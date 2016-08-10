//
//  MerpDeliverRequest.m
//  XMClient
//
//  Created by wenbo.fan on 12-11-7.
//  Copyright (c) 2012年 wenbo.fan. All rights reserved.
//

#import "MerpDeliverRequest.h"
static NSString *Clidoid = @"111111";
@implementation MerpDeliverRequest
-(MerpDeliverRequest *)initWithUserID:(NSString *)userid
                               mmcode:(NSString *)mmcode
                                Isbuy:(NSString *)Isbuy
                            AndNumber:(NSString *)number
{	
    if(self = [super initWithBc:@"delivery" AndTag:@"data"])
    {
        [dicPara setValue:userid forKey:@"user"];
        [dicPara setValue:mmcode forKey:@"mmcode"];
        [dicPara setValue:Isbuy forKey:@"Isbuy"];
        [dicPara setValue:number forKey:@"number"];
        [dicPara setValue:Clidoid forKey:@"Clidoid"];
    }
    return self;
}
@end
