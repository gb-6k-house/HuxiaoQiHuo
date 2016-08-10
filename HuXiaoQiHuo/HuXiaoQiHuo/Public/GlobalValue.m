//
//  GlobalValue.m
//  HuXiaoQiHuo
//
//  Created by niupark on 16/5/21.
//  Copyright © 2016年 fukeng. All rights reserved.
//

#import "GlobalValue.h"

@implementation GlobalValue
+ (instancetype)sharedInstance
{
    static GlobalValue *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc ] init];
    });
    return _sharedInstance;
}

-(BOOL) saveZXFileWithDic: (NSArray *) dicData
{
    NSString * strCurUserName = self.uname;
    
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:dicData forKey:strCurUserName];
    [archiver finishEncoding];
    
    NSString *Path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *filename = [Path stringByAppendingPathComponent:const_strZXFileName];
    
    if ([data writeToFile:filename atomically:NO])
    {
        
        return YES;
    }
    
    return NO;
}
-(BOOL)ifZXWithMpId:(NSString*)mpId{
    NSMutableArray * zxList = [self loadZXFile];
    for (NSString *zxId in zxList) {
        if ([zxId isEqualToString:mpId]) {
            return YES;
        }
    }
    return NO;
}
-(void)addZxWithMpId:(NSString*)mpId{
    NSMutableArray * zxList = [self loadZXFile];
    for (NSString *zxId in zxList) {
        if ([zxId isEqualToString:mpId]) {
            return;
        }
    }
    [zxList addObject:mpId];
    [self saveZXFileWithDic:zxList];
}
-(void)removeZxWithMpId:(NSString*)mpId{
    NSLog(@"here");
    NSMutableArray * zxList = [self loadZXFile];
    for (NSString *zxId in zxList) {
        if ([zxId isEqualToString:mpId]) {
            [zxList removeObject:zxId];
            break;
        }
    }
    [self saveZXFileWithDic:zxList];
}
- (NSMutableArray*) loadZXFile
{
    NSString * strCurUserName = self.uname;
    
    NSString *Path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *filename = [Path stringByAppendingPathComponent:const_strZXFileName];
    
    ///
    NSData *data = [[NSMutableData alloc] initWithContentsOfFile:filename];
    
    if (data!=nil) {
        
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        NSArray *arrTmp = [unarchiver decodeObjectForKey:strCurUserName];
        [unarchiver finishDecoding];
        
        if (arrTmp != nil)
        {
            return [[NSMutableArray alloc] initWithArray:arrTmp];
            
        }
        
    }
    return [[NSMutableArray alloc] init];
}
@end
