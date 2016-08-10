//
//  MerpList_Obj.h
//  Trader
//
//  Created by easyfly on 2/12/14.
//  Copyright (c) 2014 easyfly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PriceData_Obj.h"

@interface MerpList_Obj : NSObject

@property(nonatomic, strong) NSArray *arrayOCTlist;
@property double dDiff;
@property NSInteger nIndex;
@property(nonatomic,copy)NSString * strMpcode;
@property(nonatomic,copy)NSString * strMpname;
@property NSInteger nPrecision;
@property(nonatomic,copy)NSString * nDd;
@property int nUnit;
@property int nOpt;
@property(nonatomic,copy)NSString *strDataDate; //数据日期
@property int tag;
@property double dSetp;
@property(nonatomic, weak)PriceData_Obj*priceObJ; //行情数据
@end
