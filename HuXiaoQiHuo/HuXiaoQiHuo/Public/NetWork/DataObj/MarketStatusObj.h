//
//  MarketStatusObj.h
//  Trader
//
//  Created by EasyFly on 14-5-21.
//  Copyright (c) 2014年 easyfly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MarketStatusObj : NSObject

@property BOOL bExpired; // YES:OK  NO:过期
@property NSTimeInterval timeDate; //市场的过期时间

@end
