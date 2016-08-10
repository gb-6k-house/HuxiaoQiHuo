//
//  FYAddorderhe_Obj.h
//  traderex
//
//  Created by cssoft on 15/9/10.
//  Copyright (c) 2015年 EasyFly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FYAddorderhe_Obj : NSObject

//成交单对象
@property NSInteger nUserId;//用户id

@property (nonatomic,retain) NSString * strMmcode;//商品编码

@property NSInteger nIsbuy;//买卖类型 1:买0:卖

@property float fNumber;//成交数量

@property float fPrice;//价格

@property NSInteger nAdverse;//模式 0:建仓 1:平仓

@property (nonatomic,retain) NSString *strDealtime;//时间


@end
