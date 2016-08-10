//
//  GraphData_Obj.h
//  Trader
//
//  Created by easyfly on 2/17/14.
//  Copyright (c) 2014 easyfly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GraphData_Obj : NSObject

@property(nonatomic, copy) NSString * strFirstPrice;
@property(nonatomic, copy) NSString * strLastPrice;
@property(nonatomic, copy) NSString * strMaxPrice;
@property(nonatomic, copy) NSString * strMinPrice;
@property(nonatomic, copy) NSString * strAllTranNum;
@property(nonatomic, copy) NSString * strTime;

@end
