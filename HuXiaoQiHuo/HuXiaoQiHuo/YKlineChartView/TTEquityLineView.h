//
//  TTEquityLineView.h
//  Test
//
//  Created by niupark on 16/5/17.
//  Copyright © 2016年 niupark. All rights reserved.
//

#import "YKLineChartViewBase.h"
#import "TTEquityDataSet.h"
#import "TTEquityEntity.h"
@interface TTEquityLineView : YKLineChartViewBase
- (void)setupData:(TTEquityDataSet *)dataSet;

@end
