//
//  MerpDeliverRequest2.m
//  MarketClient
//
//  Created by easyfly on 3/3/14.
//  Copyright (c) 2014 easyfly. All rights reserved.
//

#import "MerpDeliverRequest2.h"

static NSString *Clidoid = @"111111";
@implementation MerpDeliverRequest2
-(MerpDeliverRequest2 *)initWithUserID:(NSString *)userid
                               mmcode:(NSString *)mmcode
                                Isbuy:(NSString *)Isbuy
                            AndNumber:(NSString *)number
                            posid:(NSString *)posid
{
    if(self = [super initWithBc:@"delivery" AndTag:@"data"])
    {
        [dicPara setValue:userid forKey:@"user"];
        [dicPara setValue:mmcode forKey:@"mmcode"];
        [dicPara setValue:Isbuy forKey:@"Isbuy"];
        [dicPara setValue:number forKey:@"number"];
        [dicPara setValue:Clidoid forKey:@"Clidoid"];
        [dicPara setValue:posid forKey:@"posid"];
    }
    return self;
}

@end
