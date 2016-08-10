//
//  CPositionsDTO.m
//  XMClient
//
//  Created by wenbo.fan on 12-10-30.
//  Copyright (c) 2012年 wenbo.fan. All rights reserved.
//

#import "CPositionsDTO_Market.h"

@implementation CPositionsDTO_Market
@synthesize id,Isbuy,mmcode,price,number,loss,profit,accrual,time
;
-(NSString *)description
{

    

    return [NSString stringWithFormat:@"id:%d, Isbuy:%@,mmcode:%@, price:%f, number:%0.1f loss:%f accrual:%f time:%@", self.id,self.Isbuy?@"buy":@"sell", self.mmcode,self.price,self.number, self.loss, self.accrual, self.time];

}
@end

