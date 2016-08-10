//
//  COrderDTO.m
//  XMClient
//
//  Created by wenbo.fan on 12-10-30.
//  Copyright (c) 2012年 wenbo.fan. All rights reserved.
//

#import "COrderDTO_Match.h"

@implementation COrderDTO_Match
@synthesize id,price,ip,user,mmcode,time,isbuy,number,oddnumber,adverse,matchid,modetype,udtype;

-(NSString *)description
{

    return [NSString stringWithFormat:@"id:%d, price:%lf,ip:%@, user:%d, mmcode:%@ time:%@ isbuy:%@ number:%d oddnumber:%d adverse:%@ matchid:%d modetype:%@ udtype:%@",
            self.id, self.price, self.ip, self.user, self.mmcode, self.time, self.isbuy?@"buy":@"sell",
            self.number, self.oddnumber, self.adverse==0?@"建仓":@"平仓",  self.matchid,
            self.modetype==0?@"撮合":(self.modetype==1?@"不撮合":@"做市商"),
            self.udtype==0?@"向下":@"向上"];

    

}
@end
