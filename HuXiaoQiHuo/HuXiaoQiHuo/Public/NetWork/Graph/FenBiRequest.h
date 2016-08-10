//
//  FenBiRequest.h
//  Trader
//
//  Created by EasyFly on 14-7-31.
//  Copyright (c) 2014年 easyfly. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FenBiRequest : NSObject
//{"cmdCode":"7002","mapID":1,"startTime":"2014-06-19 00:00:00","endTime":"2014-06-20 12:00:00"}
//{"cmdCode":"7005","mapID":1,"startTime":"2014-06-19 00:00:00","endTime":"2014-06-20 12:00:00"}

@property(nonatomic, copy) NSString * cmdCode;
@property int  mapID;
@property(nonatomic, copy) NSString * startTime;
@property(nonatomic, copy) NSString * endTime;
@property int graphType;
@property(nonatomic, copy) NSString *strType;//图形类型 M 分时图 M5 5分钟图...


@end