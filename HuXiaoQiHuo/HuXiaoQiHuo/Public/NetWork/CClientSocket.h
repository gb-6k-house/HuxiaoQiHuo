//
//  CClientSocket.h
//  HuXiaoQiHuo
//
//  Created by niupark on 16/5/19.
//  Copyright © 2016年 fukeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncSocket.h"
#import "Constants.h"
#import "CSocketListenerManager.h"
#import "NetWorkManager.h"
#import "GlobalValue.h"
/**
 socket请求基类
 * 长连接服务，启动之后就一直保持连接。
 * 若由于网络等原因断开了连接，则自动重新连接，尝试5次之后若仍然无法连接，则休息10秒钟继续尝试连接，直到连接成功
 - returns:
 */
@interface CClientSocket : NSObject<GCDAsyncSocketDelegate>{
    NSString *currenthost;
    uint16_t currentport;
}
@property(nonatomic, readonly)BOOL isConnected;
+ (instancetype)sharedInstance;
- (void) sendData:(NSString *)data;
- (void) connectToHost:(NSString *)host onPort:(uint16_t)port;
- (void) disconnect;
-(NSString*)symbolString;
@end
