//
//  AddOrderRequest.m
//  Test
//
//  Created by wenbo.fan on 12-10-12.
//  Copyright (c) 2012年 wenbo.fan. All rights reserved.
//

#import "AddOrderRequest_Market.h"

@implementation AddOrderRequest_Market
-(AddOrderRequest_Market *)initWithUserID:(NSString *)userID
                 mpcode:(NSString *)mpcode
                 isBuy:(NSString *)isBuy
                 number:(NSString *)number
                 price:(NSString *)price
                 doadverse:(NSString *)doadverse
                 matchid:(NSString *)matchid

                 posid:(NSString *)posid
                 loss:(NSString *)loss
                 profit:(NSString *)profit
                 modetype:(NSString *)modetype
                 makertype:(NSString *)makertype
                 udtype:(NSString *)udtype
                 errorPrice:(NSString *)errorPrice

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

        [dicPara setValue:posid forKey:@"posid"];
        [dicPara setValue:loss forKey:@"loss"];
        [dicPara setValue:profit forKey:@"profit"];
        [dicPara setValue:modetype forKey:@"modetype"]; // 0 撮合  1 不撮合  2 做市商
        [dicPara setValue:makertype forKey:@"makertype"];// 0 挂单  1 即时成交
        [dicPara setValue:udtype forKey:@"udtype"];// 0 向下  1 向上
        [dicPara setValue:errorPrice forKey:@"errorPrice"]; // 即使成交偏差价格

    }
    return self;
}



-(AddOrderRequest_Market *)initWithUserID:(NSString *)userID
                                   mpcode:(NSString *)mpcode
                                    isBuy:(BOOL)isBuy
                                   number:(NSNumber *)number
                                    price:(NSString *)price
                                type:(NSInteger)type
                                  stopPrice:(NSString *)stopPrice
                                    stopType:(NSString *)stopType
                                      pid:(NSString *)pid
{
    if(self = [super initWithBc:@"add_order_net_real" AndTag:@"data"])
    {
        [dicPara setValue:userID forKey:@"UID"];
        [dicPara setValue:mpcode forKey:@"PRODCODE"];
        [dicPara setValue:(isBuy?@"66":@"83") forKey:@"BUYSELL"];
        [dicPara setValue:number forKey:@"QTY"];
        [dicPara setValue:price forKey:@"PRICE"];
        [dicPara setValue:@(type) forKey:@"ORDERTYPE"];
        [dicPara setValue:stopType forKey:@"STOPTYPE"];
        [dicPara setValue:stopPrice forKey:@"STOPLEVEL"];
        
        [dicPara setValue:pid forKey:@"PID"];
        [dicPara setValue:@(1) forKey:@"pltype"];
        
    }
    return self;
}
@end
