//
//  FYPositionsData_Obj.m
//  traderex
//
//  Created by cssoft on 15/10/26.
//  Copyright © 2015年 EasyFly. All rights reserved.
//

#import "FYPositionsData_Obj.h"

@implementation FYPositionsData_Obj

- (NSMutableArray *) arrayPositionsData
{
    if (!_arrayPositionsData) {
        
        _arrayPositionsData = [NSMutableArray array];
    }
    return _arrayPositionsData;
}

@end
