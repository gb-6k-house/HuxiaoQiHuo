//
//  FYHistoricalData.m
//  traderex
//
//  Created by cssoft on 15/10/20.
//  Copyright © 2015年 EasyFly. All rights reserved.
//

#import "FYHistoryData_Obj.h"

@implementation FYHistoryData_Obj

- (NSMutableArray *) arrayHistoricalData
{
    if (!_arrayHistoricalData) {
        
        _arrayHistoricalData = [NSMutableArray array];
    }
    return _arrayHistoricalData;
}

@end
