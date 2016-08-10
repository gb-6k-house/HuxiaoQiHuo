//
//  MarketDTO.h
//  XMClient
//
//  Created by wenbo.fan on 12-10-26.
//  Copyright (c) 2012年 wenbo.fan. All rights reserved.
//

#import "GT6Response.h"

@interface MarketDTO : GT6ResponseData
@property int		mtid;				//市场Id
@property NSString *  mtname;			//市场名称
@property int     mttype;            //0 不能交易  1 可以交易 //市场类型0 撮合  1 不撮合  2 做市商
@end
