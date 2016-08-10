//
//  CMerpOrderDTO.m
//  XMClient
//
//  Created by wenbo.fan on 12-10-26.
//  Copyright (c) 2012年 wenbo.fan. All rights reserved.
//

#import "CMerpOrderDTO.h"

@implementation CMerpOrderDTO
@synthesize mpid, mpcode, mpname,mpnowpic,firstprice,maxprice,minprice,alltrannumber,alltranprice,buyprice,sellprice,buynumber,sellnumber,buyallnumber,sellallnumber,avgtranprice,yeprice;
-(NSString *)description
{
    return [NSString stringWithFormat:@"mpid:%d mpcode:%@ mpname:%@ mpnowpic:%f firstprice:%f maxprice:%f minprice:%f alltrannumber:%d alltranprice:%f buyprice:%f sellprice:%f buynumber:%d sellnumber:%d buyallnumber:%d sellallnumber:%d avgtranprice:%f yeprice:%f", self.mpid, self.mpcode, self.mpname, self.mpnowpic, self.firstprice,self.maxprice,self.minprice, self.alltrannumber, self.alltranprice, self.buyprice, self.sellprice, self.buynumber, self.sellnumber, self.buyallnumber, self.sellallnumber, self.avgtranprice, self.yeprice];
}
@end
