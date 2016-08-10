//
//  GraphResponse.h
//  Trader
//
//  Created by easyfly on 2/17/14.
//  Copyright (c) 2014 easyfly. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GraphResponse : NSObject

@property(nonatomic, copy) NSString * strMarketID;
@property(nonatomic, copy) NSString * strProductCode;
@property(nonatomic, copy) NSString * strProductName;

@property int nGraphType;
@property int nCount;

@property(nonatomic, copy) NSString *strType;//图形类型 M 分时图 M5 5分钟图...

@property(nonatomic, strong) NSMutableArray * arrayGraphDate_Obj;

@end
