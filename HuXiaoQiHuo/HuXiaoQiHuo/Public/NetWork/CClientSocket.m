//
//  CClientSocket.m
//  HuXiaoQiHuo
//
//  Created by niupark on 16/5/19.
//  Copyright © 2016年 fukeng. All rights reserved.
//

#import "CClientSocket.h"
#import <objc/runtime.h>
@interface CClientSocket(){
    NSMutableData *reciveData;
    NSInteger _tryconnectCount;//尝试连接次数;
    BOOL _manualDiscount; //是否人工断开连接，如果被动则自动重连
    BOOL _bIsConnecting; //是否正在连接

}
@property GCDAsyncSocket * socket;
@end
@implementation CClientSocket

+ (instancetype)sharedInstance
{
    Class selfClass = [self class];
    id instance = objc_getAssociatedObject(selfClass, @"kOTSharedInstance");
    @synchronized(self){
        if (!instance)
        {
            instance = [[selfClass alloc] init];
            objc_setAssociatedObject(selfClass, @"kOTSharedInstance", instance, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
    return instance;
}

- (id) init{
    if((self = [super init])) {
        dispatch_queue_t queue = dispatch_queue_create("com.tt.socket.gcd", DISPATCH_QUEUE_CONCURRENT);
        self.socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:queue];

        
    }
    return self;
}
- (void) sendData:(NSString *)data{
    NSLog(@"socket--->socket：%@:%d 发送的数据%@",currenthost, currentport,data);

    NSMutableData *datas = [[NSMutableData alloc] initWithData:[data dataUsingEncoding:NSUTF8StringEncoding]];
    [datas appendBytes:"\r\n\r\n" length:4];
    
    [self.socket writeData:datas withTimeout:-1 tag:0];
    
}

-(void)dealloc{
    [self disconnect];
}
-(void)connect
{
    if (_bIsConnecting || self.socket.isConnected || _manualDiscount) {
        return;
    }
    _bIsConnecting = YES;
    dispatch_queue_t queue = dispatch_queue_create("com.tt.socket.gcd", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        //如果尝试次数大于5次则休息10秒连接
        while (!self.socket.isConnected &&!_manualDiscount) {
            //连接中
            if (!self.socket.isConnected && !self.socket.isDisconnected) {
                //正在连接中...
                sleep(5); //等待网络连接状态返回，此处实际上是超时时间，如果5m还没连接成功，则会启动重连机制
            }else{
                NSLog(@"socket--->尝试进行socket%@:%d服务连接...",currenthost, currentport);
                NSError *err = nil;
                if (![self.socket connectToHost:currenthost onPort:currentport error:&err]) {
                    NSLog(@"socket--->socket连接服务%@:%d 失败，失败原因：%@",currenthost, currentport, err);
                    //主动断开请求
                    if (_manualDiscount) {
                        break;
                    }
                    //睡眠1秒继续请求
                    _tryconnectCount++;
                    if (_tryconnectCount>5) {
                        NSLog(@"socket--->socket重启连接大于最大次数，5s之后继续连接..");
                        sleep(5);
                        _tryconnectCount = 0;
                    }else{
                        sleep(1);
                    }
                }else{
                    //注意：此处并不表示服务器已经连接成功。比如飞行模式下，会到这来，但是并没连接成功服务。
                    
                }
            }
            
        }
        _bIsConnecting = NO;
    });
    
}
-(BOOL)isConnected{
    return self.socket.isConnected;
}
-(void)connectToHost:(NSString *)host onPort:(uint16_t)port{
    currenthost = host;
    currentport = port;
    _manualDiscount = NO;
    [self connect];
}

- (void) disconnect{
    _manualDiscount = YES;
    [self.socket disconnect];
}


- (void) socket:(GCDAsyncSocket*)sock didConnectToHost:(NSString*)host port:(uint16_t)port
{
    NSLog(@"socket--->连接服务%@:%d 成功",host, port);
    _tryconnectCount = 0;
    _manualDiscount = NO;
    [self.socket readDataWithTimeout:-1 tag:1]; //开始接受数据
    [[CSocketListenerManager sharedInstance] callBack:PROTOCOL_SEL(SocketConnected) withObjcet:@{@"socket":self}];

}
//处理 socket返回数据
- (void) socket:(GCDAsyncSocket*)sock didReadData:(NSData*)data withTag:(long)tag{
    //NSLog(@"socket--->开始接受数据");
    if(reciveData == nil)
    {
        reciveData = [[NSMutableData alloc] init];
    }
    if (data != nil && [data length] != 0) {
        [reciveData appendData:data];
        [self handelReciveData:reciveData];
    }
    
    [sock readDataWithTimeout:-1 tag:0];
   // NSLog(@"socket--->接受完成数据");
    
}
-(void)socketDidDisconnect:(GCDAsyncSocket*)socket withError:(NSError *)err{
    //断线重连
    NSLog(@"socket: %@:%d --->断开连接了，或将重新连接",currenthost, currentport);
    [self connect];
}

//子类实现方法，返回数据结束字符串，缺省@"\r\n\r\n"
-(NSString*)symbolString{
    return @"\r\n\r\n";
}
-(void) handelReciveData:(NSMutableData *) data{
    NSString *gSymbol = [self symbolString];
    while (YES)
    {
        NSRange dataSearchLeftRange = NSMakeRange(0,data.length);
        
        NSRange findedRange = [data rangeOfData:[gSymbol dataUsingEncoding:NSASCIIStringEncoding] options:0 range:dataSearchLeftRange];
        
        if (findedRange.location == NSNotFound)
        {
            break;
        }
        NSRange deleteRange;
        deleteRange.location=0;
        deleteRange.length = findedRange.location + findedRange.length;
        
        NSData * subdata = [data subdataWithRange:deleteRange];
        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        NSString * str = [[NSString alloc] initWithData:subdata encoding:enc];
        NSLog(@"socket--->正在处理服务返回的数据:%@",str);
        [self handelSocketJSON:str];
        [data replaceBytesInRange:deleteRange withBytes: nil length:0];
    }

}
//子类实现方法接受数据
-(void)handelSocketJSON:(NSString*)jsonStr{
    
}
-(void)socket:(GCDAsyncSocket*)socket didWriteDataWithTag:(long)tag{
    NSLog(@"socket--->发送数据成功");
    
}


@end
