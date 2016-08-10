//
//  FileInfo_Obj.m
//  traderex
//
//  Created by XXJ on 15/5/14.
//  Copyright (c) 2015年 EasyFly. All rights reserved.
//

#import "DBFileInfo_Obj.h"

@implementation DBFileInfo_Obj

- (instancetype)initWithDBFilePath:(NSString *)filePath andType:(int)type
{
    if (self = [super init]) {
        self.dbFilePath = filePath;
        self.nType = type;
    }
    return self;
}

+ (instancetype)fileInfoObjWithDBFilePath:(NSString *)filePath andType:(int)type
{
    return [[DBFileInfo_Obj alloc] initWithDBFilePath:filePath andType:type];
}

@end
