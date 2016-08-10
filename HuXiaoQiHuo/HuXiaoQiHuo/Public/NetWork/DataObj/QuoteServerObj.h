//
//  QuoteServerObj.h
//  traderex
//
//  Created by zhouqing on 15/7/23.
//  Copyright (c) 2015年 EasyFly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CPriceClientSocket.h"
//#import "P_ClientSocket.h"
@interface QuoteServerObj : NSObject

@property(nonatomic,copy)NSString * PIP;

@property(nonatomic,copy)NSString * PPort;

@property(nonatomic, strong) CPriceClientSocket * priceSocket;

@property BOOL status;

@end
