//
//  FileInfo_Obj.h
//  traderex
//
//  Created by XXJ on 15/5/14.
//  Copyright (c) 2015年 EasyFly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBFileInfo_Obj : NSObject

@property (nonatomic, strong) NSString *dbFilePath;

@property (nonatomic, assign) int nType;

- (instancetype)initWithDBFilePath:(NSString *)filePath andType:(int)type;

+ (instancetype)fileInfoObjWithDBFilePath:(NSString *)filePath andType:(int)type;

@end
