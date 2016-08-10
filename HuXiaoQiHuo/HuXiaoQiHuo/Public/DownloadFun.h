//
//  Download.h
//  traderex
//
//  Created by XXJ on 15/5/14.
//  Copyright (c) 2015年 EasyFly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DownloadFun : NSObject<NSURLConnectionDataDelegate>
{
    NSString *savePath;
    NSMutableData *connectionData;
    NSNotificationCenter *_defaulNotificationCenter;
    int nType;
}

@property (nonatomic, strong) NSString *strDGTime;  //下载的DG文件中所对应的时间
@property (nonatomic, readonly)NSNotificationCenter* defaulNotificationCenter;
@property (nonatomic,strong) NSURLConnection *connection;  //控制取消下载

- (instancetype)initWithUrlString:(NSString *)urlString andSavePath:(NSString *)storePath;

+ (instancetype)downloadWithUrlString:(NSString *)urlString andSavePath:(NSString *)storePath;

- (void)setType:(int)type;

@end
