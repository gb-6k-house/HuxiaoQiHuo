//
//  FYHistoricalData.h
//  traderex
//
//  Created by cssoft on 15/10/20.
//  Copyright © 2015年 EasyFly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FYHistoryData_Obj : NSObject

@property NSInteger nCode;//编号

@property NSInteger nMsg;//持仓号

@property (nonatomic,retain) NSMutableArray *arrayHistoricalData;

@end
