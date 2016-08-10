//
//  CStatOrderDTO.h
//  XMClient
//
//  Created by wenbo.fan on 12-10-29.
//  Copyright (c) 2012年 wenbo.fan. All rights reserved.
//

#import "GT6Response.h"

@interface CStatOrderDTO : GT6ResponseData
@property NSString * mcode;	        //商品名称
@property int isbuy;	        	//买卖
@property int	count;		        //档次
@property double price;	        //价格
@property int number;		        //数量
@end
