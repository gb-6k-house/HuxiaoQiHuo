//
//  SqliteManager.m
//  traderex
//
//  Created by cssoft on 15/5/14.
//  Copyright (c) 2015年 EasyFly. All rights reserved.
//

#import "SqliteManager.h"
#import "DBFileManager.h"
#import "FenBi7005Data_Obj.h"
#import "Constants.h"
#import "NetWorkManager.h"

@implementation SqliteManager

-(SqliteManager *) init
{
    if (self = [super init]) {
        
        
        [self initSqliteManager];
    }
    return self;
}

- (void) initSqliteManager
{
}

#pragma mark-查询sqlite 的MG文件数据返回一个NSTimeInterval
- (NSTimeInterval)getTimeFromSqliteMGFileByMarketID:(NSString *)strMarketID AndProductCode:(NSString *)strProductCode
{
    
    
    NSString *Path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *strFile,*filePath;
    
    
    strFile = [Path stringByAppendingString:@"/db/DG/"];
    
    NSString *filename = [NSString stringWithFormat:@"%@_%@.db",strMarketID,strProductCode];
    
    filePath = [strFile stringByAppendingPathComponent:filename];
    
    
    sqlite3 *database;
    
    NSLog(@"文件路径为：%@",filePath);
    
    if (sqlite3_open([filePath UTF8String], &database) !=SQLITE_OK ) {
        
        sqlite3_close(database);
        
        NSLog(@"打开数据库失败");
        
        //删除不能打开的文件
        [[NetWorkManager sharedInstance] deleteConfigFile:@"/db/DG/" AndFileURL:filename];
        
        //重新下载文件
//        [[DBFileManager Instance] downloadDBFileFrom:[GlobalVar Instance].strDBURL AndDBFileType:DBFileType_DG AndMarketID:strMarketID AndProductCode:strProductCode AndDay:nil];
        
        return 0;
        
    }
    
    //获取表名
    NSString *file = [[filename componentsSeparatedByString:@"."] firstObject];
    
    NSString *query =[NSString stringWithFormat:@"SELECT  * FROM \"%@\" ORDER BY \"time\" DESC",file];
    
    sqlite3_stmt *statement;
    NSTimeInterval time = 0;
    if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil)==SQLITE_OK) {
        
        if (sqlite3_step(statement) == SQLITE_ROW) {
            
            char *rowData1 = (char *)sqlite3_column_text(statement, 0);
            NSString *fieldValue1 = [[NSString alloc] initWithUTF8String:rowData1];
            time = [fieldValue1 intValue];
            
        }
        sqlite3_finalize(statement);
        
    }
    sqlite3_close(database);
    
    return time;
}

#pragma mark-查询sqlite 的DG文件数据返回一个array
- (NSArray *)getArrayFromSqliteDGFileByMarketID:(NSString *)strMarketID AndProductCode:(NSString *)strProductCode AndTime:(NSString *) strTimeDay
{
    NSMutableArray *arrayData = [NSMutableArray array];
    
    //转换时间格式
    NSInteger nTimeDay = [[NetWorkManager sharedInstance] getTimeIntervalFromStr:strTimeDay];
    
    NSString *Path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *strFile,*filePath;
    
    
//    //转换时间格式
//    strTimeDay = [[PublicFun Instance]convertDateFormatter:const_Trader_strTimeFormatter_YMDHMS targetFormatter:const_strTimeFormatter_Y_M_D dateString:strTimeDay];
    
    strFile = [Path stringByAppendingString:@"/db/DG/"];
    
   // strFile = [NSString stringWithFormat:@"%@%@/",strFile,strTimeDay];
    
    NSString *filename = [NSString stringWithFormat:@"%@_%@.db",strMarketID,strProductCode];
    
    filePath = [strFile stringByAppendingPathComponent:filename];
    
    
    sqlite3 *database;
    
    NSLog(@"文件路径为：%@",filePath);
    
    if (sqlite3_open([filePath UTF8String], &database) !=SQLITE_OK ) {
        
        sqlite3_close(database);
        
        NSLog(@"打开数据库失败");
        
        
        //删除不能打开的文件
        [[NetWorkManager sharedInstance] deleteConfigFile:@"/db/DG/" AndFileURL:filename];
        
        //重新下载文件
//        [[DBFileManager Instance] downloadDBFileFrom:[GlobalVar Instance].strDBURL AndDBFileType:DBFileType_DG AndMarketID:strMarketID AndProductCode:strProductCode AndDay:nil];
        
        return 0;
        
    }
    
    //获取表名
    NSString *file = [[filename componentsSeparatedByString:@"."] firstObject];
    
//    NSString *query =[NSString stringWithFormat:@"SELECT rowid, * FROM \"%@\"  ORDER BY \"rowid\" ASC",file];//按时间大小倒序排列
    
     NSString *query =[NSString stringWithFormat:@"SELECT  * FROM \"%@\"   where time<%ld  ORDER BY \"time\" ASC",file,(long)nTimeDay ];//按时间大小倒序排列 并且取出比给定时间小或者相等的数据
    
    sqlite3_stmt *statement;
    
    if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil)==SQLITE_OK) {
        
        while (sqlite3_step(statement) == SQLITE_ROW) {
            
            FenBi7005Data_Obj *obj_GraphDB = [[FenBi7005Data_Obj alloc]init];
            
            //int rowNum = sqlite3_column_int(statement, 0);//获取行号存储在int变量中
            
            char *rowData1 = (char *)sqlite3_column_text(statement, 0);
            NSString *fieldValue1 = [[NSString alloc] initWithUTF8String:rowData1];
            obj_GraphDB.nTime = [fieldValue1 intValue];
            
            char *rowData2 = (char *)sqlite3_column_text(statement, 1);
            NSString *fieldValue2 = [[NSString alloc] initWithUTF8String:rowData2];
            obj_GraphDB.strTime = fieldValue2;
            
            char *rowData3 = (char *)sqlite3_column_text(statement, 2);
            NSString *fieldValue3 = [[NSString alloc] initWithUTF8String:rowData3];
            obj_GraphDB.strOpenPrice = fieldValue3;
            
            char *rowData4 = (char *)sqlite3_column_text(statement, 3);
            NSString *fieldValue4 = [[NSString alloc] initWithUTF8String:rowData4];
            obj_GraphDB.strClosePrice = fieldValue4;
            
            char *rowData5 = (char *)sqlite3_column_text(statement, 4);
            NSString *fieldValue5 = [[NSString alloc] initWithUTF8String:rowData5];
            obj_GraphDB.strHighestPrice = fieldValue5;
            
            char *rowData6 = (char *)sqlite3_column_text(statement, 5);
            NSString *fieldValue6 = [[NSString alloc] initWithUTF8String:rowData6];
            obj_GraphDB.strLowestPrice = fieldValue6;
            
            char *rowData7 = (char *)sqlite3_column_text(statement, 6);
            NSString *fieldValue7 = [[NSString alloc] initWithUTF8String:rowData7];
            obj_GraphDB.strVolume = fieldValue7;
            
            char *rowData8 = (char *)sqlite3_column_text(statement, 7);
            NSString *fieldValue8 = [[NSString alloc] initWithUTF8String:rowData8];
            obj_GraphDB.strAmount = fieldValue8;
            
            
            [arrayData addObject:obj_GraphDB];
            
        }
        sqlite3_finalize(statement);
        
    }
    sqlite3_close(database);
    
    return arrayData;
}

#pragma mark-查询sqlite 的MG文件数据返回一个array
- (NSArray *)getArrayFromSqliteMGFileByMarketID:(NSString *)strMarketID AndProductCode:(NSString *)strProductCode AndTime:(NSString *) strTimeDay AndOtherTime:(NSString *) strOtherTimeDay{
    NSMutableArray *arrayData = [NSMutableArray array];
    
    //转换时间格式
    NSInteger nTimeDay = [[NetWorkManager sharedInstance] getTimeIntervalFromStr:strTimeDay];
    
    NSString *Path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *strFile,*filePath;
    
//    //转换时间格式
//    strTimeDay = [[PublicFun Instance]convertDateFormatter:const_Trader_strTimeFormatter_YMDHMS targetFormatter:const_strTimeFormatter_Y_M_D dateString:strTimeDay];
    
    strFile = [Path stringByAppendingString:@"/db/MG/"];
    
    strFile = [NSString stringWithFormat:@"%@%@/",strFile,strOtherTimeDay];
    
    NSString *filename = [NSString stringWithFormat:@"%@_%@.db",strMarketID,strProductCode];
    
    filePath = [strFile stringByAppendingPathComponent:filename];
    
    
    sqlite3 *database;
    
    NSLog(@"文件路径为：%@",filePath);
    
    if (sqlite3_open([filePath UTF8String], &database) !=SQLITE_OK ) {
        
        sqlite3_close(database);
        
        NSLog(@"打开数据库失败");
        
        NSString *downloadedFilePath= [NSString stringWithFormat:@"%@/%@",@"/db/MG/",strTimeDay];
        
        //删除不能打开的文件
        [[NetWorkManager sharedInstance] deleteConfigFile:downloadedFilePath AndFileURL:filename];
        
        //重新下载文件
//        [[DBFileManager Instance] downloadDBFileFrom:[GlobalVar Instance].strDBURL AndDBFileType:DBFileType_MG AndMarketID:strMarketID AndProductCode:strProductCode AndDay:strTimeDay];
        
        return 0;
        
    }
    
    //获取表名
    NSString *file = [[filename componentsSeparatedByString:@"."] firstObject];
    
    //    NSString *query =[NSString stringWithFormat:@"SELECT rowid, * FROM \"%@\"  ORDER BY \"rowid\" ASC",file];//按时间大小倒序排列
    
    NSString *query =[NSString stringWithFormat:@"SELECT  * FROM \"%@\"   where time<%ld  ORDER BY \"time\" ASC",file,(long)nTimeDay ];//按时间大小倒序排列 并且取出比给定时间小或者相等的数据
    
    sqlite3_stmt *statement;
    
    if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil)==SQLITE_OK) {
        
        while (sqlite3_step(statement) == SQLITE_ROW) {
            
            FenBi7005Data_Obj *obj_GraphDB = [[FenBi7005Data_Obj alloc]init];
            
            //int rowNum = sqlite3_column_int(statement, 0);//获取行号存储在int变量中
            
            char *rowData1 = (char *)sqlite3_column_text(statement, 0);
            NSString *fieldValue1 = [[NSString alloc] initWithUTF8String:rowData1];
            obj_GraphDB.nTime = [fieldValue1 intValue];
            
            char *rowData2 = (char *)sqlite3_column_text(statement, 1);
            NSString *fieldValue2 = [[NSString alloc] initWithUTF8String:rowData2];
            obj_GraphDB.strTime = fieldValue2;
            
            char *rowData3 = (char *)sqlite3_column_text(statement, 2);
            NSString *fieldValue3 = [[NSString alloc] initWithUTF8String:rowData3];
            obj_GraphDB.strOpenPrice = fieldValue3;
            
            char *rowData4 = (char *)sqlite3_column_text(statement, 3);
            NSString *fieldValue4 = [[NSString alloc] initWithUTF8String:rowData4];
            obj_GraphDB.strClosePrice = fieldValue4;
            
            char *rowData5 = (char *)sqlite3_column_text(statement, 4);
            NSString *fieldValue5 = [[NSString alloc] initWithUTF8String:rowData5];
            obj_GraphDB.strHighestPrice = fieldValue5;
            
            char *rowData6 = (char *)sqlite3_column_text(statement, 5);
            NSString *fieldValue6 = [[NSString alloc] initWithUTF8String:rowData6];
            obj_GraphDB.strLowestPrice = fieldValue6;
            
            char *rowData7 = (char *)sqlite3_column_text(statement, 6);
            NSString *fieldValue7 = [[NSString alloc] initWithUTF8String:rowData7];
            obj_GraphDB.strVolume = fieldValue7;
            
            char *rowData8 = (char *)sqlite3_column_text(statement, 7);
            NSString *fieldValue8 = [[NSString alloc] initWithUTF8String:rowData8];
            obj_GraphDB.strAmount = fieldValue8;
            
            
            [arrayData addObject:obj_GraphDB];
            
        }
        sqlite3_finalize(statement);
        
    }
    sqlite3_close(database);
    
    return arrayData;
}

- (NSArray *)getArrayFromFilePath:(NSString *)filePath
{
    
    NSMutableArray *arrayData = [NSMutableArray array];
    
    sqlite3 *database;
    
    if (sqlite3_open([filePath UTF8String], &database) !=SQLITE_OK ) {
        
        sqlite3_close(database);
        
        NSLog(@"打开数据库失败");

        return nil;
        
    }
    
    NSLog(@"文件路径为：%@",filePath);
    
    NSString *fileName = [[filePath componentsSeparatedByString:@"/"] lastObject];
    
    //获取表名
    NSString *tableName = [[fileName componentsSeparatedByString:@"."] firstObject];
    
    //    NSString *query =[NSString stringWithFormat:@"SELECT rowid, * FROM \"%@\"  ORDER BY \"rowid\" ASC",file];//按时间大小倒序排列
    
    NSString *query =[NSString stringWithFormat:@"SELECT  * FROM \"%@\"     where \"time\" > \"0\" ORDER BY \"time\" ASC",tableName ];//按时间大小升序
    
    sqlite3_stmt *statement;
    
    if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil)==SQLITE_OK) {
        
        while (sqlite3_step(statement) == SQLITE_ROW) {
            
            FenBi7005Data_Obj *obj_GraphDB = [[FenBi7005Data_Obj alloc]init];
            
            //int rowNum = sqlite3_column_int(statement, 0);//获取行号存储在int变量中
            
            char *rowData1 = (char *)sqlite3_column_text(statement, 0);
            NSString *fieldValue1 = [[NSString alloc] initWithUTF8String:rowData1];
            obj_GraphDB.nTime = [fieldValue1 intValue];
            
            char *rowData2 = (char *)sqlite3_column_text(statement, 1);
            NSString *fieldValue2 = [[NSString alloc] initWithUTF8String:rowData2];
            obj_GraphDB.strTime = fieldValue2;
            
            char *rowData3 = (char *)sqlite3_column_text(statement, 2);
            NSString *fieldValue3 = [[NSString alloc] initWithUTF8String:rowData3];
            obj_GraphDB.strOpenPrice = fieldValue3;
            
            char *rowData4 = (char *)sqlite3_column_text(statement, 3);
            NSString *fieldValue4 = [[NSString alloc] initWithUTF8String:rowData4];
            obj_GraphDB.strClosePrice = fieldValue4;
            
            char *rowData5 = (char *)sqlite3_column_text(statement, 4);
            NSString *fieldValue5 = [[NSString alloc] initWithUTF8String:rowData5];
            obj_GraphDB.strHighestPrice = fieldValue5;
            
            char *rowData6 = (char *)sqlite3_column_text(statement, 5);
            NSString *fieldValue6 = [[NSString alloc] initWithUTF8String:rowData6];
            obj_GraphDB.strLowestPrice = fieldValue6;
            
            char *rowData7 = (char *)sqlite3_column_text(statement, 6);
            NSString *fieldValue7 = [[NSString alloc] initWithUTF8String:rowData7];
            obj_GraphDB.strVolume = fieldValue7;
            
            char *rowData8 = (char *)sqlite3_column_text(statement, 7);
            NSString *fieldValue8 = [[NSString alloc] initWithUTF8String:rowData8];
            obj_GraphDB.strAmount = fieldValue8;
            
            
            [arrayData addObject:obj_GraphDB];
            
        }
        sqlite3_finalize(statement);
        
    }
    sqlite3_close(database);
    
    return arrayData;
}

- (NSString *)queryMaxTime:(NSString *)filePath
{
    
    
    NSString *maxTime = nil;
    
    sqlite3 *database;
    
    if (sqlite3_open([filePath UTF8String], &database) !=SQLITE_OK ) {
        
        sqlite3_close(database);
        
        NSLog(@"打开数据库失败");
        
        return nil;
        
    }
    
    NSLog(@"文件路径为：%@",filePath);
    
    NSString *fileName = [[filePath componentsSeparatedByString:@"/"] lastObject];
    
    //获取表名
    NSString *tableName = [[fileName componentsSeparatedByString:@"."] firstObject];
    
    //    NSString *query =[NSString stringWithFormat:@"SELECT rowid, * FROM \"%@\"  ORDER BY \"rowid\" ASC",file];//按时间大小倒序排列
    
    NSString *query =[NSString stringWithFormat:@"SELECT  * FROM \"%@\"   ORDER BY \"time\" DESC LIMIT 1",tableName ];//按时间大小升序
    
    sqlite3_stmt *statement;
    
    if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil)==SQLITE_OK) {
        
        while (sqlite3_step(statement) == SQLITE_ROW) {
            
            char *rowData2 = (char *)sqlite3_column_text(statement, 1);
            NSString *fieldValue2 = [[NSString alloc] initWithUTF8String:rowData2];
            maxTime = fieldValue2;
            
            
        }
        sqlite3_finalize(statement);
        
    }
    sqlite3_close(database);
    
    return maxTime;
}

- (NSArray *)getArrayFromFilePath:(NSString *)filePath strType:(NSString *)strType andNMaxTime:(NSTimeInterval)NMaxTime;
{
    NSMutableArray *arrayData = [NSMutableArray array];
    
    sqlite3 *database;
    
    if (sqlite3_open([filePath UTF8String], &database) !=SQLITE_OK ) {
        
        sqlite3_close(database);
        
        NSLog(@"打开数据库失败");
        
        return nil;
        
    }
    
    NSLog(@"文件路径为：%@",filePath);
    
    NSString *fileName = [[filePath componentsSeparatedByString:@"/"] lastObject];
    
    //获取表名
    NSString *tableName = [[fileName componentsSeparatedByString:@"."] firstObject];
    
    //    NSString *query =[NSString stringWithFormat:@"SELECT rowid, * FROM \"%@\"  ORDER BY \"rowid\" ASC",file];//按时间大小倒序排列
    
    NSInteger limitCount = [self getLimitCountByType:strType];
    
    NSString *query =[NSString stringWithFormat:@"SELECT  * FROM \"%@\"     where \"time\" < \"%f\" ORDER BY \"time\" DESC LIMIT %ld",tableName ,NMaxTime,(long)limitCount];//按时间大小升序
    
    sqlite3_stmt *statement;
    
    if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil)==SQLITE_OK) {
        
        while (sqlite3_step(statement) == SQLITE_ROW) {
            
            FenBi7005Data_Obj *obj_GraphDB = [[FenBi7005Data_Obj alloc]init];
            
            //int rowNum = sqlite3_column_int(statement, 0);//获取行号存储在int变量中
            
            char *rowData1 = (char *)sqlite3_column_text(statement, 0);
            NSString *fieldValue1 = [[NSString alloc] initWithUTF8String:rowData1];
            obj_GraphDB.nTime = [fieldValue1 intValue];
            
            char *rowData2 = (char *)sqlite3_column_text(statement, 1);
            NSString *fieldValue2 = [[NSString alloc] initWithUTF8String:rowData2];
            obj_GraphDB.strTime = fieldValue2;
            
            char *rowData3 = (char *)sqlite3_column_text(statement, 2);
            NSString *fieldValue3 = [[NSString alloc] initWithUTF8String:rowData3];
            obj_GraphDB.strOpenPrice = fieldValue3;
            
            char *rowData4 = (char *)sqlite3_column_text(statement, 3);
            NSString *fieldValue4 = [[NSString alloc] initWithUTF8String:rowData4];
            obj_GraphDB.strClosePrice = fieldValue4;
            
            char *rowData5 = (char *)sqlite3_column_text(statement, 4);
            NSString *fieldValue5 = [[NSString alloc] initWithUTF8String:rowData5];
            obj_GraphDB.strHighestPrice = fieldValue5;
            
            char *rowData6 = (char *)sqlite3_column_text(statement, 5);
            NSString *fieldValue6 = [[NSString alloc] initWithUTF8String:rowData6];
            obj_GraphDB.strLowestPrice = fieldValue6;
            
            char *rowData7 = (char *)sqlite3_column_text(statement, 6);
            NSString *fieldValue7 = [[NSString alloc] initWithUTF8String:rowData7];
            obj_GraphDB.strVolume = fieldValue7;
            
            char *rowData8 = (char *)sqlite3_column_text(statement, 7);
            NSString *fieldValue8 = [[NSString alloc] initWithUTF8String:rowData8];
            obj_GraphDB.strAmount = fieldValue8;
            
            
            [arrayData addObject:obj_GraphDB];
            
        }
        sqlite3_finalize(statement);
        
    }
    sqlite3_close(database);
    
    NSArray *reverseArrayData = [[arrayData reverseObjectEnumerator] allObjects];
    
    return reverseArrayData;
}

- (NSInteger)getLimitCountByType:(NSString *)strType
{
    NSInteger limitCount = 0;
    
    if ([strType isEqualToString:@"M1"]) {
        limitCount = MinGraphDataCount;
    } else if ([strType isEqualToString:@"M5"]) {
        limitCount = MinGraphDataCount;
    } else if ([strType isEqualToString:@"M15"]) {
        limitCount = 3*MinGraphDataCount;
    } else if ([strType isEqualToString:@"M30"]) {
        limitCount = 6*MinGraphDataCount;
    } else if ([strType isEqualToString:@"H1"]) {
        limitCount = 12*MinGraphDataCount;
    } else if ([strType isEqualToString:@"H4"]) {
        limitCount = 48*MinGraphDataCount;
    } else if ([strType isEqualToString:@"D1"]) {
        limitCount = MinGraphDataCount;
    } else if ([strType isEqualToString:@"W1"]) {
        limitCount = 7*MinGraphDataCount;
    } else if ([strType isEqualToString:@"MN"]) {
        limitCount = 30*MinGraphDataCount;
    }
    return limitCount;
}


@end
