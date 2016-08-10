//
//  TTFileCache.h
//  WashCarMechanic
//
//  Created by niupark on 16/4/12.
//  Copyright © 2016年 niupark. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  @author LiuK, 16-05-06 09:05:01
 *
 *  文件本地缓存
 *
 *  @param data <#data description#>
 */
typedef void(^TTFileCacheQueryCompletedBlock)(NSData *data);


@interface TTFileCache : NSObject
+ (TTFileCache *)sharedInstance;
//缓存文件
- (void)storeFile:(NSData *)data forKey:(NSString *)key;
- (void)removeFileForKey:(NSString *)key;
- (void)queryDataForKey:(NSString*)key completion:(TTFileCacheQueryCompletedBlock)complete;
- (id)initWithNamespace:(NSString *)ns maxCount:(NSInteger)maxCount;
///**
// *  校验文件是否存在
// */
//- (BOOL)diskFileExistsWithKey:(NSString *)key;

/**
 * Get the size used by the disk cache
 */
- (NSUInteger)getSize;

/**
 * Get the number of files in the disk cache
 */
- (NSUInteger)getDiskCount;
//获取key文件存储的路径
-(NSString*)getFilePathForKey:(NSString*)key;
@end
