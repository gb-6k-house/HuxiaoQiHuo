//
//  Download.m
//  traderex
//
//  Created by XXJ on 15/5/14.
//  Copyright (c) 2015年 EasyFly. All rights reserved.
//

#import "DownloadFun.h"
#import "DBFileInfo_Obj.h"
#import "SqliteManager.h"
#import "DBFileManager.h"

@implementation DownloadFun

#pragma mark-UIConnectionDataDelegate
-(NSNotificationCenter*)defaulNotificationCenter{
    if (!_defaulNotificationCenter) {
        _defaulNotificationCenter = [[NSNotificationCenter alloc] init];
    }
    return _defaulNotificationCenter;
}
- (instancetype)initWithUrlString:(NSString *)urlString andSavePath:(NSString *)storePath
{
    if (self = [super init]) {
        
        savePath = storePath;
        
        nType = 1001; // 设置默认值;
        
        NSURL    *url = [NSURL URLWithString:urlString];
        //建立连接
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:100];
        
        self.connection=[[NSURLConnection alloc]initWithRequest:request delegate:self];
        
        [self.connection start];
        
        [self makeDir:savePath];
        
        
        //初始化connectionData;
    }
    return self;
}

+ (instancetype)downloadWithUrlString:(NSString *)urlString andSavePath:(NSString *)storePath
{
    NSLog(@"下载DB文件:%@", urlString);
    return [[DownloadFun alloc] initWithUrlString:urlString andSavePath:storePath];
}

- (void)setType:(int)type
{
    nType = type;
}
//创建文件存储路径
-(BOOL)makeDir:(NSString *)name
{
    NSMutableString *mString = [NSMutableString stringWithString:name];
    
    NSString *string = [[name componentsSeparatedByString:@"/"] lastObject];
    
    [mString deleteCharactersInRange:NSMakeRange(mString.length-string.length-1, string.length+1)];
    
    NSFileManager *fileManger = [NSFileManager defaultManager];
    
    if (![fileManger fileExistsAtPath:mString]) {
        
        BOOL bo = [[NSFileManager defaultManager] createDirectoryAtPath:mString withIntermediateDirectories:YES attributes:nil error:nil];
        
        return bo;
    }
    else
    {
        return 0;
    }
}

#pragma mark-UIConnectionDataDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    connectionData = [[NSMutableData alloc]init];
}

//接受数据
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    //获取服务器传递的数据
    [connectionData appendData:data];
}

//接收数据成功
-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
    //存储文件
    [connectionData writeToFile:savePath atomically:YES];
    
    NSLog(@"DB文件下载并保存文件成功 %@",savePath);
    
    
    [self.defaulNotificationCenter postNotificationName:@"Notification_DownloadFun_AsynFileDownloadSuccess"
                      object:[self class]
                    userInfo:nil];
    
}

//下载出错的委托方法
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"DB文件下载失败%@",error.description);
    
    [self.defaulNotificationCenter postNotificationName:@"Notification_DownloadFun_AsynFileDownloadError"
                      object:[self class]
                    userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%d",nType],@"Notification_DownloadFun_AsynFileDownloadError",nil]];
    
}


@end
