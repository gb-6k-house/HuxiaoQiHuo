//
//  TTEquityDataSet.m
//  Test
//
//  Created by niupark on 16/5/17.
//  Copyright © 2016年 niupark. All rights reserved.
//

#import "TTEquityDataSet.h"

@implementation TTEquityDataSet
-(instancetype)init{
    self = [super init];
    _borderColor = [UIColor grayColor];
    _textColor = [UIColor darkGrayColor];
    _backgroundColor = [UIColor whiteColor];
    _textFont = [UIFont systemFontOfSize:12.0f];
    _borderWidth = 1.f;
    _lineColor = [UIColor redColor];
    _level = 6;
    _startDate = @"--";
    _endDate = @"--";
    return self;
}
@end
