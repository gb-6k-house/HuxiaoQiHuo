//
//  CGraphClientSocket.m
//  HuXiaoQiHuo
//
//  Created by niupark on 16/5/27.
//  Copyright © 2016年 fukeng. All rights reserved.
//

#import "CGraphClientSocket.h"
#import "NetUtility.h"
#import "GraphRequest.h"
#import "GraphResponse.h"
#import "FenBiRequest.h"
#import "GraphStruct.h"
#import "marketIndex_Obj.h"
#import "TimeShare_Obj.h"
#import "FenBi7005Data_Obj.h"
#import "Constants.h"
#import "CTradeClientSocket.h"
#import "NetWorkManager.h"
#import "OpenTimePointObj.h"
#import "OpenCloseTime_Obj.h"

@interface CGraphClientSocket(){
    int nState;
}
@property(nonatomic, strong) GraphResponse * timeShareGraphData;  //7002 响应
@property(nonatomic, strong) GraphResponse * fenBiGraphData;      //7005 响应
@property(nonatomic, strong) NSThread *threadHandleData; //处理7002数据线程
@property BOOL bDrawTimeShare;

@end
@implementation CGraphClientSocket

- (id) init{
    if((self = [super init])) {
        nState = State_MsgNone;
    }
    return self;
}


-(void)download1mGraphByMpIndex:(NSNumber*)mpIndex startTime:(NSString*)startTime endTime:(NSString*)endTime{
    self.bDrawTimeShare = NO;
    NSMutableDictionary * dicPriceRequest = [[NSMutableDictionary alloc] init];
    [dicPriceRequest setObject:@"7005" forKey:@"cmdCode"];
    [dicPriceRequest setObject:startTime forKey:@"startTime"];
    [dicPriceRequest setObject:endTime forKey:@"endTime"];
    [dicPriceRequest setObject:@(0) forKey:@"graphType"];
    [dicPriceRequest setObject:mpIndex forKey:@"mapID"];
    [self sendData:[NetWorkManager getJSONString:dicPriceRequest]];

}
-(void)download1DGraphByMpIndex:(NSNumber*)mpIndex startTime:(NSString*)startTime endTime:(NSString*)endTime{
    self.bDrawTimeShare = NO;
    NSMutableDictionary * dicPriceRequest = [[NSMutableDictionary alloc] init];
    [dicPriceRequest setObject:@"7005" forKey:@"cmdCode"];
    [dicPriceRequest setObject:startTime forKey:@"startTime"];
    [dicPriceRequest setObject:endTime forKey:@"endTime"];
    [dicPriceRequest setObject:@(6) forKey:@"graphType"];
    [dicPriceRequest setObject:mpIndex forKey:@"mapID"];
    [self sendData:[NetWorkManager getJSONString:dicPriceRequest]];
}
-(void)downloadTimeGraphByMpIndex:(NSNumber*)mpIndex startTime:(NSString*)startTime endTime:(NSString*)endTime{
    self.bDrawTimeShare = YES;
    NSMutableDictionary * dicPriceRequest = [[NSMutableDictionary alloc] init];
//    [dicPriceRequest setObject:@"7005" forKey:@"cmdCode"];
//    [dicPriceRequest setObject:startTime forKey:@"startTime"];
//    [dicPriceRequest setObject:endTime forKey:@"endTime"];
//    [dicPriceRequest setObject:@(0) forKey:@"graphType"];
//    [dicPriceRequest setObject:mpIndex forKey:@"mapID"];
    [dicPriceRequest setObject:@"7002" forKey:@"cmdCode"];
    [dicPriceRequest setObject:startTime forKey:@"startTime"];
    [dicPriceRequest setObject:endTime forKey:@"endTime"];
    [dicPriceRequest setObject:mpIndex forKey:@"mapID"];
    [self sendData:[NetWorkManager getJSONString:dicPriceRequest]];
}
-(void) handelReciveData:(NSMutableData *) data{
    //    NSLog(@"socket--->socket连接服务%@:%d 收到行情数据，正在处理",currenthost, currentport);
    [self parseGraphMsg:data];
    
}
-(void)parseGraphMsg:(NSMutableData *) data
{
    NSUInteger nDataLen = [data length];
    NSUInteger nDeletRangLen = 0;
    
    NSRange deleteRange;
    deleteRange.location=0;
    deleteRange.length = 0;
    
    char cType;
    
    while (nDataLen >= 1)
    {
        
        switch (nState)
        {
            case State_MsgNone:
            {
                //nState = State_MsgHead;
                // 获取数据的类型 sizeof用来计算一个变量或者一个常量、一种数据类型所占的内存字节数
                [data getBytes:&cType length:sizeof(cType)];
                
                ////////处理消息头的switch Begin/////
                switch (cType)
                {
                    case ResponseType_Heart:
                    {
                        nDeletRangLen = sizeof(cType);
                        
                        deleteRange.length = nDeletRangLen;
                        
                        nDataLen = nDataLen - nDeletRangLen;
                        
                        [data replaceBytesInRange:deleteRange withBytes: nil length:0];
                        
                        nState = State_MsgNone; //
                        
                        break;
                    }
                        
                        //分时图用数据
                    case ResponseType_Price01:
                    {
                        //处理头结构，删除数据中的头结构长度数据
                        
                        GraphHead_st curHead_st;
                        
                        if( nDataLen < sizeof(curHead_st))
                            return;
                        
                        [data getBytes:&curHead_st length:sizeof(curHead_st)];
                        
                        nDeletRangLen = sizeof(curHead_st);
                        
                        deleteRange.length = nDeletRangLen;
                        
                        nDataLen = nDataLen - nDeletRangLen;
                        
                        [data replaceBytesInRange:deleteRange withBytes: nil length:0];
                        
                        nState = State_Msg01; //状态机进入body获取流程
                        
                        
                        //建立HeardObj
                        
                        self.timeShareGraphData = [[GraphResponse alloc] init];
                        
                        marketIndex_Obj * objMarketIndex =[[CTradeClientSocket sharedInstance] marketIndexByMpIndex:[NSString stringWithFormat:@"%d", curHead_st.mapID]];
                        
                        
                        self.timeShareGraphData.strMarketID = objMarketIndex.strMarketID;
                        
                        self.timeShareGraphData.strProductCode = objMarketIndex.strMpcode;
                        
                        self.timeShareGraphData.strProductName = [[CTradeClientSocket sharedInstance] merpListObjWithMpcode:self.timeShareGraphData.strProductCode marketId:self.timeShareGraphData.strMarketID].strMpname;
                        
                        self.timeShareGraphData.nGraphType = 1; //现在都他妈是一分钟图了，需要自己合并，坑爹吧～
                        
                        self.timeShareGraphData.nCount = curHead_st.count;
                        
                        self.timeShareGraphData.arrayGraphDate_Obj = [[NSMutableArray alloc] init];
                        
                        break;
                        
                    }
                        
                    case ResponseType_Price05:
                    {
                        //处理头结构，删除数据中的头结构长度数据
                        
                        GraphHead7005_st curHead_st;
                        
                        if( nDataLen < sizeof(curHead_st))
                            return;
                        
                        [data getBytes:&curHead_st length:sizeof(curHead_st)];
                        
                        nDeletRangLen = sizeof(curHead_st);
                        
                        deleteRange.length = nDeletRangLen;
                        
                        nDataLen = nDataLen - nDeletRangLen;
                        
                        [data replaceBytesInRange:deleteRange withBytes: nil length:0];
                        
                        nState = State_Msg05;
                        
                        //建立HeardObj
                        
                        self.fenBiGraphData = [[GraphResponse alloc] init];
                        
                        marketIndex_Obj * objMarketIndex = [[CTradeClientSocket sharedInstance] marketIndexByMpIndex:[NSString stringWithFormat:@"%d", curHead_st.mapID]];
                        
                        self.fenBiGraphData.strMarketID = objMarketIndex.strMarketID;
                        
                        self.fenBiGraphData.strProductCode = objMarketIndex.strMpcode;
                        
                        self.fenBiGraphData.strProductName = [[CTradeClientSocket sharedInstance] merpListObjWithMpcode:self.fenBiGraphData.strProductCode marketId:self.fenBiGraphData.strMarketID].strMpname;
                        
                        self.fenBiGraphData.nGraphType = 1; //现在都他妈是一分钟图了，需要自己合并，坑爹吧～
                        
                        self.fenBiGraphData.nCount = curHead_st.count;
                        
                        self.fenBiGraphData.arrayGraphDate_Obj = [[NSMutableArray alloc] init];
                        
                        break;
                        
                    }
                        
                    default:
                    {
                        //接受消息错乱
                    }
                        
                }
                
                ////////处理消息头的switch End/////
                
                
                break;
            }
                
                
            case State_Msg01:
            {
                ////////处理消息01 Body Begin/////
                if (self.timeShareGraphData.nCount < 1) //有可能收到array是0的count所以一开始就先判断一下
                {
                    nState = State_MsgNone;  // 处理完成一个Body array
                    
                    [self parseTimeShareMsg:self.timeShareGraphData];
                    
                    break;
                }
                
                
                GraphBody01_st curGraphBody01;
                
                if (nDataLen < sizeof(curGraphBody01))
                    return;
                
                //开始处理一条body消息
                
                [data getBytes:&curGraphBody01 length:sizeof(curGraphBody01)];
                
                nDeletRangLen = sizeof(curGraphBody01);
                
                deleteRange.length = nDeletRangLen;
                
                nDataLen = nDataLen - nDeletRangLen;
                
                [data replaceBytesInRange:deleteRange withBytes: nil length:0];
                
                self.timeShareGraphData.nCount--;
                
                //将数据包转换成NSValue对象存入数组中
                NSValue *value = [NSValue valueWithBytes:&curGraphBody01 objCType:@encode(GraphBody01_st)];
                
                [self.timeShareGraphData.arrayGraphDate_Obj addObject:value];
                
                if (self.timeShareGraphData.nCount < 1)
                {
                    nState = State_MsgNone;  // 处理完成一个Body array
                    
                    [self parseTimeShareMsg:self.timeShareGraphData];
                    
                    
                }
                
                ////////处理消息01 Body End/////
                
                break;
            }
                
            case State_Msg05:
            {
                ////////处理消息05 Body的switch Begin/////
                
                if (self.fenBiGraphData.nCount < 1) //有可能收到array是0的count所以一开始就先判断一下
                {
                    nState = State_MsgNone;  // 处理完成一个Body array
                    
                    [self parseFenBi7005Msg:self.fenBiGraphData];
                    
                    break;
                }
                
                GraphBody05_st curGraphBody05;
                
                if (nDataLen < sizeof(curGraphBody05))
                    return;
                
                //开始处理一条body消息
                
                [data getBytes:&curGraphBody05 length:sizeof(curGraphBody05)];
                
                nDeletRangLen = sizeof(curGraphBody05);
                
                deleteRange.length = nDeletRangLen;
                
                nDataLen = nDataLen - nDeletRangLen;
                
                [data replaceBytesInRange:deleteRange withBytes: nil length:0];
                
                self.fenBiGraphData.nCount--;
                
                ////
                FenBi7005Data_Obj * objFenBi7005Data = [[FenBi7005Data_Obj alloc] init];
                
                
                objFenBi7005Data.nTime = curGraphBody05.time;
                
                objFenBi7005Data.strTime = [[NetWorkManager sharedInstance] getStrFromSec:curGraphBody05.time];
                
                MerpList_Obj*merpObj = [[CTradeClientSocket sharedInstance] merpListObjWithMpcode:self.fenBiGraphData.strProductCode marketId:self.fenBiGraphData.strMarketID];
                NSInteger nPrecision = 2;
                if (merpObj) {
                    nPrecision = merpObj.nPrecision;
                }
                
                objFenBi7005Data.strOpenPrice = [NSString stringWithFormat:[NSString stringWithFormat:@"%%.%ldf", (long)nPrecision], curGraphBody05.fOpenPrice];
                
                objFenBi7005Data.strClosePrice = [NSString stringWithFormat:[NSString stringWithFormat:@"%%.%ldf", (long)nPrecision], curGraphBody05.fClosePrice];
                
                objFenBi7005Data.strHighestPrice = [NSString stringWithFormat:[NSString stringWithFormat:@"%%.%ldf", (long)nPrecision], curGraphBody05.fHighestPrice];
                
                objFenBi7005Data.strLowestPrice = [NSString stringWithFormat:[NSString stringWithFormat:@"%%.%ldf", (long)nPrecision], curGraphBody05.fLowestPrice];
                
                int nVolume = curGraphBody05.fVolume;
                
                objFenBi7005Data.strVolume = [NSString stringWithFormat:@"%d", nVolume];
                
                objFenBi7005Data.strAmount = [NSString stringWithFormat:[NSString stringWithFormat:@"%%.%ldf", (long)nPrecision], curGraphBody05.fAmount];
                
                [self.fenBiGraphData.arrayGraphDate_Obj addObject:objFenBi7005Data];

                
                if (self.fenBiGraphData.nCount < 1)
                {
                    nState = State_MsgNone;  // 处理完成一个Body array
                    
                    [self parseFenBi7005Msg:self.fenBiGraphData];
                    
                    
                }
                
                
                ////////处理消息05 Body的switch End/////
                
                break;
            }
                
                
        }
        
        
    }
    
}

-(void) parseTimeShareMsg:(GraphResponse *) objGraphData
{
    //开启一个线程去处理数据
    self.threadHandleData = [[NSThread alloc] initWithTarget:self selector:@selector(handleData:) object:objGraphData];
    [self.threadHandleData start];
}

- (void)handleData:(GraphResponse *) objGraphData
{
    GraphResponse *fenbiGraphData = [[GraphResponse alloc] init];
    fenbiGraphData.strMarketID = objGraphData.strMarketID;
    fenbiGraphData.strProductCode = objGraphData.strProductCode;
    fenbiGraphData.strProductName = objGraphData.strProductName;
    fenbiGraphData.strType = objGraphData.strType;
    
    fenbiGraphData.nGraphType = objGraphData.nGraphType;
    fenbiGraphData.nCount = objGraphData.nCount;
    
    fenbiGraphData.arrayGraphDate_Obj = [NSMutableArray array];
    
    for (int i = 0; i<objGraphData.arrayGraphDate_Obj.count; i++) {
        
        //如果线程为取消状态,则退出当前线程
        if ([[NSThread currentThread] isCancelled]) {
            [NSThread exit];
        }
        
        NSValue *value = objGraphData.arrayGraphDate_Obj[i];
        
        GraphBody01_st curGraphBody01;
        
        [value getValue:&curGraphBody01];
        
        
        TimeShare_Obj * objTimeShare = [[TimeShare_Obj alloc] init];
        MerpList_Obj*merpObj = [[CTradeClientSocket sharedInstance] merpListObjWithMpcode:self.timeShareGraphData.strProductCode marketId:self.timeShareGraphData.strMarketID];

        //获取unit
        int nUnit = merpObj.nUnit;
        
        float fAvgPrice;
        if (nUnit < 1)
        {
            fAvgPrice = 0;
        }else{
            int nOpt = merpObj.nOpt;
            
            if (nOpt==0) {
                
                fAvgPrice = (curGraphBody01.fAmount / nUnit) / curGraphBody01.fVolume;
            }
            else
            {
                fAvgPrice = (curGraphBody01.fAmount*nUnit) / curGraphBody01.fVolume;
            }
            
        }

        
        float fLastPrice = curGraphBody01.fLatestPrice;
        
        objTimeShare.strAvgPrice = [NSString stringWithFormat:[NSString stringWithFormat:@"%%.%ldf", (long)merpObj.nPrecision],fAvgPrice];
        
        objTimeShare.strNowPrice = [NSString stringWithFormat:[NSString stringWithFormat:@"%%.%ldf", (long)merpObj.nPrecision],curGraphBody01.fLatestPrice];
        
        objTimeShare.strAllTranNum = [NSString stringWithFormat:@"%d", (int)curGraphBody01.fVolume];
        
        if (i == 0)//第一个Item
        {
            objTimeShare.strMaxPrice = [NSString stringWithFormat:[NSString stringWithFormat:@"%%.%ldf", (long)merpObj.nPrecision],fLastPrice];
            
            objTimeShare.strMinPrice = [NSString stringWithFormat:[NSString stringWithFormat:@"%%.%ldf", (long)merpObj.nPrecision],fLastPrice];
            
        }
        else
        {
            int j = i - 1;
            TimeShare_Obj * objTimeShare_Old = fenbiGraphData.arrayGraphDate_Obj[j];
            
            float fOldMaxPrice = [objTimeShare_Old.strMaxPrice floatValue];
            float fOldMinPrice = [objTimeShare_Old.strMinPrice floatValue];
            
            if (fLastPrice > fOldMaxPrice)
            {
                objTimeShare.strMaxPrice = [NSString stringWithFormat:[NSString stringWithFormat:@"%%.%ldf", (long)merpObj.nPrecision],fLastPrice];
            }
            else
            {
                objTimeShare.strMaxPrice = [NSString stringWithFormat:[NSString stringWithFormat:@"%%.%ldf", (long)merpObj.nPrecision],fOldMaxPrice];
            }
            
            if (fLastPrice < fOldMinPrice)
            {
                objTimeShare.strMinPrice = [NSString stringWithFormat:[NSString stringWithFormat:@"%%.%ldf", (long)merpObj.nPrecision],fLastPrice];
            }
            else
            {
                objTimeShare.strMinPrice = [NSString stringWithFormat:[NSString stringWithFormat:@"%%.%ldf", (long)merpObj.nPrecision],fOldMinPrice];
            }
            
        }
        
        objTimeShare.nTime = curGraphBody01.time;
        objTimeShare.strTime = [[NetWorkManager sharedInstance] getStrFromSec:curGraphBody01.time];
        
        objTimeShare.strTime_Old = [[NetWorkManager sharedInstance] getStrFromSec:curGraphBody01.time];
        
        
        [fenbiGraphData.arrayGraphDate_Obj addObject:objTimeShare];
    }
    
    objGraphData.arrayGraphDate_Obj = fenbiGraphData.arrayGraphDate_Obj;
    
    [self defargTimeShareMsg:objGraphData AndMinute:1];
    
    [self addNullDataForTimeShareMsg:objGraphData AndMinute:1];
    
    [self defargTimeShareMsg_DeleteCloseTime:objGraphData];
    
    //整理完成回到主线程更新界面
    [self performSelectorOnMainThread:@selector(completeHandleData:) withObject:fenbiGraphData waitUntilDone:NO];
    
    //处理完成退出当前线程
    [NSThread exit];
}
//整理一分钟数据
- (void) defargTimeShareMsg:(GraphResponse *) objGraphData AndMinute:(int)nMinute
{
    int nSec = nMinute * 60;
    
    NSMutableArray * arrayTmp = objGraphData.arrayGraphDate_Obj;
    
    if (arrayTmp.count <= 0 )
        return;
    
    NSMutableArray * arrayNew = [[NSMutableArray alloc] init];
    
    // objGraphData.arrayGraphDate_Obj
    
    for (int i = 0; i < (arrayTmp.count - 1 ) ; i++)
    {
        
        if ([[NSThread currentThread] isCancelled]) {
            [NSThread exit];
        }
        
        int j = i + 1;
        
        TimeShare_Obj * objTimeShare_i = arrayTmp[i];
        TimeShare_Obj * objTimeShare_j = arrayTmp[j];
        
        NSInteger nTime_i = objTimeShare_i.nTime;
        NSInteger nTime_j = objTimeShare_j.nTime;
        
        nTime_i = (nTime_i / nSec) * nSec;
        nTime_j = (nTime_j / nSec) * nSec;
        
        if (nTime_i == nTime_j)
        {
            float fMaxPrice_i = [objTimeShare_i.strMaxPrice floatValue];
            float fMaxPrice_j = [objTimeShare_j.strMaxPrice floatValue];
            
            if (fMaxPrice_i > fMaxPrice_j)
                objTimeShare_j.strMaxPrice = objTimeShare_i.strMaxPrice;
            
            float fMinPrice_i = [objTimeShare_i.strMinPrice floatValue];
            float fMinPrice_j = [objTimeShare_j.strMinPrice floatValue];
            
            if (fMinPrice_i < fMinPrice_j)
                objTimeShare_j.strMinPrice = objTimeShare_i.strMinPrice;
            
            objTimeShare_j.nTime = nTime_j;
            objTimeShare_j.strTime = [[NetWorkManager sharedInstance] getStrFromSec:nTime_j];
            
            
            if (j == (arrayTmp.count - 1))
                [arrayNew addObject:objTimeShare_j];
            
        }
        else
        {
            objTimeShare_i.strTime = [[NetWorkManager sharedInstance] getStrFromSec:nTime_i];
            objTimeShare_i.nTime = nTime_i;
            
            [arrayNew addObject:objTimeShare_i];
            objTimeShare_j.strTime = [[NetWorkManager sharedInstance] getStrFromSec:nTime_j];
            objTimeShare_j.nTime = nTime_j;
            if (j == (arrayTmp.count - 1))
                [arrayNew addObject:objTimeShare_j];
        }
        
    }
    
    objGraphData.nCount = arrayNew.count;
    
    objGraphData.arrayGraphDate_Obj = arrayNew;
}

- (BOOL) isInOpenTime:(NSArray *) arrayPoint AndIndex:(int) nIndex
{
    for (OpenTimePointObj * objOpenTimePoint in arrayPoint)
    {
        int nBegin = objOpenTimePoint.nBegin;
        int nEnd = objOpenTimePoint.nEnd;
        
        if (nIndex >= nBegin && nIndex <= nEnd)
            return YES;
    }
    
    
    return NO;
}

-(void) defargTimeShareMsg_DeleteCloseTime:(GraphResponse *) objGraphData
{
    //首先取得最后一个报价的时间
    NSMutableArray * arrayTmp = objGraphData.arrayGraphDate_Obj;
    
    if (arrayTmp.count < 1)
        return;
    
    NSMutableArray * arrayNew = [[NSMutableArray alloc] init];
    
    TimeShare_Obj * objTimeShare_Last = arrayTmp[arrayTmp.count -1];
    
    NSTimeInterval nTime = objTimeShare_Last.nTime;
    
    //取得开盘时间段的点 array
    MerpList_Obj*merpObj = [[CTradeClientSocket sharedInstance] merpListObjWithMpcode:objGraphData.strProductCode marketId:objGraphData.strMarketID];

    NSString *strMapID = [NSString stringWithFormat:@"%ld", (long)merpObj.nIndex];
    
    NSArray * arrayPoint = [[CTradeClientSocket sharedInstance] getOpenTimePiontArrayFromMapId:strMapID AndTime:nTime];
    
    // 遍历原始的Array数据，生成新array
    for (int i = 0; i < arrayTmp.count ; i++)
    {
        
        if ([[NSThread currentThread] isCancelled]) {
            [NSThread exit];
        }
        
        BOOL bInOpenTime = [self isInOpenTime:arrayPoint AndIndex:i];
        
        if(bInOpenTime)
        {
            [arrayNew addObject:arrayTmp[i]];
            
        }
        
        
    }
    
    objGraphData.nCount = arrayNew.count;
    
    objGraphData.arrayGraphDate_Obj = arrayNew;
    
    
}
- (void) addNullDataForTimeShareMsg:(GraphResponse *) objGraphData AndMinute:(int) nMinute
{
    int nSec = nMinute * 60;
    
    NSMutableDictionary * dicTmp = [[NSMutableDictionary alloc] init];
    
    MerpList_Obj*merpObj = [[CTradeClientSocket sharedInstance] merpListObjWithMpcode:objGraphData.strProductCode marketId:objGraphData.strMarketID];
    NSInteger nMapID = merpObj.nIndex;

    NSString * strMapID = [NSString stringWithFormat:@"%ld", (long)nMapID];
    
    //获取最后一个图新数据
    NSArray * arrayGraphDate = objGraphData.arrayGraphDate_Obj;
    
    if (arrayGraphDate.count <= 0)
        return;
    
    TimeShare_Obj * objTimeShare = arrayGraphDate[arrayGraphDate.count -1];
    
    
    OpenCloseTime_Obj *obj_OpenCloseTime = [[CTradeClientSocket sharedInstance] getOpenCloseTime_Obj:objTimeShare.nTime AndMapID:strMapID];
    
    NSString *strOpenTime = obj_OpenCloseTime.strOpentime;
    
    NSDate * dateOpen = [[NetWorkManager sharedInstance] getDateFromStr:strOpenTime AndFormatter:const_Trader_strTimeFormatter_YMDHMS];
    
    NSTimeInterval nOpen = [dateOpen timeIntervalSince1970];
    
    NSTimeInterval nClose = objTimeShare.nTime;
    
    NSMutableArray * arrayNew = [[NSMutableArray alloc] init];
    
    NSMutableArray * arrayTmp = objGraphData.arrayGraphDate_Obj;
    
    for (TimeShare_Obj * objTimeShare in arrayTmp)
    {
        [dicTmp setObject:objTimeShare forKey:[NSNumber numberWithInteger:objTimeShare.nTime]];
        
    }
    
    for (int  i = nOpen , nIndex = 0; i <= nClose; i= i+ nSec, nIndex++)
    {
        
        if ([[NSThread currentThread] isCancelled]) {
            [NSThread exit];
        }
        
        
        TimeShare_Obj * objTimeShare = [dicTmp objectForKey:[NSNumber numberWithInt:i]];
        
        if (objTimeShare == nil)
        {
            if (i == nOpen)//第一笔就没有数据，使用昨收价格
            {
                NSString *strMarketID = objGraphData.strMarketID;
                NSString *strProductCode = objGraphData.strProductCode;
                
                NSString *strClosePrice = [[CTradeClientSocket sharedInstance] getClosePrice:strProductCode marketID:strMarketID];
                
                objTimeShare = [[TimeShare_Obj alloc] init];
                objTimeShare.nTime = i;
                objTimeShare.strTime = [[NetWorkManager sharedInstance] getStrFromSec:i];
                objTimeShare.strAllTranNum = @"0";
                
                objTimeShare.strAvgPrice = strClosePrice;
                objTimeShare.strMaxPrice = strClosePrice;
                objTimeShare.strMinPrice = strClosePrice;
                objTimeShare.strNowPrice = strClosePrice;
                
            }
            else
            {
                int j = nIndex - 1;
                
                
                //获取前一个时间的数据对象
                TimeShare_Obj * objTimeShare_j = arrayNew[j];
                
                objTimeShare = [[TimeShare_Obj alloc] init];
                objTimeShare.nTime = i;
                objTimeShare.strTime = [[NetWorkManager sharedInstance] getStrFromSec:i];
                
                objTimeShare.strAllTranNum = objTimeShare_j.strAllTranNum;
                
                objTimeShare.strAvgPrice = objTimeShare_j.strAvgPrice;
                objTimeShare.strMaxPrice = objTimeShare_j.strMaxPrice;
                objTimeShare.strMinPrice = objTimeShare_j.strMinPrice;
                objTimeShare.strNowPrice = objTimeShare_j.strNowPrice;
            }

            
        }
        else
        {
            
            
        }
        
        [arrayNew addObject:objTimeShare];
        
    }
    
    objGraphData.nCount = arrayNew.count;
    
    objGraphData.arrayGraphDate_Obj = arrayNew;
}



-(void) completeHandleData:(GraphResponse *) objGraphData
{
    
    [[CSocketListenerManager sharedInstance] callBack:PROTOCOL_SEL(TimeShareGraph) withObjcet:objGraphData];

    
}


-(void) parseFenBi7005Msg:(GraphResponse *) objGraphData{
    if(self.bDrawTimeShare){
        if (![[objGraphData.arrayGraphDate_Obj firstObject] isKindOfClass:[TimeShare_Obj class]]) {
            NSMutableArray *arrayTimeShare = [NSMutableArray array];
            for (FenBi7005Data_Obj *obj_Fenbi in objGraphData.arrayGraphDate_Obj) {
                TimeShare_Obj *obj_TimeShare = [[NetWorkManager sharedInstance] fenbi7005ConvertToTimeShare:obj_Fenbi];
                [arrayTimeShare addObject:obj_TimeShare];
                
            }
            objGraphData.arrayGraphDate_Obj = arrayTimeShare;
        }
        [self addNullDataForTimeShareMsg:objGraphData AndMinute:1];
        
        [self defargTimeShareMsg_DeleteCloseTime:objGraphData];
        [[CSocketListenerManager sharedInstance] callBack:PROTOCOL_SEL(TimeShareGraph) withObjcet:objGraphData];
        
    }else{
        [[CSocketListenerManager sharedInstance] callBack:PROTOCOL_SEL(7005Request) withObjcet:objGraphData];

    }

}

@end
