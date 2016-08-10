//
//  ModifyLossAndProfitRequest.h
//  TFBClient
//
//  Created by easyfly on 13-12-5.
//  Copyright (c) 2013年 easyfly. All rights reserved.
//

#import "GT6Request.h"

@interface ModifyLossAndProfitRequest : GT6Request

-(ModifyLossAndProfitRequest *)initWithLoss:(NSString *)loss
                                 profit:(NSString *)profit
                                  orderid:(NSString *)orderid;

@end
