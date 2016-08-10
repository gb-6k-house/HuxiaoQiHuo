//
//  ModifyLossAndProfitRequest.m
//  TFBClient
//
//  Created by easyfly on 13-12-5.
//  Copyright (c) 2013年 easyfly. All rights reserved.
//

#import "ModifyLossAndProfitRequest.h"

@implementation ModifyLossAndProfitRequest

-(ModifyLossAndProfitRequest *)initWithLoss:(NSString *)loss
                                     profit:(NSString *)profit
                                    orderid:(NSString *)orderid
{
    
    if(self = [super initWithBc:@"update_position" AndTag:@"data"])
    {
        [dicPara setValue:loss forKey:@"loss"];
        [dicPara setValue:profit forKey:@"profit"];
        [dicPara setValue:orderid forKey:@"posid"];
    }
    return self;
}

@end
