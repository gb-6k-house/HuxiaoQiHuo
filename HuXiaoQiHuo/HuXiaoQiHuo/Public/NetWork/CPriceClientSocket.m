//
//  CPriceClientSocket.m
//  HuXiaoQiHuo
//
//  Created by niupark on 16/5/26.
//  Copyright © 2016年 fukeng. All rights reserved.
//

#import "CPriceClientSocket.h"
#import "NetUtility.h"
#import "PriceStruct.h"
#import "PriceData_Obj.h"
#import "CTradeClientSocket.h"
@interface CPriceClientSocket()
@end
@implementation CPriceClientSocket

-(void)updateMarketInfoWithMpIndexs:(NSSet*)mpIndexs{
    NSMutableDictionary * dicPriceRequest = [[NSMutableDictionary alloc] init];
    [dicPriceRequest setObject:@"7004" forKey:@"cmdCode"];
    NSMutableArray *arry =  [NSMutableArray array];
    for (NSNumber *mpIndex in mpIndexs) {
        [arry addObject:mpIndex];
    }
    [dicPriceRequest setObject:arry forKey:@"mapID"];
    [self sendData:[NetWorkManager getJSONString:dicPriceRequest]];
}

-(void) handelReciveData:(NSMutableData *) data{
//    NSLog(@"socket--->socket连接服务%@:%d 收到行情数据，正在处理",currenthost, currentport);
    [self parsePriceMsgData:data];

}



-(void) parsePriceMsg:(PriceData_Obj *) ObjPriceMsg{
   //通知行情更新
    if (ObjPriceMsg.fClosePrice != 0) {
        ObjPriceMsg.fChg = (ObjPriceMsg.fLatestPrice-ObjPriceMsg.fClosePrice)/ObjPriceMsg.fClosePrice;
    }
    ObjPriceMsg.fChgPrice = ObjPriceMsg.fLatestPrice-ObjPriceMsg.fClosePrice;
    MerpList_Obj * merObj = [[CTradeClientSocket sharedInstance] merpListObjWithMpIndex:ObjPriceMsg.strMapID];
    merObj.priceObJ = ObjPriceMsg;
    [[CSocketListenerManager sharedInstance] callBack:PROTOCOL_SEL(NewPrice) withObjcet:ObjPriceMsg];
}
-(void) parsePriceMsgData:(NSMutableData *) data{
    NSUInteger nDataLen = [data length];
    NSUInteger nDeletRangLen = 0;
    NSRange deleteRange;
    deleteRange.location=0;
    deleteRange.length = 0;
    
    char cType;
    
    while (nDataLen >= 1)
    {
        [data getBytes:&cType length:sizeof(cType)];
        
        switch (cType)
        {
            case ResponseType_Heart:
            {
                nDeletRangLen = sizeof(cType);
                
                deleteRange.length = nDeletRangLen;
                
                nDataLen = nDataLen - nDeletRangLen;
                
                //yifei 保护replaceBytesInRange
                if (data.length < nDeletRangLen)
                {
                    nDeletRangLen = data.length;
                    
                    deleteRange.length = nDeletRangLen;
                    
                    nDataLen = nDataLen - nDeletRangLen;
                    
                    NSLog(@"保护ResponseType_Heart");
                    
                    break;
                    
                }
                
                
                [data replaceBytesInRange:deleteRange withBytes: nil length:0];
                
                break;
            }
                
            case ResponseType_Price02:
            {
                //处理头结构，删除数据中的头结构长度数据
                
                Head_st curHead_st;
                
                if( nDataLen < sizeof(curHead_st))
                    return;
                
                [data getBytes:&curHead_st length:sizeof(curHead_st)];
                
                nDeletRangLen = sizeof(curHead_st);
                
                deleteRange.length = nDeletRangLen;
                
                nDataLen = nDataLen - nDeletRangLen;
                
                //yifei 保护replaceBytesInRange
                if (data.length < nDeletRangLen)
                {
                    nDeletRangLen = data.length;
                    
                    deleteRange.length = nDeletRangLen;
                    
                    nDataLen = nDataLen - nDeletRangLen;
                    
                    NSLog(@"保护ResponseType_Price02");
                    
                    break;
                    
                }
                
                
                [data replaceBytesInRange:deleteRange withBytes: nil length:0];
                
                
                //开始处理Body数据
                
                PriceBody02_st curPrice02Body ;
                
                for (int i=0; i < curHead_st.count; i++)
                {
                    [data getBytes:&curPrice02Body length:sizeof(curPrice02Body)];
                    
                    nDeletRangLen = sizeof(curPrice02Body);
                    
                    deleteRange.length = nDeletRangLen;
                    
                    nDataLen = nDataLen - nDeletRangLen;
                    
                    //yifei 保护replaceBytesInRange
                    if (data.length < nDeletRangLen)
                    {
                        nDeletRangLen = data.length;
                        
                        deleteRange.length = nDeletRangLen;
                        
                        nDataLen = nDataLen - nDeletRangLen;
                        
                        NSLog(@"保护PriceBody02_st");
                        
                        break;
                    }
                    
                    [data replaceBytesInRange:deleteRange withBytes: nil length:0];
                    
                    PriceData_Obj * objPriceData = [CTradeClientSocket sharedInstance].dicPriceData[[NSString stringWithFormat:@"%d", curPrice02Body.mapID]];
                    if (!objPriceData) {
                        objPriceData = [[PriceData_Obj alloc] init];
                        [[CTradeClientSocket sharedInstance].dicPriceData setObject:objPriceData forKey:[NSString stringWithFormat:@"%d", curPrice02Body.mapID]];
                    }
                    objPriceData.strMapID = [NSString stringWithFormat:@"%d", curPrice02Body.mapID];
                    objPriceData.fLatestPrice = curPrice02Body.fLatestPrice;
                    objPriceData.fLatestBuyPrice = curPrice02Body.fLatestBuyPrice;
                    objPriceData.fHighestPrice = curPrice02Body.fHighestPrice;
                    objPriceData.fLowestPrice = curPrice02Body.fLowestPrice;
                    objPriceData.fOpenPrice = curPrice02Body.fOpenPrice;
                    objPriceData.fClosePrice = curPrice02Body.fClosePrice;
                    objPriceData.fVolume = curPrice02Body.fVolume;
                    objPriceData.fAmount = curPrice02Body.fAmount;
                    objPriceData.fBuyPrice1 = curPrice02Body.fBuyPrice[0];
                    objPriceData.fBuyPrice2 = curPrice02Body.fBuyPrice[1];
                    objPriceData.fBuyPrice3 = curPrice02Body.fBuyPrice[2];
                    objPriceData.fBuyPrice4 = curPrice02Body.fBuyPrice[3];
                    objPriceData.fBuyPrice5 = curPrice02Body.fBuyPrice[4];
                    
                    objPriceData.fBuyVolume1 = curPrice02Body.fBuyVolume[0];
                    objPriceData.fBuyVolume2 = curPrice02Body.fBuyVolume[1];
                    objPriceData.fBuyVolume3 = curPrice02Body.fBuyVolume[2];
                    objPriceData.fBuyVolume4 = curPrice02Body.fBuyVolume[3];
                    objPriceData.fBuyVolume5 = curPrice02Body.fBuyVolume[4];
                    
                    objPriceData.fSellPrice1 = curPrice02Body.fSellPrice[0];
                    objPriceData.fSellPrice2 = curPrice02Body.fSellPrice[1];
                    objPriceData.fSellPrice3 = curPrice02Body.fSellPrice[2];
                    objPriceData.fSellPrice4 = curPrice02Body.fSellPrice[3];
                    objPriceData.fSellPrice5 = curPrice02Body.fSellPrice[4];
                    
                    objPriceData.fSellVolume1 = curPrice02Body.fSellVolume[0];
                    objPriceData.fSellVolume2 = curPrice02Body.fSellVolume[1];
                    objPriceData.fSellVolume3 = curPrice02Body.fSellVolume[2];
                    objPriceData.fSellVolume4 = curPrice02Body.fSellVolume[3];
                    objPriceData.fSellVolume5 = curPrice02Body.fSellVolume[4];
                    
                    objPriceData.nTime = curPrice02Body.time;
                    
                    objPriceData.strTime = [[NetWorkManager sharedInstance] getStrFromSec:curPrice02Body.time];
                    
                    
                    [self parsePriceMsg:objPriceData];
                    
                }
                break;
            }
                
            case ResponseType_Price03:
            {
                //处理头结构，删除数据中的头结构长度数据
                
                Head_st curHead_st;
                
                if( nDataLen < sizeof(curHead_st))
                    return;
                
                [data getBytes:&curHead_st length:sizeof(curHead_st)];
                
                nDeletRangLen = sizeof(curHead_st);
                
                deleteRange.length = nDeletRangLen;
                
                nDataLen = nDataLen - nDeletRangLen;
                
                //yifei 保护replaceBytesInRange
                if (data.length < nDeletRangLen)
                {
                    nDeletRangLen = data.length;
                    
                    deleteRange.length = nDeletRangLen;
                    
                    nDataLen = nDataLen - nDeletRangLen;
                    
                    NSLog(@"保护ResponseType_Price03");
                    
                    break;
                }
                
                [data replaceBytesInRange:deleteRange withBytes: nil length:0];
                
                
                //开始处理Body数据
                
                PriceBody03_st curPrice03Body;
                
                for (int i=0; i < curHead_st.count; i++)
                {
                    [data getBytes:&curPrice03Body length:sizeof(curPrice03Body)];
                    
                    nDeletRangLen = sizeof(curPrice03Body);
                    
                    deleteRange.length = nDeletRangLen;
                    
                    nDataLen = nDataLen - nDeletRangLen;
                    
                    //yifei 保护replaceBytesInRange
                    if (data.length < nDeletRangLen)
                    {
                        nDeletRangLen = data.length;
                        
                        deleteRange.length = nDeletRangLen;
                        
                        nDataLen = nDataLen - nDeletRangLen;
                        
                        NSLog(@"保护PriceBody03_st");
                        
                        break;
                    }
                    
                    [data replaceBytesInRange:deleteRange withBytes: nil length:0];
                    
                    NSString * strMapID = [NSString stringWithFormat:@"%d", curPrice03Body.mapID];
                    
                    PriceData_Obj * objPriceData = [CTradeClientSocket sharedInstance].dicPriceData[strMapID];
                    if (!objPriceData) {
                        objPriceData = [[PriceData_Obj alloc] init];
                        [[CTradeClientSocket sharedInstance].dicPriceData setObject:objPriceData forKey:objPriceData.strMapID];
                    }
                    if (objPriceData != nil)
                    {
                        objPriceData.strMapID = strMapID;
                        
                        objPriceData.fBuyPrice1 = curPrice03Body.fBuyPrice[0];
                        objPriceData.fBuyPrice2 = curPrice03Body.fBuyPrice[1];
                        objPriceData.fBuyPrice3 = curPrice03Body.fBuyPrice[2];
                        objPriceData.fBuyPrice4 = curPrice03Body.fBuyPrice[3];
                        objPriceData.fBuyPrice5 = curPrice03Body.fBuyPrice[4];
                        
                        objPriceData.fBuyVolume1 = curPrice03Body.fBuyVolume[0];
                        objPriceData.fBuyVolume2 = curPrice03Body.fBuyVolume[1];
                        objPriceData.fBuyVolume3 = curPrice03Body.fBuyVolume[2];
                        objPriceData.fBuyVolume4 = curPrice03Body.fBuyVolume[3];
                        objPriceData.fBuyVolume5 = curPrice03Body.fBuyVolume[4];
                        
                        objPriceData.fSellPrice1 = curPrice03Body.fSellPrice[0];
                        objPriceData.fSellPrice2 = curPrice03Body.fSellPrice[1];
                        objPriceData.fSellPrice3 = curPrice03Body.fSellPrice[2];
                        objPriceData.fSellPrice4 = curPrice03Body.fSellPrice[3];
                        objPriceData.fSellPrice5 = curPrice03Body.fSellPrice[4];
                        
                        objPriceData.fSellVolume1 = curPrice03Body.fSellVolume[0];
                        objPriceData.fSellVolume2 = curPrice03Body.fSellVolume[1];
                        objPriceData.fSellVolume3 = curPrice03Body.fSellVolume[2];
                        objPriceData.fSellVolume4 = curPrice03Body.fSellVolume[3];
                        objPriceData.fSellVolume5 = curPrice03Body.fSellVolume[4];
                        
                        [self parsePriceMsg:objPriceData];
                        
                        
                    }
                    
                }
                
                
                
                break;
            }
                
            case ResponseType_Price04:
            {
                //处理头结构，删除数据中的头结构长度数据
                
                Head_st curHead_st;
                
                if( nDataLen < sizeof(curHead_st))
                    return;
                
                [data getBytes:&curHead_st length:sizeof(curHead_st)];
                
                nDeletRangLen = sizeof(curHead_st);
                
                deleteRange.length = nDeletRangLen;
                
                nDataLen = nDataLen - nDeletRangLen;
                
                //yifei 保护replaceBytesInRange
                if (data.length < nDeletRangLen)
                {
                    nDeletRangLen = data.length;
                    
                    deleteRange.length = nDeletRangLen;
                    
                    nDataLen = nDataLen - nDeletRangLen;
                    
                    NSLog(@"保护ResponseType_Price04");
                    
                    break;
                }
                [data replaceBytesInRange:deleteRange withBytes: nil length:0];
                
                
                //开始处理Body数据
                
                PriceBody04_st curPrice04Body;
                
                for (int i=0; i < curHead_st.count; i++)
                {
                    [data getBytes:&curPrice04Body length:sizeof(curPrice04Body)];
                    
                    nDeletRangLen = sizeof(curPrice04Body);
                    
                    deleteRange.length = nDeletRangLen;
                    
                    nDataLen = nDataLen - nDeletRangLen;
                    
                    //yifei 保护replaceBytesInRange
                    if (data.length < nDeletRangLen)
                    {
                        nDeletRangLen = data.length;
                        
                        deleteRange.length = nDeletRangLen;
                        
                        nDataLen = nDataLen - nDeletRangLen;
                        
                        NSLog(@"保护PriceBody04_st");
                        
                        break;
                    }
                    
                    [data replaceBytesInRange:deleteRange withBytes: nil length:0];
                    
                    NSString * strMapID = [NSString stringWithFormat:@"%d", curPrice04Body.mapID];
                    
                    PriceData_Obj * objPriceData = [CTradeClientSocket sharedInstance].dicPriceData[strMapID];
                    if (!objPriceData) {
                        objPriceData = [[PriceData_Obj alloc] init];
                        [[CTradeClientSocket sharedInstance].dicPriceData setObject:objPriceData forKey:objPriceData.strMapID];
                    }
                    
                    if (objPriceData != nil)
                    {
                        objPriceData.strMapID = strMapID;
                        objPriceData.nTime = curPrice04Body.time;
                        objPriceData.strTime = [[NetWorkManager sharedInstance] getStrFromSec:curPrice04Body.time];
                        objPriceData.fLatestPrice = curPrice04Body.fLatestPrice;
                        objPriceData.fLatestBuyPrice = curPrice04Body.fLatestBuyPrice;
                        
                        objPriceData.fVolume = curPrice04Body.fVolume;
                        objPriceData.fAmount = curPrice04Body.fAmount;

                        [self parsePriceMsg:objPriceData];
                        
                    }
                    
                    
                    
                }
                
                
                break;
            }
                
                //
            case ResponseType_Price06:
            {
                //处理头结构，删除数据中的头结构长度数据
                
                Head_st curHead_st;
                
                if( nDataLen < sizeof(curHead_st))
                    return;
                
                [data getBytes:&curHead_st length:sizeof(curHead_st)];
                
                nDeletRangLen = sizeof(curHead_st);
                
                deleteRange.length = nDeletRangLen;
                
                nDataLen = nDataLen - nDeletRangLen;
                
                //yifei 保护replaceBytesInRange
                if (data.length < nDeletRangLen)
                {
                    nDeletRangLen = data.length;
                    
                    deleteRange.length = nDeletRangLen;
                    
                    nDataLen = nDataLen - nDeletRangLen;
                    
                    NSLog(@"保护ResponseType_Price06");
                    
                    break;
                }
                
                [data replaceBytesInRange:deleteRange withBytes: nil length:0];
                
                
                //开始处理Body数据
                
                PriceBody06_st curPrice06Body;
                
                for (int i=0; i < curHead_st.count; i++)
                {
                    [data getBytes:&curPrice06Body length:sizeof(curPrice06Body)];
                    
                    nDeletRangLen = sizeof(curPrice06Body);
                    
                    deleteRange.length = nDeletRangLen;
                    
                    nDataLen = nDataLen - nDeletRangLen;
                    
                    //yifei 保护replaceBytesInRange
                    if (data.length < nDeletRangLen)
                    {
                        nDeletRangLen = data.length;
                        
                        deleteRange.length = nDeletRangLen;
                        
                        nDataLen = nDataLen - nDeletRangLen;
                        
                        NSLog(@"保护PriceBody06_st");
                        break;
                    }
                    
                    [data replaceBytesInRange:deleteRange withBytes: nil length:0];
                    
                    
                }
                
                break;
            }
                

            default:
            {
                nDataLen = 0;
                break;
            }
                
        }
        
    }
    
}

@end
