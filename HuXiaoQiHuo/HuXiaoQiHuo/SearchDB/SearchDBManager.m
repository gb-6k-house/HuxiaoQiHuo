//
//  SearchDBManager.m
//  traderex
//
//  Created by XXJ on 15/11/19.
//  Copyright © 2015年 EasyFly. All rights reserved.
//

#import "SearchDBManager.h"

#define kSearchDataTableName @"Search_Data"
#define kSearchHistoryTableName @"Search_History"

@implementation SearchDBManager

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;


#pragma mark - 单例方法
+ (instancetype)sharedInstance
{
    static SearchDBManager *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc ] init];
    });
    return _sharedInstance;
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
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"SearchDBModel" withExtension:@"momd"];
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
    
    NSString * strSqliteFile = [NSString stringWithFormat:@"SearchModle.sqlite"];
    
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
//插入Search_Data数据
- (void)insertSearchData:(NSString *)strMapId AndIndexString:(NSString *)indexString
{
    if (strMapId == nil || indexString == nil) {
        return;
    }
    NSManagedObjectContext *context = [self managedObjectContext];
    
    
    Search_Data *searchDataEntity = [NSEntityDescription insertNewObjectForEntityForName:kSearchDataTableName inManagedObjectContext:context];
    
    searchDataEntity.mapId = strMapId;
    searchDataEntity.indexString = indexString;
 
}



//插入Search_History数据
- (void)insertSearchHistoryData:(NSString *)strMapId
{
    if (strMapId == nil ) {
        return;
    }
    NSManagedObjectContext *context = [self managedObjectContext];
    
    
    Search_History *searchDataEntity = [NSEntityDescription insertNewObjectForEntityForName:kSearchHistoryTableName inManagedObjectContext:context];
    
    searchDataEntity.mapId = strMapId;
    
    NSError *error;
    if(![context save:&error])
    {
        NSLog(@"不能保存：%@",[error localizedDescription]);
        return ;
    }
}

//删除Search_History数据
- (BOOL) deleteData_Search_HistoryByMapId:(NSString *)strMapId
{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    if (context == nil)
    {
        return false;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entityGroup = [NSEntityDescription entityForName:kSearchHistoryTableName inManagedObjectContext:context];
    
    [fetchRequest setEntity:entityGroup];
    
    //设置查询条件
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"mapid = %@",strMapId];
    
    [fetchRequest setPredicate:pred];
    
    
    NSError *error;
    
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    for (Search_History *search_History in fetchedObjects)
    {
        [context deleteObject:search_History];
    }
    
    //保存
    if (![context save:&error])
    {
        NSLog(@"deleteData_group_contact_ByGroupJid删除失败");
    }
    
    return YES;
}

//查询
- (NSMutableArray *)queryData_Search_DataByIndexString:(NSString *)strIndexString
{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    if (context == nil)
    {
        return nil;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entityGroup = [NSEntityDescription entityForName:kSearchDataTableName inManagedObjectContext:context];
    
    [fetchRequest setEntity:entityGroup];
    
    //设置查询条件
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"indexString like[cd] %@" ,[NSString stringWithFormat:@"*%@*",strIndexString]];
    [fetchRequest setPredicate:pred];
    
    
    NSError *error;
    
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    NSMutableArray *resultArray = [NSMutableArray array];
    
    for (Search_Data *search_Data in fetchedObjects)
    {
        [resultArray addObject:search_Data.mapId];
    }
    
    return resultArray;
    
}

- (NSMutableArray *)queryData_Search_History
{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    if (context == nil)
    {
        return nil;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entityGroup = [NSEntityDescription entityForName:kSearchHistoryTableName inManagedObjectContext:context];
    
    [fetchRequest setEntity:entityGroup];
    
   
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"searchTime"ascending:NO];
    
    NSArray *sortDescriptions = [[NSArray alloc]initWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptions];
    
    NSError *error;
    
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    NSMutableArray *resultArray = [NSMutableArray array];
    
    for (Search_Data *search_Data in fetchedObjects)
    {
        [resultArray addObject:search_Data.mapId];
    }
    
    return resultArray;
    
}

- (BOOL)haveSavedData {
    NSManagedObjectContext *context = [self managedObjectContext];
    
    if (context == nil)
    {
        return false;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entityGroup = [NSEntityDescription entityForName:kSearchDataTableName inManagedObjectContext:context];
    
    [fetchRequest setEntity:entityGroup];
    
    
    NSError *error;
    
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    NSMutableArray *resultArray = [NSMutableArray array];
    
    for (Search_Data *search_Data in fetchedObjects)
    {
        [resultArray addObject:search_Data.mapId];
    }
    
    if (resultArray.count) {
        return YES;
    }
    
    return NO;
}

- (void)resetDataBase
{
    [self deleteSearch_Data];
    
    [self deleteSearch_History];

}

- (void)deleteSearch_Data
{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    if (context == nil)
    {
        return;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entityContact = [NSEntityDescription entityForName:kSearchDataTableName inManagedObjectContext:context];
    
    [fetchRequest setEntity:entityContact];
    
    NSError *error;
    
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    if (!error) {
        for(Search_Data *search_Data in fetchedObjects) {
            [context deleteObject:search_Data];
        }
    }
    
    if([context hasChanges]) {
        [context save:&error];
    }
}

- (void)deleteSearch_History
{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    if (context == nil)
    {
        return;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entityContact = [NSEntityDescription entityForName:kSearchHistoryTableName inManagedObjectContext:context];
    
    [fetchRequest setEntity:entityContact];
    
    NSError *error;
    
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    if (!error) {
        for(Search_Data *search_Data in fetchedObjects) {
            [context deleteObject:search_Data];
        }
    }
    
    if([context hasChanges]) {
        [context save:&error];
    }
}






@end
