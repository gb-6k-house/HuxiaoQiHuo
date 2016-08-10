//
//  DBFileManager.m
//  traderex
//
//  Created by EasyFly on 15/5/13.
//  Copyright (c) 2015年 EasyFly. All rights reserved.
//

#import "DBFileManager.h"
#import "SqliteManager.h"
#import "FenBi7005Data_Obj.h"
#import "FenBiRequest.h"
#import "Constants.h"
#import "AppDelegate.h"
#import "DBFileInfo_Obj.h"
#import "MerpList_Obj.h"
#import "CGraphClientSocket.h"
#import "CTradeClientSocket.h"
#import "OpenCloseTime_Obj.h"
#import "NetWorkManager.h"
#import "CSocketListenerManager.h"
#import "GraphResponse.h"
#import "GraphDBManager.h"


@interface DBFileManager(){
    GraphDBManager *_dbMnger;
    CGraphClientSocket *_gpSocket;
    CGraphClientSocket *_gpTimeSocket;

}
@property (nonatomic, readonly) CGraphClientSocket *gpSocket;
@property (nonatomic, readonly) CGraphClientSocket *gpTimeSocket;

@property (nonatomic, readonly) GraphDBManager *dbMnger;
//下载DB文件,如果DBFileType_MG类型则需要AndDay参数
- (void) downloadDBFileFrom:(NSString *) strURL AndDBFileType:(int)nDBFileType AndMarketID:(NSString *)strMarketID AndProductCode:(NSString *)strProductCode AndDay:(NSString *)strDay;

//下载文件,
- (void) downloadDBFileFrom:(NSString *) strURL AndDBFileType:(int)nDBFileType AndMarketID:(NSString *)strMarketID AndProductCode:(NSString *)strProductCode;

//判断DB文件是否存在, 如果DBFileType_MG类型则需要AndDay参数
- (BOOL) isDBFileExistByMarketID:(NSString *)strMarketID AndProductCode:(NSString *)strProductCode AndDBFileType:(int)nDBFileType AndDay:(NSString *)strDay;

//判断文件是否存在
- (BOOL) isFileExistByMarketID:(NSString *)strMarketID ProductCode:(NSString *)strProductCode AndDBFileType:(int)nDBFileType;

//判断DG文件是否过期
//- (int) isDGFileExpiredByMarketID:(NSString *)strMarketID AndProductCode:(NSString *)strProductCode AndTime:(NSTimeInterval) nTimeDay;

//判断文件是否过期
- (int) isFileExpiredByFileType:(int)nFileType MarketID:(NSString *)strMarketID ProductCode:(NSString *)strProductCode;


//解析DG文件
- (NSArray *) parseDGFileByMarketID:(NSString *)strMarketID AndProductCode:(NSString *)strProductCode AndTime:(NSTimeInterval) nTimeDay;

//解析MG文件
- (NSArray *) parseMGFileByMarketID:(NSString *)strMarketID AndProductCode:(NSString *)strProductCode AndTime:(NSTimeInterval) nTimeMinute;

//整理类型数据(type M1 M5 M15 ...) 返回一个数组包含M1 M5 M1 M15 ..的对象
- (NSMutableArray *)getDefargGraphDataWithArrayData:(NSArray *)arrayDate Type:(NSString *)type;


-(void) requestFenBi7005:(int) nGraphType BeginTime:(NSString *) strBeginTime EndTime:(NSString *) strEndTime AndMarketID:(NSString *)strMarketID productCode:(NSString *)strProductCode AndGraphType:(NSString *)strGraphType;

- (void) getDefargGraphDataFromTime:(NSInteger)time AndStrTime:(NSString *)strTime AndMarket:(NSString *)strMarketID AndProductCode:(NSString *)strProductCode AndType:(NSString *)type;

- (void) getDefargGraphDataFromTime:(NSInteger)time AndMarket:(NSString *)strMarketID AndProductCode:(NSString *)strProductCode AndType:(NSString *)type;
@end

@implementation DBFileManager

-(instancetype)initWithMarketId:(NSString*)marketId andMpCode:(NSString*)mpCode{
    if (self = [super init]) {
        _bDataStatus = YES;
        [self initDBFileManager];
        self.strMarketID = marketId;
        self.strProductCode = mpCode;
    }
    return self;

}

-(GraphDBManager*)dbMnger{
    if (!_dbMnger) {
        _dbMnger = [[GraphDBManager alloc] initWithMarketId:self.strMarketID andMpCode:self.strProductCode];
    }
    return _dbMnger;
}
-(CGraphClientSocket*)gpSocket{
    if (!_gpSocket) {
        _gpSocket = [[CGraphClientSocket alloc] init];
        GraphServerObj * sv = [[CTradeClientSocket sharedInstance] graphServerByMpIndex:@(self.merpObj.nIndex)];
        [self.gpSocket connectToHost:sv.GIP onPort:[sv.GPort intValue]];

    }
    return _gpSocket;
}
-(CGraphClientSocket*)gpTimeSocket{
    if (!_gpTimeSocket) {
        _gpTimeSocket = [[CGraphClientSocket alloc] init];
        GraphServerObj * sv = [[CTradeClientSocket sharedInstance] graphServerByMpIndex:@(self.merpObj.nIndex)];
        [_gpTimeSocket connectToHost:sv.GIP onPort:[sv.GPort intValue]];
        
    }
    return _gpTimeSocket;
}
- (void) initDBFileManager
{
    _nArrayIndex = 0;
    _arrayDGData = [NSArray array];
    _objCurGraphResponse = [[GraphResponse alloc]init];
    [[CSocketListenerManager sharedInstance] registerListener:self];

    
}

- (void) dealloc{
    [[CSocketListenerManager sharedInstance] unregisterListener:self];
    [self.download.defaulNotificationCenter removeObserver:self];
    
}

- (void) getDefargGraphDataFromTime:(NSInteger)time AndMarket:(NSString *)strMarketID AndProductCode:(NSString *)strProductCode AndType:(NSString *)type
{
    //发送一个加载通知
    
    int nType = [[NetWorkManager sharedInstance] getTimeTypeFromStr:type];
    
    int nFileType = 0;
    
    if (nType==1) {
        nFileType = DBFileType_M1G;
    } else if (nType >1 && nType < 7) {
        nFileType = DBFileType_M5G;
    } else if(nType >= 7) {
        nFileType = DBFileType_DG;
    }
    
    NSString *storePath = [self fileStorePathByFileType:nFileType MarketID:strMarketID ProductCode:strProductCode];
    
    SqliteManager *sqliteManger = [[SqliteManager alloc] init];
    
    NSArray *arrayFileData = [sqliteManger getArrayFromFilePath:storePath strType:type andNMaxTime:time];
    
    if (arrayFileData.count==0)
    {
        //[[NetWorkMana  ger sharedInstance] removeMBProgressView];
        
        //                ShowMessageTip(@"数据加载完成", [[UIApplication sharedApplication] keyWindow]);
        
        //[NetWorkManager sharedInstance].bGetOldGraphDataBegin = NO;
        
        return;
    }
    
    arrayFileData = [self getDefargGraphDataWithArrayData:arrayFileData Type:type];
    //把从文件取到的数据放入graphResponseData数组中
    [self handelFenBi7005Data_ObjList:arrayFileData];
    
}
//处理单笔数据
- (void) handelFenBi7005Data_ObjList:(NSArray *)arrayDataBase{
        //数组取反
        arrayDataBase = [[arrayDataBase reverseObjectEnumerator] allObjects];
        
        for (FenBi7005Data_Obj *obj_FenBi7005Data in arrayDataBase)
        {
            if (self.objCurGraphResponse.arrayGraphDate_Obj.count>0) {
                
                FenBi7005Data_Obj *obj_Last_FenBi7005Data = [self.objCurGraphResponse.arrayGraphDate_Obj firstObject];
                
                if (obj_FenBi7005Data.nTime == obj_Last_FenBi7005Data.nTime) {
                    
                    continue;
                }
                
                [self.objCurGraphResponse.arrayGraphDate_Obj insertObject:obj_FenBi7005Data atIndex:0];
            }
            else
            {
                [self.objCurGraphResponse.arrayGraphDate_Obj insertObject:obj_FenBi7005Data atIndex:0];
            }
            
        }
        self.objCurGraphResponse.nCount = (int)[self.objCurGraphResponse.arrayGraphDate_Obj count];
       //有新的数据，发送绘图通
      [self callBackGraphData:_objCurGraphResponse];

}

//通过time,amount,type,mapID获取时间图的数组
- (void) getDefargGraphDataFromTime:(NSInteger)time AndStrTime:(NSString *)strTime AndMarket:(NSString *)strMarketID AndProductCode:(NSString *)strProductCode AndType:(NSString *)type
{
    
    //初始化数组
    _arrayFileData = [NSMutableArray array];
    
    
    //把时间转换成 yyyy-MM-dd 格式
     NSString *strDay = [[NetWorkManager sharedInstance] convertDateFormatter:const_Trader_strTimeFormatter_YMDHMS targetFormatter:const_strTimeFormatter_Y_M_D dateString:strTime];
    
    
    //把值赋为全局变量
    _nTime = time;

    _strFenBi7005DataTime = strDay;
    
    _strMarketID = strMarketID;
    
    _strProductCode = strProductCode;
    
    _strType = type;
    
    //把图形种类转换成 int 型
    _nType = [[NetWorkManager sharedInstance] getTimeTypeFromStr:_strType];
    
    [self downDBFileBytype:_nType];
}

#pragma mark - 处理滚动的数据
//根据type 处理图形文件
- (void) downDBFileBytype:(int) nType
{
    switch (nType) {
        case 1:
        case 2:
        case 3:
        case 4:
        case 5:
        case 6:
            
            [self getGraphDataWithMarket:_strMarketID AndProductCode:_strProductCode AndType:_strType];
            
            break;
            
        case 7:
        case 8:
        case 9:
            
            [self getGraphDataWithDay:_strMarketID AndProductCode:_strProductCode AndType:_strType];
            
            break;
            
        default:
            break;
    }
}

//获取分钟数据
- (void) getGraphDataWithMarket:(NSString *)strMarketID AndProductCode:(NSString *)strProductCode AndType:(NSString *)type{
    //通过数据库查找
    NSString *strTime = [[NetWorkManager sharedInstance]getStrFromSec:_nTime];

    NSString *currentTime = [[NetWorkManager sharedInstance] getYMDHMSCurrentAccurateTimer];

    NSString *todayMinTime = [currentTime stringByReplacingCharactersInRange:NSMakeRange(strTime.length-[@"00:00:00" length], [@"00:00:00" length]) withString:@"00:00:00"];

    //如果strTime 大于今天零点的时间，需要赋值今天最小时间，因为今天没有MG文件
    if (!([strTime compare:todayMinTime] == NSOrderedAscending)) {
        
        strTime = todayMinTime;
        
    }

    _arrayDGData = [self.dbMnger queryDGData_ByMaxTime:strTime AndType:@"D1"];

    _arrayDGData = [[NetWorkManager sharedInstance] FromGraphDataConversionFenBi7005Data_Obj:_arrayDGData AndType:@"D1"];

    //反向获取_objCurGraphResponse中数组的对象
    _arrayDGData = [[_arrayDGData reverseObjectEnumerator] allObjects];

    _nArrayIndex = 0;

    if (_arrayDGData == 0) {
        
        return;
    }


    //判断MG文件是否存在
    BOOL bExistMGFile = [self.dbMnger queryStatus_ByTime:_strFenBi7005DataTime];

    if (!bExistMGFile) {
        
        //下载文件
        [self downloadFile];
        
    }
    else
    {
        //当MG文件已存在（本身存在DG数组中），数组的标志位往后移一位
         _nArrayIndex+=1;
        
        NSArray *arrayMGFileData = [NSArray array];

        
        NSString *strTime = [[NetWorkManager sharedInstance] getStrFromSec:_nTime];
        
        arrayMGFileData = [self.dbMnger queryData_ByBeginTime:strTime EndTime:[_strFenBi7005DataTime stringByAppendingString:@" 00:00:00"] AndType:type];
        
        arrayMGFileData = [[NetWorkManager sharedInstance] FromGraphDataConversionFenBi7005Data_Obj:arrayMGFileData AndType:type];
            
        //根据type处理数据后得到的数组，如果为空，下载该文件之前的文件（以时间为标准）
        if (arrayMGFileData.count ==0)
        {
            
            //判断是否是数组中最后一个对象
            if (_nArrayIndex==_arrayDGData.count-1) {
                
                //发送画图通知
                [self handelFenBi7005Data_ObjList:_arrayFileData];

                return;
                
            }
            else{
                [self downloadFile];
            }
        }
        else
        {
            //把从文件取到的数据放入graphResponseData数组中
            _arrayFileData = [self insertObjFrom:arrayMGFileData ToArray:_arrayFileData];
            if (_arrayFileData.count == MinGraphDataCount){
                
                //发送画图通知
                [self handelFenBi7005Data_ObjList:_arrayFileData];
                
                return;
            }
            else{
                
                [self downloadFile];
            }
        }
    }
    
}


//根据_nArrayIndex下载MG文件
- (void) downloadFile{
    
    if (_nArrayIndex<_arrayDGData.count)
    {
        
        FenBi7005Data_Obj *obj_FenBi7005Data = _arrayDGData[_nArrayIndex];
        
        //根据这个时间更新DG下载状态位
        NSString *time = obj_FenBi7005Data.strTime;
        
        self.strDGTime = time;
        
        _nArrayIndex ++;
        
        //获取该字符串的日期字段
        NSString *strFirstTime = [[obj_FenBi7005Data.strTime componentsSeparatedByString:@" "] firstObject];
        //构造当天最大时间
        NSString *strMaxtime = [NSString stringWithFormat:@"%@ %@",strFirstTime,@"23:59:59"];
        
        NSString *strDay = [[NetWorkManager sharedInstance] convertDateFormatter:const_Trader_strTimeFormatter_YMDHMS targetFormatter:const_strTimeFormatter_Y_M_D dateString:strMaxtime];
        
//        //把当天最大时间转换成NSTimeInterval
//        NSTimeInterval nTime = [[NetWorkManager sharedInstance]getTimeIntervalFromStr:strMaxtime];

        if (![strDay isEqualToString:_strFenBi7005DataTime]) {
            
            //time重新赋值
//            _nTime = nTime;
            _strFenBi7005DataTime = strDay;
        }
        
        
        //判断MG文件是否存在
        BOOL bExistMGFile = [self.dbMnger queryStatus_ByTime:_strFenBi7005DataTime];
        
        if (!bExistMGFile)
        {
            return;
        }
        else
        {
            [self DownloadSuccessGraphDataFun_MOVING_Data];
            
            return;
        }
        
    }
    else
    {
        [self handelFenBi7005Data_ObjList:_arrayDGData];
        return;
        
    }
    
}

//获取以以天为单位的数据
- (void) getGraphDataWithDay:(NSString *)strMarketID AndProductCode:(NSString *)strProductCode AndType:(NSString *)type
{
    
    NSArray *arrayDGFileData = [NSArray array];

    //查询天图数据库
    NSString *strTime = [[NetWorkManager sharedInstance] getStrFromSec:_nTime];

    arrayDGFileData = [self.dbMnger queryDGData_ByMaxTime:strTime AndType:@"D1"];

    arrayDGFileData = [[NetWorkManager sharedInstance] FromGraphDataConversionFenBi7005Data_Obj:arrayDGFileData AndType:@"D1"];

    //处理数据
    if (arrayDGFileData.count==0)
    {
//        [[NetWorkManager sharedInstance] removeMBProgressView];
//        
////                ShowMessageTip(@"数据加载完成", [[UIApplication sharedApplication] keyWindow]);
//        
//        [NetWorkManager sharedInstance].bGetOldGraphDataBegin = NO;
        
        return;
    }
    
    arrayDGFileData = [self getDefargGraphDataWithArrayData:arrayDGFileData Type:type];
    //把从文件取到的数据放入graphResponseData数组中
    
    if (arrayDGFileData.count==0) {
//        
//        [[NetWorkManager sharedInstance] removeMBProgressView];
//        
////                ShowMessageTip(@"数据加载完成", [[UIApplication sharedApplication] keyWindow]);
//        
//        [NetWorkManager sharedInstance].bGetOldGraphDataBegin = NO;
        
        return;
    }
    
    _arrayFileData = [self insertObjFrom:arrayDGFileData ToArray:_arrayFileData];
    
    if (_arrayDGData.count<= MinGraphDataCount) {
       
        //发送画图通知
        [self handelFenBi7005Data_ObjList:_arrayDGData];
        
    }
    
}



#pragma mark - 处理7005返回的数据

#pragma mark - 处理数据
//根据type 获取图形文件
- (void) down7005DataFileBytype:(int) nType
{
    switch (nType) {
        case 1:
        case 2:
        case 3:
        case 4:
        case 5:
        case 6:
            
            [self get7005DataWithMarket:_strMarketID AndProductCode:_strProductCode AndType:_strType];
            
            break;
    
        case 7:
        case 8:
        case 9:
            
            [self get7005DataWithDay:_strMarketID AndProductCode:_strProductCode AndType:_strType];
            
            break;
            
        default:
            break;
    }
}

//获取分钟数据
- (void) get7005DataWithMarket:(NSString *)strMarketID AndProductCode:(NSString *)strProductCode AndType:(NSString *)type
{
    
    NSArray *arrayMGFileData = [NSArray array];

    //查询MG数据
    
    NSString *strTime = [self getCurrentAccurateTimer];
    
    //查询数据库方式
    arrayMGFileData = [self.dbMnger queryDGData_ByMaxTime:strTime AndType:type];
    
    arrayMGFileData = [[NetWorkManager sharedInstance] FromGraphDataConversionFenBi7005Data_Obj:arrayMGFileData AndType:type];
    
    if (arrayMGFileData.count == 0) {
        
        [self callBackGraphData:_objCurGraphResponse];
        
        return;
    }
    
    //把从文件取到的数据放入graphResponseData数组中
    _objCurGraphResponse.arrayGraphDate_Obj = [self insertObjFrom:arrayMGFileData ToArray:_objCurGraphResponse.arrayGraphDate_Obj];
    
    //发送画图通知
    [self callBackGraphData:_objCurGraphResponse];

    
}


//根据_nArrayIndex下载MG文件
- (void) down7005DataloadFile{
    
    if (_nArrayIndex<_arrayDGData.count)
    {
        
        FenBi7005Data_Obj *obj_FenBi7005Data = _arrayDGData[_nArrayIndex];
        
        //根据这个时间更新DG文件下载状态;
        NSString *time = obj_FenBi7005Data.strTime;
        
        self.strDGTime = time;

        
        _nArrayIndex ++;
        
        //获取该字符串的日期字段
        NSString *strFirstTime = [[obj_FenBi7005Data.strTime componentsSeparatedByString:@" "] firstObject];
        //构造当天最大时间
        NSString *strMaxtime = [NSString stringWithFormat:@"%@ %@",strFirstTime,@"23:59:59"];

        NSString *strDay = [[NetWorkManager sharedInstance] convertDateFormatter:const_Trader_strTimeFormatter_YMDHMS targetFormatter:const_strTimeFormatter_Y_M_D dateString:strMaxtime];
        
//        //把当天最大时间转换成NSTimeInterval
//         NSTimeInterval nTime = [[NetWorkManager sharedInstance]getTimeIntervalFromStr:strMaxtime];
        
        //如果当前文件的日期与画图界面最后一个数据的日期不是同一天时，标志时间_nTime重新赋值
        if (![strDay isEqualToString:_strFenBi7005DataTime]) {
            
            //time重新赋值
//            _nTime = nTime;
            _strFenBi7005DataTime = strDay;
        }
        
        
        //判断MG文件是否存在
        BOOL bExistMGFile = [self.dbMnger queryStatus_ByTime:_strFenBi7005DataTime];
        
        if (!bExistMGFile){
             return;
        }
        else{
            [self DownloadSuccess_GraphDataFun_Data:nil];
        }
        
    }
    else
    {
        [self callBackGraphData:_objCurGraphResponse];

        
        return;

    }

}
//数据下载完成，获取最新的数据
- (void)DownloadSuccess_GraphDataFun_Data:(NSNotification *)notify
{
    
    int nType = [[NetWorkManager sharedInstance] getTimeTypeFromStr:self.strType];
    
    if (nType < 7) {
        
        NSArray *arrayTime = [[NetWorkManager sharedInstance] getGraphaDataBeginTimeAndEndTime:0];
        
        [self requestFenBi7005:0 BeginTime:[arrayTime firstObject] EndTime:[arrayTime lastObject] AndMarketID:self.strMarketID productCode:self.strProductCode AndGraphType:self.strType];
        
    } else {
        
        //        NSString *strMaxTime = [[GraphDBManager Instance] queryMaxTimeByType:@"D1"];
        
        SqliteManager *sqliteManger = [[SqliteManager alloc] init];
        
        NSString *filePath = [self fileStorePathByFileType:DBFileType_DG MarketID:self.strMarketID ProductCode:self.strProductCode];
        
        NSString *startTime = [sqliteManger queryMaxTime:filePath];
        
        NSString *endTime = [[NetWorkManager sharedInstance] getYMDHMSCurrentAccurateTimer];
        
        [self requestFenBi7005:6 BeginTime:startTime EndTime:endTime AndMarketID:self.strMarketID productCode:self.strProductCode AndGraphType:self.strType];
        
    }
}


//获取以以天为单位的数据
- (void) get7005DataWithDay:(NSString *)strMarketID AndProductCode:(NSString *)strProductCode AndType:(NSString *)type{
    
    //当7005中返回的数组已存入数据库，取当前时间为标志读取数据库
    NSArray *arrayDGFileData = [NSArray array];

    NSString *strTime = [self getCurrentAccurateTimer];
   //查询数据库方式
    arrayDGFileData = [self.dbMnger queryDGData_ByMaxTime:strTime AndType:@"D1"];

    arrayDGFileData = [[NetWorkManager sharedInstance] FromGraphDataConversionFenBi7005Data_Obj:arrayDGFileData AndType:@"D1"];

    //处理数据
    if (arrayDGFileData.count==0) {
        
        //发送画图通知
       
        [self callBackGraphData:_objCurGraphResponse];

        return;
    }

    arrayDGFileData = [self getDefargGraphDataWithArrayData:arrayDGFileData Type:type];
    //把从文件取到的数据放入graphResponseData数组中
    
    if (arrayDGFileData.count == 0) {
        
        //发送画图通知
        [self callBackGraphData:_objCurGraphResponse];

        return;
    }
    
    _objCurGraphResponse.arrayGraphDate_Obj = [self insertObjFrom:arrayDGFileData ToArray:_objCurGraphResponse.arrayGraphDate_Obj];
    
    //发送画图通知
    [self callBackGraphData:_objCurGraphResponse];

}


//把从数据库中取到的数据放入7005对象的数组中
- (NSMutableArray *) insertObjFrom:(NSArray *)array ToArray:(NSMutableArray *) muArray
{
    array = [[array reverseObjectEnumerator] allObjects];
    
    for (FenBi7005Data_Obj *obj_FenBi7005Data in array) {
        //没有数量控制
        [muArray insertObject:obj_FenBi7005Data atIndex:0];
    }
    
    return muArray;
}

//获取当前时间
- (NSString *) getCurrentAccurateTimer
{
    NSDate *now = [NSDate date];
    
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    
    [dateFormater setDateFormat:const_Trader_strTimeFormatter_YMDHMS];
    
    NSString *strCurrentTime= [dateFormater stringFromDate:now];
    
    return strCurrentTime;
}



#pragma mark - 消息通知
//K线图数据返回 GraphResponse
SOCKET_PROTOCOL(7005Request){
    int nType = [[NetWorkManager sharedInstance] getTimeTypeFromStr:_strType];
    GraphResponse *graphResponseDataNew = [[GraphResponse alloc]init];
    
    GraphResponse *graphResponseData = response;
    
    graphResponseDataNew.strMarketID = graphResponseData.strMarketID;
    
    graphResponseDataNew.strProductCode = graphResponseData.strProductCode;
    
    graphResponseDataNew.strProductName = graphResponseData.strProductName;
    
    graphResponseDataNew.strType = _strType;
    
    graphResponseDataNew.nGraphType = graphResponseData.nGraphType;
    
    //把获取的字段存于全局变量中
    _strMarketID = graphResponseDataNew.strMarketID;
    _strProductCode = graphResponseDataNew.strProductCode;
    
    //当为请求DG,以DG文件中最大的时间为开始时间，可能存在一条重复数据，过滤掉
    
    if (nType >= 7) {
        
        NSMutableArray *arrayFilter = [NSMutableArray array];
        
        NSString *path = [self fileStorePathByFileType:DBFileType_DG MarketID:graphResponseData.strMarketID ProductCode:graphResponseData.strProductCode];
        
        SqliteManager *sqliteManger = [[SqliteManager alloc] init];
        
        NSString *minTime = [sqliteManger queryMaxTime:path];
        
        for (FenBi7005Data_Obj *obj in graphResponseData.arrayGraphDate_Obj) {
            
            if ([obj.strTime compare: minTime] == NSOrderedDescending) {
                
                [arrayFilter addObject:obj];
            }
            
        }
        
        graphResponseDataNew.arrayGraphDate_Obj = arrayFilter;
        
    }

    //整理数据
    graphResponseDataNew.arrayGraphDate_Obj = [self getDefargGraphDataWithArrayData:graphResponseData.arrayGraphDate_Obj Type:graphResponseDataNew.strType];
    
    
    //把获取的对象存于全局变量中
    _objCurGraphResponse = graphResponseDataNew;
    
    if (_objCurGraphResponse.arrayGraphDate_Obj.count < MinGraphDataCount) {
        
        NSTimeInterval time = 0;
        if (_objCurGraphResponse.arrayGraphDate_Obj.count) {
            FenBi7005Data_Obj *obj_FenBi7005Data = [_objCurGraphResponse.arrayGraphDate_Obj objectAtIndex:0];
            time = obj_FenBi7005Data.nTime;
        } else {
            
            time = [[NSDate date] timeIntervalSince1970];
        }
        
#warning 此处界面处理干啥呢？
       // [[NetWorkManager sharedInstance] removeMBProgressView];
        
        [self getDefargGraphDataFromTime:time AndMarket:_strMarketID AndProductCode:_strProductCode AndType:_strType];
        
    } else {
        [self callBackGraphData:_objCurGraphResponse];

    }
    

}
-(double)sumArrayWithData:(NSArray*)data andRange:(NSRange)range{
    double value = 0;
    if (data.count - range.location>range.length) {
        NSArray *newArray = [data objectsAtIndexes:[[NSIndexSet alloc] initWithIndexesInRange:range]];
        for (FenBi7005Data_Obj *item in newArray) {
            value += [item.strClosePrice doubleValue];
        }
        if (value>0) {
            value = value / newArray.count;
        }
    }
    return value;
}
-(void)calcMA:(GraphResponse*)resonse{
    NSArray *newArray = resonse.arrayGraphDate_Obj;
    NSInteger idx;
    int MA5=5,MA10=10,MA20=20; // 均线统计
    for (idx = newArray.count-1; idx > 0; idx--) {
        FenBi7005Data_Obj *obj = [newArray objectAtIndex:idx];
        CGFloat idxLocation = idx;
        obj.MA5 =  [self sumArrayWithData:newArray andRange:NSMakeRange(idxLocation, MA5)];
        obj.MA10 = [self sumArrayWithData:newArray andRange:NSMakeRange(idxLocation, MA10)];
        obj.MA20 = [self sumArrayWithData:newArray andRange:NSMakeRange(idxLocation, MA20)];
        
    }
}

-(void)callBackGraphData:(GraphResponse*)resonse{
    //计算MA5,MA10，M20
    [self calcMA:resonse];
    
    [[CSocketListenerManager sharedInstance] callBack:PROTOCOL_SEL(KGraph) withObjcet:resonse];

}

- (NSString *) fileStorePathByFileType:(int)nFileType MarketID:(NSString *)strMarketID ProductCode:(NSString *)strProductCode
{
    
    NSString *fileName = [NSString stringWithFormat:@"%@_%@.db",strMarketID,strProductCode];
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *docDir = nil;
    
    switch (nFileType) {
        case DBFileType_DG:
        {
            docDir = [NSString stringWithFormat:@"%@/db/DG/%@",path,fileName];
        }
            break;
        case DBFileType_M1G:
        {
            docDir = [NSString stringWithFormat:@"%@/db/M1G/%@",path,fileName];
        }
            break;
        case DBFileType_M5G:
        {
            docDir = [NSString stringWithFormat:@"%@/db/M5G/%@",path,fileName];
        }
            break;
            
        default:
            break;
    }
    
    
    return docDir;
    
    
}

- (void)DownloadSuccessGraphDataFun_MOVING_Data
{

    //判断MG文件是否存在
    BOOL bExistMGFile = [self.dbMnger queryStatus_ByTime:_strFenBi7005DataTime];
    
    if (!bExistMGFile) {
        
        //下载文件
        [self downloadFile];
        
    }
    else
    {
        NSArray *arrayMGFileData;
        
        
        NSString *strTime = [[NetWorkManager sharedInstance] getStrFromSec:_nTime];
    
        //如果_arrayFileData有数据，则取_arrayFileData第一个数据时间来查询,避免数据重复;
        if (_arrayFileData.count) {
            
            FenBi7005Data_Obj *obj = [_arrayFileData firstObject];
            
            strTime = obj.strTime;
            
        }
        
        arrayMGFileData = [self.dbMnger queryData_ByBeginTime:strTime EndTime:[_strFenBi7005DataTime stringByAppendingString:@" 00:00:00"] AndType:_strType];
        
        arrayMGFileData = [[NetWorkManager sharedInstance] FromGraphDataConversionFenBi7005Data_Obj:arrayMGFileData AndType:_strType];
        
        if (arrayMGFileData.count ==0) {
            
            //下载文件
            [self downloadFile];

            return;
        }
        else
        {
            //把从文件取到的数据放入graphResponseData数组中
            _arrayFileData = [self insertObjFrom:arrayMGFileData ToArray:_arrayFileData];
            
            if (_arrayFileData.count == MinGraphDataCount) {
                
                [self handelFenBi7005Data_ObjList:_arrayFileData];
                
                return;
            }
            else
            {
                //下载文件
                [self downloadFile];
            }
        }
    }
}

- (void) DownloadErrorGraphDataFun:(NSNotification *)notify
{
    int nDBFileType = [[notify.userInfo objectForKey:@"Notification_DownloadFun_AsynFileDownloadError"] intValue];
    
    NSString *fileName = [NSString stringWithFormat:@"%@_%@.db",_strMarketID,_strProductCode];
    
    if (nDBFileType == DBFileType_DG) {
        
        //判断MG文件是否存在
        BOOL bExistMGFile = [self.dbMnger queryMaxTimeByType:@"D1"] != nil;
        
        if (bExistMGFile) {
            
            //删除不能打开的文件
            [[NetWorkManager sharedInstance] deleteConfigFile:@"/db/DG/" AndFileURL:fileName];
            
        }
        
        //重新下载文件
        [self downloadDBFileFrom:self.graphSever.DBURL AndDBFileType:DBFileType_DG AndMarketID:_strMarketID AndProductCode:_strProductCode];
        
        return;
        
    }
    else if (nDBFileType == DBFileType_M1G)
    {
        //判断MG文件是否存在
        BOOL bExistMGFile = [self.dbMnger queryMaxTimeByType:@"M1"] != nil;
        
        if (bExistMGFile) {
            
            //删除不能打开的文件
            [[NetWorkManager sharedInstance]deleteConfigFile:@"/db/M1G/" AndFileURL:fileName];
            
        }
        
        //重新下载文件
        [self downloadDBFileFrom:self.graphSever.DBURL AndDBFileType:DBFileType_M1G AndMarketID:_strMarketID AndProductCode:_strProductCode];
        
        return;
        
    } else if (nDBFileType == DBFileType_M5G) {
        BOOL bExistMGFile = [self.dbMnger queryMaxTimeByType:@"M5"] != nil;
        
        if (bExistMGFile) {
            
            //删除不能打开的文件
            [[NetWorkManager sharedInstance]deleteConfigFile:@"/db/M5G/" AndFileURL:fileName];
            
        }
        
        //重新下载文件
        [self downloadDBFileFrom:self.graphSever.DBURL AndDBFileType:DBFileType_M5G AndMarketID:_strMarketID AndProductCode:_strProductCode];
        
        return;

    }
   
}
-(void)setDownload:(DownloadFun *)download{
    [_download.defaulNotificationCenter removeObserver:self];
    _download = download;
    [download.defaulNotificationCenter addObserver:self selector:@selector(DownloadErrorGraphDataFun:) name:@"Notification_DownloadFun_AsynFileDownloadError" object:nil];
    [download.defaulNotificationCenter  addObserver:self selector:@selector(DownloadSuccess_GraphDataFun_Data:) name:@"Notification_DownloadFun_AsynFileDownloadSuccess" object:nil];

}
#pragma mark - 自定义方法

//下载DB文件
- (void) downloadDBFileFrom:(NSString *) strURL AndDBFileType:(int)nDBFileType AndMarketID:(NSString *)strMarketID AndProductCode:(NSString *)strProductCode AndDay:(NSString *)strDay
{
    
    NSString *fileName = [NSString stringWithFormat:@"%@_%@.db",strMarketID,strProductCode];
    
    fileName = [[self getPathComponent:nDBFileType] stringByAppendingString:fileName];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@" ,strURL,fileName];
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *pathName = [path stringByAppendingPathComponent:fileName];
    
    
    [self.download.connection cancel];  //开始新的文件下载前，取消以前的下载
    
    self.download = [DownloadFun downloadWithUrlString:urlString andSavePath:pathName];
    [self.download setType:nDBFileType];
    
    return;
}

//下载文件
- (void) downloadDBFileFrom:(NSString *) strURL AndDBFileType:(int)nDBFileType AndMarketID:(NSString *)strMarketID AndProductCode:(NSString *)strProductCode
{
    
    NSString *fileName = [NSString stringWithFormat:@"%@_%@.db",strMarketID,strProductCode];
    
    fileName = [[self getPathComponent:nDBFileType] stringByAppendingString:fileName];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@" ,strURL,fileName];
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *pathName = [path stringByAppendingPathComponent:fileName];
    
    [self.download.connection cancel];  //开始新的文件下载前，取消以前的下载
    
    self.download = [DownloadFun downloadWithUrlString:urlString andSavePath:pathName];
    
    [self.download setType:nDBFileType];
    
    return;
}


//判断DB文件是否存在, 如果DBFileType_MG类型则需要AndDay参数
- (BOOL) isDBFileExistByMarketID:(NSString *)strMarketID AndProductCode:(NSString *)strProductCode AndDBFileType:(int)nDBFileType AndDay:(NSString *)strDay{

    NSString *pathName = [self fileStorePathByFileType:nDBFileType MarketID:strMarketID ProductCode:strProductCode];
    
    NSFileManager *fileManger = [NSFileManager defaultManager];
    
    if ([fileManger fileExistsAtPath:pathName]) {
        
        return YES;
    }

    return NO;
}

- (BOOL) isFileExistByMarketID:(NSString *)strMarketID ProductCode:(NSString *)strProductCode AndDBFileType:(int)nDBFileType
{
//    NSString *fileName = [NSString stringWithFormat:@"%@_%@.db",strMarketID,strProductCode];
//    
//    fileName = [NSString stringWithFormat:@"%@%@",[self getPathComponent:nDBFileType],fileName] ;
//    
//
//    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//    
//    NSString *pathName = [path stringByAppendingPathComponent:fileName];
    
    NSString *pathName = [self fileStorePathByFileType:nDBFileType MarketID:strMarketID ProductCode:strProductCode];
    
    NSFileManager *fileManger = [NSFileManager defaultManager];

    
    if ([fileManger fileExistsAtPath:pathName]) {
        
        return YES;
    }
    
    return NO;
}


////获得下载路径组成部分
//- (NSString *)getPathComponent:(int)nDBFileType AndDay:(NSString *)strDay
//{
//    NSString *fileName = @"";
//    switch (nDBFileType) {
//        case DBFileType_DG:
//        {
//            fileName = @"db/DG/";
//        }
//            break;
//        case DBFileType_MG:
//        {
//            fileName = [NSString stringWithFormat:@"db/MG/%@/",strDay];
//        }
//            break;
//            
//        default:
//            break;
//    }
//    return fileName;
//    
//}

//获得下载路径组成部分
- (NSString *)getPathComponent:(int)nDBFileType
{
    NSString *fileName = @"";
    switch (nDBFileType) {
        case DBFileType_DG:
        {
            fileName = @"db/DG/";
        }
            break;
        case DBFileType_M1G:
        {
            fileName = @"db/M1G/";
        }
            break;
        case DBFileType_M5G:
        {
            fileName = @"db/M5G/";
        }
            
        default:
            break;
    }
    return fileName;
    
}



////判断DG文件是否过期
//- (int) isDGFileExpiredByMarketID:(NSString *)strMarketID AndProductCode:(NSString *)strProductCode AndTime:(NSTimeInterval) nTimeDay
//{
//    
//    NSString *fileName = [NSString stringWithFormat:@"%@_%@.db",strMarketID,strProductCode];
//    
//    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//    
//    NSString *docDir = [NSString stringWithFormat:@"%@/db/DG/%@",path,fileName];
//    
//    NSTimeInterval  filedTime = [[NetWorkManager sharedInstance] getFileModificationDateFromPathString:docDir];
//    
//    MerpList_Obj *obj_MerpList = [[[NetWorkManager sharedInstance].dicMarket objectForKey:strMarketID] objectForKey:strProductCode];
//    
//    NSString * ddStr = [[NetWorkManager sharedInstance]convertDateFormatter:const_strTimeFormatter_Y_M_D targetFormatter:const_Trader_strTimeFormatter_YMDHMS dateString:obj_MerpList.nDd];
//    
//    NSTimeInterval dd = [[NetWorkManager sharedInstance]getTimeIntervalFromStr:ddStr];
//    
//    NSString * dateStr = [[NetWorkManager sharedInstance]getYMDHMSCurrentAccurateTimer];
//    
//    NSTimeInterval nowTime = [[NetWorkManager sharedInstance]getTimeIntervalFromStr:dateStr];
//    
//    if (dd > filedTime) {
//        
//        return DGFile_Invalid;
//    }
//    
//    if ((nowTime - nTimeDay) > 2592000)
//    {
//       
//        return DGFile_Expired;
//        
//    }else
//    {
//        return DGFile_Unexpired;
//    }
//    
//
//}


//判断文件是否过期
- (int) isFileExpiredByFileType:(int)nFileType MarketID:(NSString *)strMarketID ProductCode:(NSString *)strProductCode{
    
    NSString *docDir = [self fileStorePathByFileType:nFileType MarketID:strMarketID ProductCode:strProductCode];

    
    NSTimeInterval  filedTime = [[NetWorkManager sharedInstance] getFileModificationDateFromPathString:docDir];
    
    MerpList_Obj *obj_MerpList = self.merpObj;
    
    NSString * ddStr = [[NetWorkManager sharedInstance]convertDateFormatter:const_strTimeFormatter_Y_M_D targetFormatter:const_Trader_strTimeFormatter_YMDHMS dateString:obj_MerpList.nDd];
    
    NSTimeInterval dd = [[NetWorkManager sharedInstance]getTimeIntervalFromStr:ddStr];
    
    NSString * dateStr = [[NetWorkManager sharedInstance]getYMDHMSCurrentAccurateTimer];
    
    NSTimeInterval nowTime = [[NetWorkManager sharedInstance]getTimeIntervalFromStr:dateStr];
    
    if (dd > filedTime) {
        
        return DBFile_Invalid;
    }
    
    if (nFileType == DBFileType_DG) {
        
        if ((nowTime - filedTime) > 2592000)
        {
            
            return DBFile_Expired;
            
        }
        
    } else {
        
        //比较现在时间和文件创建时间是否为同一天，如果不是则过期
        NSString *strNowTime = [[NetWorkManager sharedInstance] getStrFromSec:nowTime];
        
        NSString *strFiledTime = [[NetWorkManager sharedInstance] getStrFromSec:filedTime];
        
        NSString *strFormatterNowTime = [[NetWorkManager sharedInstance] convertDateFormatter:const_Trader_strTimeFormatter_YMDHMS targetFormatter:const_strTimeFormatter_Y_M_D dateString:strNowTime];
        
        NSString *strFormatterFieldTime = [[NetWorkManager sharedInstance] convertDateFormatter:const_Trader_strTimeFormatter_YMDHMS targetFormatter:const_strTimeFormatter_Y_M_D dateString:strFiledTime];
        
        if ([strFormatterNowTime compare:strFormatterFieldTime] != NSOrderedSame) {
            
            return DBFile_Expired;
            
        }
        
    }
    
    
    return DBFile_Valid;
    
    
}



//解析DG文件
- (NSArray *) parseDGFileByMarketID:(NSString *)strMarketID AndProductCode:(NSString *)strProductCode AndTime:(NSTimeInterval) nTimeDay
{
    
    NSString *strTime = [[NetWorkManager sharedInstance]getStrFromSec:nTimeDay];
    
    SqliteManager *sqliteManager = [[SqliteManager alloc]init];
    
    NSArray *arrayData = [sqliteManager getArrayFromSqliteDGFileByMarketID:strMarketID AndProductCode:strProductCode AndTime:strTime];
    
    return arrayData;

}



//解析MG文件
- (NSArray *) parseMGFileByMarketID:(NSString *)strMarketID AndProductCode:(NSString *)strProductCode AndTime:(NSTimeInterval) nTimeMinute
{
    
    NSString *strTime = [[NetWorkManager sharedInstance]getStrFromSec:nTimeMinute];
    
    SqliteManager *sqliteManager = [[SqliteManager alloc]init];
    
    NSArray *arrayData = [sqliteManager getArrayFromSqliteMGFileByMarketID:strMarketID AndProductCode:strProductCode AndTime:strTime AndOtherTime:_strFenBi7005DataTime];
    
    return arrayData;
}



//处理接收得到数据，返回一个数组－－对象（type example M1 M5 ...）
- (NSMutableArray *)getDefargGraphDataWithArrayData:(NSArray *)arrayDate Type:(NSString *)type
{
    arrayNewData = [NSMutableArray array];
    
    NSArray *arrayReceiveDate = arrayDate;
    
    if (arrayReceiveDate.count==0) {
        
        return arrayNewData;
        
    }
    
    FenBi7005Data_Obj *obj_FenBi7005DataNew = [[FenBi7005Data_Obj alloc]init];
    
    FenBi7005Data_Obj *obj_FenBi7005DataOtherNew = [[FenBi7005Data_Obj alloc]init];
    
    for (int j=0; j<arrayReceiveDate.count-1; j++)
    {
        
        FenBi7005Data_Obj *obj_FenBi7005Data = arrayReceiveDate[j];
        
        FenBi7005Data_Obj *obj_FenBi7005DataNext = arrayReceiveDate[j+1];
        
        NSInteger timeBefore=0,timeNext=0;//初始值
        
        if ([type isEqualToString:@"W1"])
        {
            
            timeBefore = [[NetWorkManager sharedInstance] getWeekNum:obj_FenBi7005Data.strTime];
            
            timeNext = [[NetWorkManager sharedInstance] getWeekNum:obj_FenBi7005DataNext.strTime];
        }
        
        else if ([type isEqualToString:@"MN"])
        {
            timeBefore = [[NetWorkManager sharedInstance] getMonthFromDateString:obj_FenBi7005Data.strTime];
            
            timeNext = [[NetWorkManager sharedInstance] getMonthFromDateString:obj_FenBi7005DataNext.strTime];
        }
        
        else if ([type isEqualToString:@"M1"])
        {
            timeBefore = obj_FenBi7005Data.nTime/60*60;
            
            timeNext = obj_FenBi7005DataNext.nTime/60*60;
        }
        
        else if ([type isEqualToString:@"M5"])
        {
            timeBefore = obj_FenBi7005Data.nTime/(5*60)*(5*60);
            
            timeNext = obj_FenBi7005DataNext.nTime/(5*60)*(5*60);
        }
        
        else if ([type isEqualToString:@"M15"])
        {
            timeBefore = obj_FenBi7005Data.nTime/(15*60)*(15*60);
            
            timeNext = obj_FenBi7005DataNext.nTime/(15*60)*(15*60);
        }
        
        else if ([type isEqualToString:@"M30"])
        {
            timeBefore = obj_FenBi7005Data.nTime/(30*60)*(30*60);
            
            timeNext = obj_FenBi7005DataNext.nTime/(30*60)*(30*60);
        }
        
        else if ([type isEqualToString:@"H1"])
        {
            timeBefore = obj_FenBi7005Data.nTime/(60*60)*(60*60);
            
            timeNext = obj_FenBi7005DataNext.nTime/(60*60)*(60*60);
        }
        
        else if ([type isEqualToString:@"H4"])
        {
            timeBefore = obj_FenBi7005Data.nTime/(4*60*60)*(4*60*60);
            
            timeNext = obj_FenBi7005DataNext.nTime/(4*60*60)*(4*60*60);
        }
        else if ([type isEqualToString:@"D1"])
        {
            timeBefore = obj_FenBi7005Data.nTime/(24*60*60)*(24*60*60);
            
            timeNext = obj_FenBi7005DataNext.nTime/(24*60*60)*(24*60*60);
        }
        
        if (_bDataStatus == YES)
        {
            
            obj_FenBi7005DataOtherNew.strOpenPrice = obj_FenBi7005Data.strOpenPrice;
            
            if ([type isEqualToString:@"W1"]||[type isEqualToString:@"MN"])
            {
                obj_FenBi7005DataNew.strTime = obj_FenBi7005Data.strTime;
            }
            else
            {
                obj_FenBi7005DataNew.strTime = [[NetWorkManager sharedInstance] getStrFromSec:timeBefore];
            }
            obj_FenBi7005DataNew.nTime = obj_FenBi7005Data.nTime;
            
            obj_FenBi7005DataNew.strClosePrice = obj_FenBi7005Data.strClosePrice;
            
            obj_FenBi7005DataNew.strAmount = obj_FenBi7005Data.strAmount;
            
            obj_FenBi7005DataNew.strVolume = obj_FenBi7005Data.strVolume;
            
            obj_FenBi7005DataNew.strHighestPrice = obj_FenBi7005Data.strHighestPrice;
            
            obj_FenBi7005DataNew.strLowestPrice = obj_FenBi7005Data.strLowestPrice;
            
            _bDataStatus = NO;
        }
        
        
        //通过时间来获取在该段时间内的最佳值
        if (timeBefore == timeNext) {
            
            if ([type isEqualToString:@"W1"]||[type isEqualToString:@"MN"]) {
                
                obj_FenBi7005DataNew.strTime = obj_FenBi7005DataNext.strTime;
            }
            else
            {
                obj_FenBi7005DataNew.strTime = [[NetWorkManager sharedInstance] getStrFromSec:timeNext];
                
            }
            
            obj_FenBi7005DataNew.nTime = obj_FenBi7005DataNext.nTime;
            
            obj_FenBi7005DataNew.strClosePrice = obj_FenBi7005DataNext.strClosePrice;
            
            obj_FenBi7005DataNew.strAmount = obj_FenBi7005DataNext.strAmount;
            
            obj_FenBi7005DataNew.strVolume = obj_FenBi7005DataNext.strVolume;
            
            
            if ([obj_FenBi7005Data.strHighestPrice doubleValue]>[obj_FenBi7005DataNext.strHighestPrice doubleValue]) {
                
                if ([obj_FenBi7005DataNew.strHighestPrice doubleValue]<[obj_FenBi7005Data.strHighestPrice doubleValue]) {
                    
                    obj_FenBi7005DataNew.strHighestPrice = obj_FenBi7005Data.strHighestPrice;
                }
            }
            else
            {
                if ([obj_FenBi7005DataNew.strHighestPrice doubleValue]<[obj_FenBi7005DataNext.strHighestPrice doubleValue]) {
                    
                    obj_FenBi7005DataNew.strHighestPrice = obj_FenBi7005DataNext.strHighestPrice;
                }
                
            }
            
            
            if ([obj_FenBi7005Data.strLowestPrice doubleValue]>[obj_FenBi7005DataNext.strLowestPrice doubleValue]) {
                
                if ([obj_FenBi7005DataNew.strLowestPrice doubleValue]>[obj_FenBi7005DataNext.strLowestPrice doubleValue]) {
                    
                    obj_FenBi7005DataNew.strLowestPrice = obj_FenBi7005DataNext.strLowestPrice;
                }
                
            }
            else
            {
                if ([obj_FenBi7005DataNew.strLowestPrice doubleValue]>[obj_FenBi7005Data.strLowestPrice doubleValue])
                {
                    
                    obj_FenBi7005DataNew.strLowestPrice = obj_FenBi7005Data.strLowestPrice;
                    
                }
            }
            //处理最后两个数据
            if (j == arrayReceiveDate.count-2)
            {
                obj_FenBi7005DataOtherNew.nTime = obj_FenBi7005DataNew.nTime;
                
                obj_FenBi7005DataOtherNew.strTime = obj_FenBi7005DataNew.strTime;
                
                obj_FenBi7005DataOtherNew.strAmount = obj_FenBi7005DataNew.strAmount;
                
                obj_FenBi7005DataOtherNew.strVolume = obj_FenBi7005DataNew.strVolume;
                
                obj_FenBi7005DataOtherNew.strClosePrice = obj_FenBi7005DataNew.strClosePrice;
                
                obj_FenBi7005DataOtherNew.strHighestPrice = obj_FenBi7005DataNew.strHighestPrice;
                
                obj_FenBi7005DataOtherNew.strLowestPrice = obj_FenBi7005DataNew.strLowestPrice;
                
                _bDataStatus = YES;
                
                [arrayNewData addObject:obj_FenBi7005DataOtherNew];
                
            }
        }
        else
        {
            
            obj_FenBi7005DataOtherNew.nTime = obj_FenBi7005DataNew.nTime;
            
            obj_FenBi7005DataOtherNew.strTime = obj_FenBi7005DataNew.strTime;
            
            obj_FenBi7005DataOtherNew.strAmount = obj_FenBi7005DataNew.strAmount;
            
            obj_FenBi7005DataOtherNew.strVolume = obj_FenBi7005DataNew.strVolume;
            
            obj_FenBi7005DataOtherNew.strClosePrice = obj_FenBi7005DataNew.strClosePrice;
            
            obj_FenBi7005DataOtherNew.strHighestPrice = obj_FenBi7005DataNew.strHighestPrice;
            
            obj_FenBi7005DataOtherNew.strLowestPrice = obj_FenBi7005DataNew.strLowestPrice;
            
            _bDataStatus = YES;
            
            [arrayNewData addObject:obj_FenBi7005DataOtherNew];
            //对象重新初始化
            obj_FenBi7005DataNew = [[FenBi7005Data_Obj alloc]init];
            
            obj_FenBi7005DataOtherNew = [[FenBi7005Data_Obj alloc]init];
            
            if (j == arrayReceiveDate.count-2)
            {
                obj_FenBi7005DataNew = arrayReceiveDate[arrayReceiveDate.count-1];
                
                
                if ([type isEqualToString:@"W1"]||[type isEqualToString:@"MN"])
                {
                    
                    obj_FenBi7005DataOtherNew.strTime = obj_FenBi7005DataNext.strTime;
                }
                else
                {
                    obj_FenBi7005DataOtherNew.strTime = [[NetWorkManager sharedInstance] getStrFromSec:timeNext];
                    
                }
                obj_FenBi7005DataOtherNew.nTime = obj_FenBi7005DataNew.nTime;
                
                obj_FenBi7005DataOtherNew.strAmount = obj_FenBi7005DataNew.strAmount;
                
                obj_FenBi7005DataOtherNew.strVolume = obj_FenBi7005DataNew.strVolume;
                
                obj_FenBi7005DataOtherNew.strOpenPrice = obj_FenBi7005DataNew.strOpenPrice;
                
                obj_FenBi7005DataOtherNew.strClosePrice = obj_FenBi7005DataNew.strClosePrice;
                
                obj_FenBi7005DataOtherNew.strHighestPrice = obj_FenBi7005DataNew.strHighestPrice;
                
                obj_FenBi7005DataOtherNew.strLowestPrice = obj_FenBi7005DataNew.strLowestPrice;
                
                _bDataStatus = YES;
                
                [arrayNewData addObject:obj_FenBi7005DataOtherNew];
                
            }
            
        }
    }
    
    return arrayNewData;//返回的数据
    
}

-(MerpList_Obj*)merpObj{
    return [[CTradeClientSocket sharedInstance] merpListObjWithMpcode:self.strProductCode marketId:self.strMarketID];
}
-(GraphServerObj*)graphSever{
   return [[CTradeClientSocket sharedInstance] graphServerByMpIndex:@(self.merpObj.nIndex)];
}
-(void)getKLineDataByGraphType:(NSString *)strGraphType{
    int nType = [[NetWorkManager sharedInstance] getTimeTypeFromStr:strGraphType];
    self.strType = strGraphType;
    if (nType == 1) {
        
        BOOL bM1GFileExit = [self isFileExistByMarketID:self.strMarketID ProductCode:self.strProductCode AndDBFileType:DBFileType_M1G];
        
        if (!bM1GFileExit) {
            //strMaxTime不存在，说明M1G文件未下载过
            [self downloadDBFileFrom:self.graphSever.DBURL AndDBFileType:DBFileType_M1G AndMarketID:self.strMarketID AndProductCode:self.strProductCode];
        } else {
            
            int fileStatus = [self isFileExpiredByFileType:DBFileType_M1G MarketID:self.strMarketID ProductCode:self.strProductCode];
            
            if (fileStatus == DBFile_Invalid) {
                
                [self downloadDBFileFrom:self.graphSever.DBURL AndDBFileType:DBFileType_M1G AndMarketID:self.strMarketID AndProductCode:self.strProductCode];
                
            } else if (fileStatus == DBFile_Expired) {
                
                [self downloadDBFileFrom:self.graphSever.DBURL AndDBFileType:DBFileType_M1G AndMarketID:self.strMarketID AndProductCode:self.strProductCode];
                
            } else if (fileStatus == DBFile_Valid) {
                
                NSArray *arrayTime = [[NetWorkManager sharedInstance] getGraphaDataBeginTimeAndEndTime:0];
                
                [self requestFenBi7005:0 BeginTime:[arrayTime firstObject] EndTime:[arrayTime lastObject] AndMarketID:self.strMarketID productCode:self.strProductCode AndGraphType:strGraphType];
                
            }
        }
        
    } else if (nType > 1 && nType < 7) {
        
        BOOL bM5GFileExit = [self isFileExistByMarketID:self.strMarketID ProductCode:self.strProductCode AndDBFileType:DBFileType_M5G];
        if (!bM5GFileExit) {
            //strMaxTime不存在，说明M1G文件未下载过
            [self downloadDBFileFrom:self.graphSever.DBURL AndDBFileType:DBFileType_M5G AndMarketID:self.strMarketID AndProductCode:self.strProductCode];
        } else {
            
            
            int fileStatus = [self isFileExpiredByFileType:DBFileType_M5G MarketID:self.strMarketID ProductCode:self.strProductCode];
            
            if (fileStatus == DBFile_Invalid) {
                
                [self downloadDBFileFrom:self.graphSever.DBURL AndDBFileType:DBFileType_M5G AndMarketID:self.strMarketID AndProductCode:self.strProductCode];
                
            } else if (fileStatus == DBFile_Expired) {
                
                
                [self downloadDBFileFrom:self.graphSever.DBURL AndDBFileType:DBFileType_M5G AndMarketID:self.strMarketID AndProductCode:self.strProductCode];
                
            } else if (fileStatus == DBFile_Valid) {
                
                NSArray *arrayTime = [[NetWorkManager sharedInstance] getGraphaDataBeginTimeAndEndTime:0];
                
                [self requestFenBi7005:0 BeginTime:[arrayTime firstObject] EndTime:[arrayTime lastObject] AndMarketID:self.strMarketID productCode:self.strProductCode AndGraphType:strGraphType];
                
            }
        }
        
    } else if (nType >= 7) {
        
        BOOL bDGFileExit = [self isFileExistByMarketID:self.strMarketID ProductCode:self.strProductCode AndDBFileType:DBFileType_M5G];
        
        if (!bDGFileExit) {
            //strMaxTime不存在，说明M1G文件未下载过
            [self downloadDBFileFrom:self.graphSever.DBURL AndDBFileType:DBFileType_DG AndMarketID:self.strMarketID AndProductCode:self.strProductCode];
        } else {
            
            int fileStatus = [self isFileExpiredByFileType:DBFileType_DG MarketID:self.strMarketID ProductCode:self.strProductCode];
            
            if (fileStatus == DBFile_Invalid) {
                
                [self downloadDBFileFrom:self.graphSever.DBURL AndDBFileType:DBFileType_DG AndMarketID:self.strMarketID AndProductCode:self.strProductCode];
                
            } else if (fileStatus == DBFile_Expired) {
                
                
                [self downloadDBFileFrom:self.graphSever.DBURL AndDBFileType:DBFileType_DG AndMarketID:self.strMarketID AndProductCode:self.strProductCode];
                
            } else if (fileStatus == DBFile_Valid) {
                
                NSString *endTime = [[NetWorkManager sharedInstance] getYMDHMSCurrentAccurateTimer];
                
                SqliteManager *sqliteManger = [[SqliteManager alloc] init];
                
                NSString *filePath = [self fileStorePathByFileType:DBFileType_DG MarketID:self.strMarketID ProductCode:self.strProductCode];
                
                NSString *startTime = [sqliteManger queryMaxTime:filePath];
                
                [self requestFenBi7005:6 BeginTime:startTime EndTime:endTime AndMarketID:self.strMarketID productCode:self.strProductCode AndGraphType:strGraphType];
                
            }
        }
    }
}
-(void)getTimeLineData{
    OpenCloseTime_Obj *obj_OpenCloseTime = [[CTradeClientSocket sharedInstance] getOpenCloseTime_Obj:[NetWorkManager sharedInstance].nCurTimeSec AndMapID:[@(self.merpObj.nIndex) stringValue]];
    self.strType  = @"M1";
    [self.gpTimeSocket downloadTimeGraphByMpIndex:@(self.merpObj.nIndex) startTime:obj_OpenCloseTime.strOpentime endTime:obj_OpenCloseTime.strClosetime];
}

-(void) requestFenBi7005:(int) nGraphType BeginTime:(NSString *) strBeginTime EndTime:(NSString *) strEndTime AndMarketID:(NSString *)strMarketID productCode:(NSString *)strProductCode AndGraphType:(NSString *)strGraphType{

    _strType = strGraphType;
    if (nGraphType == 0) {
        [self.gpSocket download1mGraphByMpIndex:@(self.merpObj.nIndex) startTime:strBeginTime endTime:strEndTime];
    }else{
        [self.gpSocket download1DGraphByMpIndex:@(self.merpObj.nIndex) startTime:strBeginTime endTime:strEndTime];

    }
   
}



@end
