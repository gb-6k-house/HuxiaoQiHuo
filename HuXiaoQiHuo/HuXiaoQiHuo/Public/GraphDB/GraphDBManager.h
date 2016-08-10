//
//  GraphDBManager.h
//  traderex
//
//  Created by EasyFly on 15/5/18.
//  Copyright (c) 2015年 EasyFly. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GraphData_M1.h"
#import "GraphData_M5.h"
#import "GraphData_M15.h"
#import "GraphData_M30.h"
#import "GraphData_H1.h"
#import "GraphData_H4.h"
#import "GraphData_D1.h"
#import "GraphData_W1.h"
#import "GraphData_MN.h"

//定义表名
#define kTABLE_GraphData_M1    @"GraphData_M1"
#define kTABLE_GraphData_M5    @"GraphData_M5"
#define kTABLE_GraphData_M15    @"GraphData_M15"
#define kTABLE_GraphData_M30    @"GraphData_M30"
#define kTABLE_GraphData_H1    @"GraphData_H1"
#define kTABLE_GraphData_H4    @"GraphData_H4"
#define kTABLE_GraphData_D1    @"GraphData_D1"
#define kTABLE_GraphData_W1    @"GraphData_W1"
#define kTABLE_GraphData_MN    @"GraphData_MN"

@interface GraphDBManager : NSObject
{
    
}

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

-(instancetype)initWithMarketId:(NSString*)marketId andMpCode:(NSString*)mpCode;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

//插入数据，数组里装的是7005对象
- (void)insertData:(NSArray *)arrayData AndType:(NSString *)type;

//通过开始时间，结束时间查询数据（开始时间大于结束时间）
- (NSArray *)queryData_ByBeginTime:(NSString *)beginTime EndTime:(NSString *)endTime AndType:(NSString *)type;

//查询DG数据，小于Maxtime的数据
- (NSArray *)queryDGData_ByMaxTime:(NSString *)maxTime AndType:(NSString *)type;

//查询DG文件里最大的时间,返回时间格式YYYY-MM-DD HH:MM:SS
- (NSString *)queryDGMaxTime;

//查询文件里最大的时间,返回时间格式YYYY-MM-DD HH:MM:SS
- (NSString *)queryMaxTimeByType:(NSString *)type;

//查询DG对应时间的MG文件是否下载，时间格式YYYY-MM-DD
- (BOOL)queryStatus_ByTime:(NSString *)strTime;

//更新DG对应时间的MG文件是否下载
- (void)updateStatus_ByTime:(NSString *)strTime AndStatus:(BOOL)status;

//删除过期数据
- (void)deleteDataByType:(NSString *)type;

//清空数据库记录
- (void)resetDataBase;

@end
