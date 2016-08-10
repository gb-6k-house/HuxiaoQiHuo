//
//  LoginParaObj.h
//  Trader
//
//  Created by easyfly on 4/1/14.
//  Copyright (c) 2014 easyfly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginParaObj : NSObject

@property(nonatomic,copy)NSString * MD5; //文件序列号

@property(nonatomic,copy)NSString * URL; //文件下载地址 文件名位login.json

@property(nonatomic,strong)NSArray* graphServer;

@property(nonatomic,strong)NSArray* fy_socketServer;

@property(nonatomic,strong)NSArray* quoteServer; //行情服务 

@property(nonatomic,strong)NSArray* menusID;

@property(nonatomic,copy)NSString * GIP;

@property(nonatomic,copy)NSString * GPort;

@property(nonatomic,copy)NSString * PIP;

@property(nonatomic,copy)NSString * PPort;

@property(nonatomic,strong)NSArray* marketlist; // 市场列表
@property(nonatomic,strong)NSDictionary* muserInfo; // 交易账户信息

@property(nonatomic,strong)NSArray* MCL;

@property(nonatomic,copy)NSString * DBURL;

@property int IntervalTime;

@property int GIntervalTime;

@property int  PIntervalTime;

@property(nonatomic,copy)NSString * analogaccount;

@property(nonatomic,copy)NSString * analogpwd;

@property(nonatomic,copy)NSString *RACEMD5; //比赛文件序列号

@end
