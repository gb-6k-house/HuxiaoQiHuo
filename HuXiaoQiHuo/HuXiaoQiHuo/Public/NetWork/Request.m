//
//  Request.m
//  HuXiaoQiHuo
//
//  Created by niupark on 16/5/19.
//  Copyright © 2016年 fukeng. All rights reserved.
//

#import "Request.h"
#import <CommonCrypto/CommonDigest.h>
#import "NetWorkManager.h"
@implementation Request

-(Request *) initWithCmd:(int )Cmd AndSID:(int )SID
{
    if (self = [super init])
    {
        dicHead = [[NSMutableDictionary alloc] init];
        [dicHead setValue:[NSNumber numberWithInt:Cmd] forKey:@"cmd"];
        [dicHead setValue:[NSNumber numberWithInt:-1] forKey:@"UID"];
        [dicHead setValue:[NSNumber numberWithInt:SID] forKey:@"SID"];
        
        dicPara = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

-(NSString *)getParaString
{
    NSString *jsonStr = [NetWorkManager getJSONString:dicPara];
    return jsonStr;
}

-(NSString *)getJSONString
{
    [dicHead setValue:dicPara forKey:@"para"];
    NSString *jsonStr = [NetWorkManager getJSONString:dicHead];
    jsonStr = [ self handleJsonString:jsonStr];
    return jsonStr;
    
}
//祛除json字符串中得\n
-  (NSString *) handleJsonString:(NSString *)json
{
    NSString *strJson  = [json stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    return strJson;
}


+(NSString *) getMD5:(NSString *)input
{
    const char *cStr = [input cStringUsingEncoding:NSUTF8StringEncoding];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, [input length], result );
    NSMutableString *hash = [NSMutableString string];
    for(int i=0;i<CC_MD5_DIGEST_LENGTH;i++)
    {
        [hash appendFormat:@"%02X",result[i]];
    }
    
    return [NSString stringWithString:hash];
}

+(NSString *) getPassword:(NSString *)input
{
    const char *cStr = [input cStringUsingEncoding:NSUTF16StringEncoding];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, [input length]*2, result );
    NSMutableString *hash = [NSMutableString string];
    for(int i=0;i<CC_MD5_DIGEST_LENGTH;i++)
    {
        [hash appendFormat:@"%02X-",result[i]];
    }
    [hash deleteCharactersInRange:NSMakeRange([hash length]-1, 1)];
    
    return [NSString stringWithString:hash];
}

+(NSString *) getCheck:(NSString *)input
{
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5([input cStringUsingEncoding:NSASCIIStringEncoding], (unsigned int)[input length], result );
    NSMutableString *hash = [NSMutableString string];
    for(int i=0;i<CC_MD5_DIGEST_LENGTH;i++)
    {
        [hash appendFormat:@"%02x",result[i]];
    }
    
    return [hash substringWithRange:NSMakeRange(15, 5)];
}
@end
