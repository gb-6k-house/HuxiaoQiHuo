//
//  SearchDBManager.h
//  traderex
//
//  Created by XXJ on 15/11/19.
//  Copyright © 2015年 EasyFly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Search_Data.h"
#import "Search_History.h"

@interface SearchDBManager : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (instancetype)sharedInstance;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


- (void)insertSearchData:(NSString *)strMapId AndIndexString:(NSString *)indexString;

//插入Search_History数据
- (void)insertSearchHistoryData:(NSString *)strMapId;

//删除Search_History数据
- (BOOL) deleteData_Search_HistoryByMapId:(NSString *)strMapId;

//查询
- (NSMutableArray *)queryData_Search_DataByIndexString:(NSString *)strIndexString;

- (NSMutableArray *)queryData_Search_History;

- (BOOL)haveSavedData;

- (void)resetDataBase;

@end
