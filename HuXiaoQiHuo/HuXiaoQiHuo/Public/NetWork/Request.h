//
//  Request.h
//  HuXiaoQiHuo
//
//  Created by niupark on 16/5/19.
//  Copyright © 2016年 fukeng. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface Request : NSObject
{
    NSMutableDictionary *dicHead;
    NSMutableDictionary *dicPara;
}
+(NSString *) getMD5:(NSString *)input;
+(NSString *) getPassword:(NSString *)input;
+(NSString *) getCheck:(NSString *)input;
-(Request *) initWithCmd:(int)Cmd AndSID:(int)SID;
//获取协议负载部分数据的json字符串
-(NSString *) getParaString;
//获取请求协议头的json字符串
-(NSString *) getJSONString;
//祛除json字符串中得\n
-  (NSString *) handleJsonString:(NSString *)json;
@end