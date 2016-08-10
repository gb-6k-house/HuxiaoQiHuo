//
//  MerpDTO.m
//  XMClient
//
//  Created by wenbo.fan on 12-10-26.
//  Copyright (c) 2012年 wenbo.fan. All rights reserved.
//

#import "MerpDTO.h"

@implementation MerpDTO
@synthesize mpid,mpcode,mpname,mpamount,mpstrp,mpycp,mpmart,mpstopcount,mpprecision,mpulcale,
mpupdecLine,mppicstep,ucglmcale,ucglmargin,ucgldccalebuy,ucgldealcostbuy,ucgldccalesell,ucgldealcostsell,mpdiff,mpxchange;
-(NSString *) description
{
    return [NSString stringWithFormat:@"mpid:%d mpcode:%@ mpname:%@ mpamount:%d mpstrp:%f mpycpy:%f mpmart:%d mpstopcount:%d mpprecision:%d mpulcale:%d mpupdecLine:%f mppicstep:%f ucglmcale:%d ucglmargin:%f ucgldccalebuy:%d ucgldealcostbuy:%f ucgldccalesell:%d ucgldealcostsell:%f mpdiff:%f mpxchange:%f @property double:%f",self.mpid, self.mpcode,self.mpname, self.mpamount,self.mpstrp,self.mpycp,self.mpmart,self.mpstopcount,self.mpprecision,self.mpulcale, self.mpupdecLine,self.mppicstep, self.ucglmcale,self.ucglmargin,self.ucgldccalebuy,self.ucgldealcostbuy,self.ucgldccalesell,self.ucgldealcostsell,self.mpdiff,self.mpxchange, self.span];
}
@end
