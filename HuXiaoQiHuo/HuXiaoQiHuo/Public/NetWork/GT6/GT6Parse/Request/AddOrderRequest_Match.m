//
//  AddOrderRequest.m
//  Test
//
//  Created by wenbo.fan on 12-10-12.
//  Copyright (c) 2012年 wenbo.fan. All rights reserved.
//

#import "AddOrderRequest_Match.h"

@implementation AddOrderRequest_Match
-(AddOrderRequest_Match *)initWithUserID:(NSString *)userID
                 mpcode:(NSString *)mpcode
                 isBuy:(NSString *)isBuy
                 number:(NSString *)number
                 price:(NSString *)price
                 doadverse:(NSString *)doadverse
                 matchid:(NSString *)matchid

{
    if(self = [super initWithBc:@"add_order" AndTag:@"data"])
    {
        [dicPara setValue:userID forKey:@"user"];
        [dicPara setValue:mpcode forKey:@"mmcode"];
        [dicPara setValue:isBuy forKey:@"Isbuy"];
        [dicPara setValue:number forKey:@"number"];
        [dicPara setValue:price forKey:@"price"];
        [dicPara setValue:doadverse forKey:@"doadverse"];
        [dicPara setValue:matchid forKey:@"matchid"];
        [dicPara setValue:@"123321" forKey:@"clidoid"];

    }
    return self;
}
@end
