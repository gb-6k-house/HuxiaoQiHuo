//
//  CGraphManager.m
//  HuXiaoQiHuo
//
//  Created by niupark on 16/5/31.
//  Copyright © 2016年 fukeng. All rights reserved.
//

#import "CGraphManager.h"
#import "CGraphClientSocket.h"
#import "CTradeClientSocket.h"
#import "OpenCloseTime_Obj.h"
#import "NetWorkManager.h"
#import "CSocketListenerManager.h"
#import "GraphResponse.h"
#import "DBFileManager.h"
@interface CGraphManager()
@property (nonatomic, strong) CGraphClientSocket *gpSocket;
@property (nonatomic, retain) NSString * strGraphType;

@end
@implementation CGraphManager
+ (instancetype)sharedInstance
{
    static CGraphManager *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc ] init];
    });
    return _sharedInstance;
}

-(instancetype)init{
    self = [super init];
    if (self) {
        [[CSocketListenerManager sharedInstance] registerListener:self];
    }
    return self;
}
-(void)dealloc{
    [[CSocketListenerManager sharedInstance] unregisterListener:self];
}

-(void)getKLineDataByMpCode:(NSNumber*)mpIndex graphType:(NSString *)strGraphType{
    GraphServerObj * sv = [[CTradeClientSocket sharedInstance] graphServerByMpIndex:mpIndex];
    self.gpSocket = [[CGraphClientSocket alloc ] init];
    [self.gpSocket connectToHost:sv.GIP onPort:[sv.GPort intValue]];
    self.strGraphType = strGraphType;
    OpenCloseTime_Obj *obj_OpenCloseTime = [[CTradeClientSocket sharedInstance] getOpenCloseTime_Obj:[NetWorkManager sharedInstance].nCurTimeSec AndMapID:[mpIndex stringValue]];
    [self.gpSocket download1mGraphByMpIndex:mpIndex startTime:obj_OpenCloseTime.strOpentime endTime:obj_OpenCloseTime.strClosetime];

}
//K线图数据返回 GraphResponse
SOCKET_PROTOCOL(KGraph){
   }

@end
