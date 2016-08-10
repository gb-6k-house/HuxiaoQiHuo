//
//  SqliteManager.h
//  traderex
//
//  Created by cssoft on 15/5/14.
//  Copyright (c) 2015年 EasyFly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface SqliteManager : NSObject

- (NSArray *)getArrayFromSqliteDGFileByMarketID:(NSString *)strMarketID AndProductCode:(NSString *)strProductCode AndTime:(NSString *) strTimeDay;

- (NSArray *)getArrayFromSqliteMGFileByMarketID:(NSString *)strMarketID AndProductCode:(NSString *)strProductCode AndTime:(NSString *) strTimeDay AndOtherTime:(NSString *) strOtherTimeDay;

- (NSTimeInterval)getTimeFromSqliteMGFileByMarketID:(NSString *)strMarketID AndProductCode:(NSString *)strProductCode;

//查询大于strMinTime的数据
- (NSArray *)getArrayFromFilePath:(NSString *)filePath;

- (NSString *)queryMaxTime:(NSString *)filePath;

- (NSArray *)getArrayFromFilePath:(NSString *)filePath strType:(NSString *)strType andNMaxTime:(NSTimeInterval)NMaxTime;

@end
