//
//  TimeShare_Obj.h
//  Trader
//
//  Created by easyfly on 2/17/14.
//  Copyright (c) 2014 easyfly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeShare_Obj : NSObject

@property(nonatomic, copy) NSString * strAvgPrice;
@property(nonatomic, copy) NSString * strNowPrice;
@property(nonatomic, copy) NSString * strAllTranNum;
@property(nonatomic, copy) NSString * strMaxPrice;
@property(nonatomic, copy) NSString * strMinPrice;
@property(nonatomic, copy) NSString * strTime;

@property(nonatomic, copy) NSString * strTime_Old; //为整理的时间精确到秒


@property NSInteger nTime;


@end
