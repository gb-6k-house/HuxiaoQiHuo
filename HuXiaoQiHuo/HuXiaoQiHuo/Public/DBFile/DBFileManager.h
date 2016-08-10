//
//  DBFileManager.h
//  traderex
//
//  Created by EasyFly on 15/5/13.
//  Copyright (c) 2015年 EasyFly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GraphResponse.h"
#import "DownloadFun.h"
#import "MerpList_Obj.h"

#define DBFileType_DG     1001
#define DBFileType_M1G    1002
#define DBFileType_M5G    1003

#define DBFile_Invalid    0
#define DBFile_Expired  1
#define DBFile_Valid    2

@interface DBFileManager : NSObject
{
    NSMutableArray * arrayDefarg;
    NSMutableArray * arrayNewData;
    NSNotificationCenter *nc;
    GraphServerObj* _graphSever;
}

@property BOOL bDataStatus;

@property (nonatomic, strong) GraphResponse * objCurGraphResponse; //当前已绘制的k线图数据

@property (nonatomic ,strong) NSArray *arrayDGData;
@property (nonatomic ,strong) NSMutableArray *arrayFileData;

@property (nonatomic, strong) DownloadFun *download; //可以控制下载
@property(nonatomic, readonly)MerpList_Obj* merpObj;
@property(nonatomic, readonly)GraphServerObj* graphSever;

//
@property NSInteger nArrayIndex;//记录下数组的某一位置
@property int nType;
@property (nonatomic, strong) NSString *strDGTime;  //下载的DG文件中所对应的时间
@property (nonatomic, retain) NSString * strFenBi7005DataTime;
@property (nonatomic, retain) NSString * strType;
@property (nonatomic, assign) BOOL bRequest7005DG;  //是不是请求7005天图数据
@property (nonatomic, copy) NSString * strMarketID;
@property (nonatomic, copy) NSString * strProductCode;
@property NSTimeInterval nTime;//7005数据中的最小时间值
-(instancetype)initWithMarketId:(NSString*)marketId andMpCode:(NSString*)mpCode;
//获取K线图
-(void)getKLineDataByGraphType:(NSString *)strGraphType;
//获取分时图
-(void)getTimeLineData;

@end
