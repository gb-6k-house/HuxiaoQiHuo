//
//  GraphDBManager.m
//  traderex
//
//  Created by EasyFly on 15/5/18.
//  Copyright (c) 2015年 EasyFly. All rights reserved.
//

#import "GraphDBManager.h"

#import "FenBi7005Data_Obj.h"
@interface GraphDBManager (){
    NSString *_marketId;
    NSString *_mpCode;
}
@end
@implementation GraphDBManager

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;


#pragma mark - 单例方法
static GraphDBManager * instance = nil;



- (id)copyWithZone:(NSZone *)zone
{
    return self;
}



-(instancetype)initWithMarketId:(NSString*)marketId andMpCode:(NSString*)mpCode{
    self = [super init];
    if (self) {
        _mpCode = mpCode;
        _marketId = marketId;
    }
    return self;
}

#pragma mark - CoreData

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"GraphDBModel" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    
    NSString * strSqliteFile = [NSString stringWithFormat:@"%@_%@Modle.sqlite", _marketId,_mpCode];
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:strSqliteFile];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.获取Documents路径
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - 自定义方法

- (NSArray *)queryData_ByBeginTime:(NSString *)beginTime EndTime:(NSString *)endTime AndType:(NSString *)type
{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    if (context == nil)
    {
        return nil;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSString *tableName = [NSString stringWithFormat:@"GraphData_%@",type];
    
    NSEntityDescription *entityContact = [NSEntityDescription entityForName:tableName inManagedObjectContext:context];
    
    [fetchRequest setEntity:entityContact];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"datetime"ascending:YES];
    
    NSArray *sortDescriptions = [[NSArray alloc]initWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptions];
    
    //设置查询条件
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(datetime < %@) AND (datetime >= %@)",beginTime,endTime];
    
    [fetchRequest setPredicate:pred];
    
    
    NSError *error;
    
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    return fetchedObjects;
}

- (NSArray *)queryDGData_ByMaxTime:(NSString *)maxTime AndType:(NSString *)type
{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    if (context == nil)
    {
        return nil;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSString *tableName = [NSString stringWithFormat:@"GraphData_%@",type];
    
    NSEntityDescription *entityContact = [NSEntityDescription entityForName:tableName inManagedObjectContext:context];
    
    [fetchRequest setEntity:entityContact];
    
    //设置查询条件
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"datetime < %@",maxTime];
    
    [fetchRequest setPredicate:pred];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"datetime"ascending:YES];
    
    NSArray *sortDescriptions = [[NSArray alloc]initWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptions];
    
    NSError *error;
    
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    return fetchedObjects;
}

- (NSString *)queryDGMaxTime
{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    if (context == nil)
    {
        return nil;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSString *tableName = @"GraphData_D1";
    
    NSEntityDescription *entityContact = [NSEntityDescription entityForName:tableName inManagedObjectContext:context];
    
    [fetchRequest setEntity:entityContact];
    
    //    //设置查询条件
    //    NSPredicate *pred = [NSPredicate predicateWithFormat:@"datetime > %@",@"0000-00-00 00:00:00"];
    //
    //    [fetchRequest setPredicate:pred];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"datetime"ascending:NO];
    
    NSArray *sortDescriptions = [[NSArray alloc]initWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptions];
    
    
    [fetchRequest
     setFetchLimit:1];
    
    [fetchRequest
     setFetchOffset:0];
    
    NSError *error;
    
    
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    GraphData_D1 *obj = [fetchedObjects lastObject];
    
    return obj.datetime;
}

- (NSString *)queryMaxTimeByType:(NSString *)type
{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    if (context == nil)
    {
        return nil;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSString *tableName = [NSString stringWithFormat:@"GraphData_%@",type] ;
    
    
    NSEntityDescription *entityContact = [NSEntityDescription entityForName:tableName inManagedObjectContext:context];
    
    [fetchRequest setEntity:entityContact];
    
    //    //设置查询条件
    //    NSPredicate *pred = [NSPredicate predicateWithFormat:@"datetime > %@",@"0000-00-00 00:00:00"];
    //
    //    [fetchRequest setPredicate:pred];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"datetime"ascending:NO];
    
    NSArray *sortDescriptions = [[NSArray alloc]initWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptions];
    
    
    [fetchRequest
     setFetchLimit:1];
    
    [fetchRequest
     setFetchOffset:0];
    
    NSError *error;
    
    
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    if ([type isEqualToString:@"M1"]) {
        
        GraphData_M1 *obj = [fetchedObjects lastObject];
        
        return obj.datetime;
        
    } else if ([type isEqualToString:@"M5"]) {
        
        GraphData_M5 *obj = [fetchedObjects lastObject];
        
        return obj.datetime;
        
    } else if ([type isEqualToString:@"M15"]) {
        
        GraphData_M15 *obj = [fetchedObjects lastObject];
        
        return obj.datetime;
        
    } else if ([type isEqualToString:@"M30"]) {
        
        GraphData_M30 *obj = [fetchedObjects lastObject];
        
        return obj.datetime;
        
    } else if ([type isEqualToString:@"H1"]) {
        
        GraphData_H1 *obj = [fetchedObjects lastObject];
        
        return obj.datetime;
        
    } else if ([type isEqualToString:@"H4"]) {
        
        GraphData_H4 *obj = [fetchedObjects lastObject];
        
        return obj.datetime;
        
    } else if ([type isEqualToString:@"D1"]) {
        
        GraphData_D1 *obj = [fetchedObjects lastObject];
        
        return obj.datetime;
        
    }
    
    
    return nil;
    
}


- (void)insertData:(NSArray *)arrayData AndType:(NSString *)type
{
    for (FenBi7005Data_Obj *data_obj in arrayData) {
        [self insertGraphData:data_obj AndType:type];
    }
}

- (void)insertGraphData:(FenBi7005Data_Obj *)data_obj AndType:(NSString *)type
{
    if (data_obj == nil) {
        return;
    }
    NSManagedObjectContext *context = [self managedObjectContext];
    
    if ([type isEqualToString:@"M1"]) {
        
        GraphData_M1 *graphEntity = [NSEntityDescription insertNewObjectForEntityForName:kTABLE_GraphData_M1 inManagedObjectContext:context];
        
        graphEntity.amount = [NSNumber numberWithInteger:[data_obj.strAmount integerValue]];
        
        graphEntity.closeprice = [NSNumber numberWithFloat:[data_obj.strClosePrice floatValue]];
        
        graphEntity.datetime = data_obj.strTime;
        
        graphEntity.highestprice = [NSNumber numberWithFloat:[data_obj.strHighestPrice floatValue]];
        
        graphEntity.lowestprice = [NSNumber numberWithFloat:[data_obj.strLowestPrice floatValue]];
        
        graphEntity.openprice = [NSNumber numberWithFloat:[data_obj.strOpenPrice floatValue]];
        
        graphEntity.status = [NSNumber numberWithBool:NO];
        
        graphEntity.time = [NSNumber numberWithInteger:data_obj.nTime];
        
        graphEntity.volume = [NSNumber numberWithInteger:[data_obj.strVolume integerValue]];
        
    } else if ([type isEqualToString:@"M5"]) {
        
        GraphData_M5 *graphEntity = [NSEntityDescription insertNewObjectForEntityForName:kTABLE_GraphData_M5 inManagedObjectContext:context];
        
        graphEntity.amount = [NSNumber numberWithInteger:[data_obj.strAmount integerValue]];
        
        graphEntity.closeprice = [NSNumber numberWithFloat:[data_obj.strClosePrice floatValue]];
        
        graphEntity.datetime = data_obj.strTime;
        
        graphEntity.highestprice = [NSNumber numberWithFloat:[data_obj.strHighestPrice floatValue]];
        
        graphEntity.lowestprice = [NSNumber numberWithFloat:[data_obj.strLowestPrice floatValue]];
        
        graphEntity.openprice = [NSNumber numberWithFloat:[data_obj.strOpenPrice floatValue]];
        
        graphEntity.status = [NSNumber numberWithBool:NO];
        
        graphEntity.time = [NSNumber numberWithInteger:data_obj.nTime];
        
        graphEntity.volume = [NSNumber numberWithInteger:[data_obj.strVolume integerValue]];
        
        
    } else if ([type isEqualToString:@"M15"]) {
        
        GraphData_M15 *graphEntity = [NSEntityDescription insertNewObjectForEntityForName:kTABLE_GraphData_M15 inManagedObjectContext:context];
        
        graphEntity.amount = [NSNumber numberWithInteger:[data_obj.strAmount integerValue]];
        
        graphEntity.closeprice = [NSNumber numberWithFloat:[data_obj.strClosePrice floatValue]];
        
        graphEntity.datetime = data_obj.strTime;
        
        graphEntity.highestprice = [NSNumber numberWithFloat:[data_obj.strHighestPrice floatValue]];
        
        graphEntity.lowestprice = [NSNumber numberWithFloat:[data_obj.strLowestPrice floatValue]];
        
        graphEntity.openprice = [NSNumber numberWithFloat:[data_obj.strOpenPrice floatValue]];
        
        graphEntity.status = [NSNumber numberWithBool:NO];
        
        graphEntity.time = [NSNumber numberWithInteger:data_obj.nTime];
        
        graphEntity.volume = [NSNumber numberWithInteger:[data_obj.strVolume integerValue]];
        
        
    } else if ([type isEqualToString:@"M30"]) {
        
        GraphData_M30 *graphEntity = [NSEntityDescription insertNewObjectForEntityForName:kTABLE_GraphData_M30 inManagedObjectContext:context];
        
        graphEntity.amount = [NSNumber numberWithInteger:[data_obj.strAmount integerValue]];
        
        graphEntity.closeprice = [NSNumber numberWithFloat:[data_obj.strClosePrice floatValue]];
        
        graphEntity.datetime = data_obj.strTime;
        
        graphEntity.highestprice = [NSNumber numberWithFloat:[data_obj.strHighestPrice floatValue]];
        
        graphEntity.lowestprice = [NSNumber numberWithFloat:[data_obj.strLowestPrice floatValue]];
        
        graphEntity.openprice = [NSNumber numberWithFloat:[data_obj.strOpenPrice floatValue]];
        
        graphEntity.status = [NSNumber numberWithBool:NO];
        
        graphEntity.time = [NSNumber numberWithInteger:data_obj.nTime];
        
        graphEntity.volume = [NSNumber numberWithInteger:[data_obj.strVolume integerValue]];
        
        
    } else if ([type isEqualToString:@"H1"]) {
        
        GraphData_H1 *graphEntity = [NSEntityDescription insertNewObjectForEntityForName:kTABLE_GraphData_H1 inManagedObjectContext:context];
        
        graphEntity.amount = [NSNumber numberWithInteger:[data_obj.strAmount integerValue]];
        
        graphEntity.closeprice = [NSNumber numberWithFloat:[data_obj.strClosePrice floatValue]];
        
        graphEntity.datetime = data_obj.strTime;
        
        graphEntity.highestprice = [NSNumber numberWithFloat:[data_obj.strHighestPrice floatValue]];
        
        graphEntity.lowestprice = [NSNumber numberWithFloat:[data_obj.strLowestPrice floatValue]];
        
        graphEntity.openprice = [NSNumber numberWithFloat:[data_obj.strOpenPrice floatValue]];
        
        graphEntity.status = [NSNumber numberWithBool:NO];
        
        graphEntity.time = [NSNumber numberWithInteger:data_obj.nTime];
        
        graphEntity.volume = [NSNumber numberWithInteger:[data_obj.strVolume integerValue]];
        
        
    } else if ([type isEqualToString:@"H4"]) {
        
        GraphData_H4 *graphEntity = [NSEntityDescription insertNewObjectForEntityForName:kTABLE_GraphData_H4 inManagedObjectContext:context];
        
        graphEntity.amount = [NSNumber numberWithInteger:[data_obj.strAmount integerValue]];
        
        graphEntity.closeprice = [NSNumber numberWithFloat:[data_obj.strClosePrice floatValue]];
        
        graphEntity.datetime = data_obj.strTime;
        
        graphEntity.highestprice = [NSNumber numberWithFloat:[data_obj.strHighestPrice floatValue]];
        
        graphEntity.lowestprice = [NSNumber numberWithFloat:[data_obj.strLowestPrice floatValue]];
        
        graphEntity.openprice = [NSNumber numberWithFloat:[data_obj.strOpenPrice floatValue]];
        
        graphEntity.status = [NSNumber numberWithBool:NO];
        
        graphEntity.time = [NSNumber numberWithInteger:data_obj.nTime];
        
        graphEntity.volume = [NSNumber numberWithInteger:[data_obj.strVolume integerValue]];
        
        
    } else if ([type isEqualToString:@"D1"]) {
        
        GraphData_D1 *graphEntity = [NSEntityDescription insertNewObjectForEntityForName:kTABLE_GraphData_D1 inManagedObjectContext:context];
        
        graphEntity.amount = [NSNumber numberWithInteger:[data_obj.strAmount integerValue]];
        
        graphEntity.closeprice = [NSNumber numberWithFloat:[data_obj.strClosePrice floatValue]];
        
        graphEntity.datetime = data_obj.strTime;
        
        graphEntity.highestprice = [NSNumber numberWithFloat:[data_obj.strHighestPrice floatValue]];
        
        graphEntity.lowestprice = [NSNumber numberWithFloat:[data_obj.strLowestPrice floatValue]];
        
        graphEntity.openprice = [NSNumber numberWithFloat:[data_obj.strOpenPrice floatValue]];
        
        graphEntity.status = [NSNumber numberWithBool:NO];
        
        graphEntity.time = [NSNumber numberWithInteger:data_obj.nTime];
        
        graphEntity.volume = [NSNumber numberWithInteger:[data_obj.strVolume integerValue]];
        
        
    } else if ([type isEqualToString:@"W1"]) {
        
        GraphData_W1 *graphEntity = [NSEntityDescription insertNewObjectForEntityForName:kTABLE_GraphData_W1 inManagedObjectContext:context];
        
        graphEntity.amount = [NSNumber numberWithInteger:[data_obj.strAmount integerValue]];
        
        graphEntity.closeprice = [NSNumber numberWithFloat:[data_obj.strClosePrice floatValue]];
        
        graphEntity.datetime = data_obj.strTime;
        
        graphEntity.highestprice = [NSNumber numberWithFloat:[data_obj.strHighestPrice floatValue]];
        
        graphEntity.lowestprice = [NSNumber numberWithFloat:[data_obj.strLowestPrice floatValue]];
        
        graphEntity.openprice = [NSNumber numberWithFloat:[data_obj.strOpenPrice floatValue]];
        
        graphEntity.status = [NSNumber numberWithBool:NO];
        
        graphEntity.time = [NSNumber numberWithInteger:data_obj.nTime];
        
        graphEntity.volume = [NSNumber numberWithInteger:[data_obj.strVolume integerValue]];
        
        
    } else if ([type isEqualToString:@"MN"]) {
        
        GraphData_MN *graphEntity = [NSEntityDescription insertNewObjectForEntityForName:kTABLE_GraphData_MN inManagedObjectContext:context];
        
        graphEntity.amount = [NSNumber numberWithInteger:[data_obj.strAmount integerValue]];
        
        graphEntity.closeprice = [NSNumber numberWithFloat:[data_obj.strClosePrice floatValue]];
        
        graphEntity.datetime = data_obj.strTime;
        
        graphEntity.highestprice = [NSNumber numberWithFloat:[data_obj.strHighestPrice floatValue]];
        
        graphEntity.lowestprice = [NSNumber numberWithFloat:[data_obj.strLowestPrice floatValue]];
        
        graphEntity.openprice = [NSNumber numberWithFloat:[data_obj.strOpenPrice floatValue]];
        
        graphEntity.status = [NSNumber numberWithBool:NO];
        
        graphEntity.time = [NSNumber numberWithInteger:data_obj.nTime];
        
        graphEntity.volume = [NSNumber numberWithInteger:[data_obj.strVolume integerValue]];
        
    }
    
    NSError *error;
    if(![context save:&error])
    {
        NSLog(@"不能保存：%@",[error localizedDescription]);
        return ;
    }
}

- (void)updateStatus_ByTime:(NSString *)strTime AndStatus:(BOOL)status
{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    if (context == nil)
    {
        return;
    }
    
    NSArray *fetchedObjects = [self queryD1Data_ByTime:strTime];
    
    GraphData_D1 *result = [fetchedObjects firstObject];
    
    result.status = [NSNumber numberWithBool:status];
    
    
    NSError *error;
    if(![context save:&error])
    {
        NSLog(@"不能保存：%@",[error localizedDescription]);
        return;
    }
    
    return;
}

- (BOOL)queryStatus_ByTime:(NSString *)strTime
{
    //    NSManagedObjectContext *context = [self managedObjectContext];
    //
    //    if (context == nil)
    //    {
    //        return nil;
    //    }
    //
    //    NSArray *fetchedObjects = [self queryD1Data_ByTime:strTime];
    //
    //    GraphData_D1 *result = [fetchedObjects firstObject];
    
    NSArray *fetchedObjects = [self queryData_ByBeginTime:[strTime stringByAppendingString:@" 23:59:59"] EndTime:[strTime stringByAppendingString:@" 00:00:00"] AndType:@"D1"];
    
    if (fetchedObjects.count != 0) {
        GraphData_D1 *result = [fetchedObjects firstObject];
        return [result.status boolValue];
    }
    
    return NO;
}

- (NSArray *)queryD1Data_ByTime:(NSString *)strTime
{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    if (context == nil)
    {
        return nil;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entityContact = [NSEntityDescription entityForName:kTABLE_GraphData_D1 inManagedObjectContext:context];
    
    [fetchRequest setEntity:entityContact];
    
    //设置查询条件
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"datetime == %@",strTime];
    
    [fetchRequest setPredicate:pred];
    
    
    NSError *error;
    
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    return fetchedObjects;
    
}

- (void)deleteDataByType:(NSString *)type
{
    NSArray *arrayType = nil;
    
    if ([type isEqualToString:@"M1"]) {
        arrayType = @[@"M1"];
    } else if ([type isEqualToString:@"D1"]) {
        arrayType = @[@"D1"];
    } else  {
        arrayType = @[@"M5",
                      @"M15",
                      @"M30",
                      @"H1",
                      @"H4"];
    }
    
    for (NSString *type in arrayType) {
        [self deleteByType:type];
    }
    
}

- (void)resetDataBase
{
    NSArray *arrayType = @[@"M1",
                           @"M5",
                           @"M15",
                           @"M30",
                           @"H1",
                           @"H4",
                           @"D1"];
    
    for (NSString *type in arrayType) {
        [self deleteByType:type];
    }
}

- (void)deleteByType:(NSString *)type
{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    if (context == nil)
    {
        return;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSString *tableName = [NSString stringWithFormat:@"GraphData_%@",type];
    
    NSEntityDescription *entityContact = [NSEntityDescription entityForName:tableName inManagedObjectContext:context];
    
    [fetchRequest setEntity:entityContact];
    
    
    
    NSError *error;
    
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    if ([tableName isEqualToString:kTABLE_GraphData_M1]) {
        if (!error) {
            for(GraphData_M1 *object in fetchedObjects) {
                [context deleteObject:object];
            }
        }
    } else if ([tableName isEqualToString:kTABLE_GraphData_M5]) {
        if (!error) {
            for(GraphData_M5 *object in fetchedObjects) {
                [context deleteObject:object];
            }
        }
    } else if ([tableName isEqualToString:kTABLE_GraphData_M15]) {
        if (!error) {
            for(GraphData_M15 *object in fetchedObjects) {
                [context deleteObject:object];
            }
        }
    } else if ([tableName isEqualToString:kTABLE_GraphData_M30]) {
        if (!error) {
            for(GraphData_M30 *object in fetchedObjects) {
                [context deleteObject:object];
            }
        }
    } else if ([tableName isEqualToString:kTABLE_GraphData_H1]) {
        if (!error) {
            for(GraphData_H1 *object in fetchedObjects) {
                [context deleteObject:object];
            }
        }
    } else if ([tableName isEqualToString:kTABLE_GraphData_H4]) {
        if (!error) {
            for(GraphData_H4 *object in fetchedObjects) {
                [context deleteObject:object];
            }
        }
    } else if ([tableName isEqualToString:kTABLE_GraphData_D1]) {
        if (!error) {
            for(GraphData_D1 *object in fetchedObjects) {
                [context deleteObject:object];
            }
        }
    }
    
    
    if([context hasChanges]) {
        [context save:&error];
    }
}

@end
