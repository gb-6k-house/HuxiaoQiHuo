//
//  TTFileCache.m
//  WashCarMechanic
//
//  Created by niupark on 16/4/12.
//  Copyright © 2016年 niupark. All rights reserved.
//

#import "TTFileCache.h"
#import <CommonCrypto/CommonDigest.h>

@interface TTFileCache()
@property (strong, nonatomic) NSString *diskCachePath;

@end

@implementation TTFileCache{
    NSFileManager *_fileManager;
    NSInteger _maxFileCount;
}
+ (TTFileCache *)sharedInstance {
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}
//缺省空间，缺省文件数10个
- (id)init {
    return [self initWithNamespace:@"default" maxCount:10];
}
//初始化 缓冲器
- (id)initWithNamespace:(NSString *)ns maxCount:(NSInteger)maxCount{
    if ((self = [super init])) {
        NSString *fullNamespace = [@"com.ttkuaiche.AudioCache." stringByAppendingString:ns];
        // Init the disk cache
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        _diskCachePath = [paths[0] stringByAppendingPathComponent:fullNamespace];
        _maxFileCount = maxCount;
        _fileManager = [NSFileManager new];
    }
    return self;
}
-(NSString*)getFilePathForKey:(NSString*)key{
    return [self defaultCachePathForKey:key];
}
- (void)storeFile:(NSData *)data forKey:(NSString *)key{
    if (!data || !key) {
        return;
    }
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSError* error = nil;
        if (data) {
            if (![_fileManager fileExistsAtPath:_diskCachePath]) {
                [_fileManager createDirectoryAtPath:_diskCachePath withIntermediateDirectories:YES attributes:nil error:NULL];
            }
            
            [_fileManager createFileAtPath:[self defaultCachePathForKey:key] contents:data attributes:nil];
        }
        //如果当前文件数，大于最大，则删除最早的文件
        if ([self getDiskCount] > _maxFileCount) {
            //
            [_fileManager removeItemAtPath:[self.diskCachePath stringByAppendingPathComponent:[self earlierFile]] error:&error];
        }
        
//    });
}

//文件名MD5编码
- (NSString *)cachedFileNameForKey:(NSString *)key {
    const char *str = [key UTF8String];
    if (str == NULL) {
        str = "";
    }
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), r);
    NSString *filename = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                          r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]];
    
    return filename;
}

- (NSString *)defaultCachePathForKey:(NSString *)key {
    return [_diskCachePath stringByAppendingPathComponent:[self cachedFileNameForKey:key]];
}

- (void)removeFileForKey:(NSString *)key{
    if (key == nil) {
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [_fileManager removeItemAtPath:[self defaultCachePathForKey:key] error:nil];
        
    });
    
    
}


- (void)queryDataForKey:(NSString*)key completion:(TTFileCacheQueryCompletedBlock)complete{
    if (key == nil) {
        return ;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @autoreleasepool {
            NSData  *data = [NSData dataWithContentsOfFile:[self defaultCachePathForKey:key]];
            dispatch_async(dispatch_get_main_queue(), ^{
                complete(data);
            });
        }
    });

}


- (BOOL)diskImageExistsWithKey:(NSString *)key {
    BOOL exists = NO;
    
    exists = [[NSFileManager defaultManager] fileExistsAtPath:[self defaultCachePathForKey:key]];
    
    return exists;
}

//删除所有缓存文件
- (void)clearDisk{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [_fileManager removeItemAtPath:self.diskCachePath error:nil];
        [_fileManager createDirectoryAtPath:self.diskCachePath
                withIntermediateDirectories:YES
                                 attributes:nil
                                      error:NULL];
        
    });
}



- (NSUInteger)getSize {
    __block NSUInteger size = 0;
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSDirectoryEnumerator *fileEnumerator = [_fileManager enumeratorAtPath:self.diskCachePath];
        for (NSString *fileName in fileEnumerator) {
            NSString *filePath = [self.diskCachePath stringByAppendingPathComponent:fileName];
            NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
            size += [attrs fileSize];
        }
    });
    return size;
}

- (NSUInteger)getDiskCount {
    __block NSUInteger count = 0;
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSDirectoryEnumerator *fileEnumerator = [_fileManager enumeratorAtPath:self.diskCachePath];
        count = [[fileEnumerator allObjects] count];
    });
    return count;
}


//获取最早的文件
-(NSString *)earlierFile{
    NSError* error = nil;
    NSDirectoryEnumerator *fileEnumerator = [_fileManager enumeratorAtPath:self.diskCachePath];
    NSString* path;
    NSDate *earlierDate = nil;
    NSString *earlierFile = nil;
    while ((path =[fileEnumerator nextObject]) !=nil) {
    
        NSDictionary* properties = [_fileManager
                                    attributesOfItemAtPath:[self.diskCachePath stringByAppendingPathComponent:path]
                                    error:&error];
        NSDate* modDate = [properties objectForKey:NSFileModificationDate];
        if (!modDate) {
            modDate = [properties objectForKey:NSFileCreationDate];
        }
        if (!earlierDate) {
            earlierDate = modDate;
            earlierFile = path;
        }else if ([earlierDate earlierDate:modDate] == modDate){
            earlierDate = modDate;
            earlierFile = path;
        }
        
    }
    return earlierFile;
}

@end