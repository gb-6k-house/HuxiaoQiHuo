//
//  NetWork.m
//  WashCar
//
//  Created by zhangzhao on 4/21/15.
//  Copyright (c) 2015 NiuPark. All rights reserved.
//

#import "NetWork.h"
#import <netinet/in.h>
#include <netdb.h>
#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#include <arpa/inet.h>
#include <ifaddrs.h>
#include <sys/param.h>
#include <sys/mount.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import "HttpRequestLoadingView.h"
#import <CommonCrypto/CommonCryptor.h>
#import "AFNetworking.h"
@implementation NSString (URL)

- (NSString *)URLEncodedString
{
    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                                    (CFStringRef)self,
                                                                                                    (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",
                                                                                                    NULL,
                                                                                                    kCFStringEncodingUTF8));
    return encodedString;
}
@end
@implementation NetWork
+ (BOOL) connectedToNetwork {
    //创建零地址，0.0.0.0的地址表示查询本机的网络连接状态
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    //创建测试连接引用
    SCNetworkReachabilityRef defaultRouteReachability =
    SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    //获得连接的标志
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    //如果不能获取连接标志，则不能连接网络，直接返回
    if (!didRetrieveFlags){
        return NO;
    }
    //根据获得的连接标志进行判断
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    return (isReachable && !needsConnection) ? YES : NO;
}

+ (void)errorDeteal:(NSDictionary *)dic {
    NSString * strMess = @"";
    NSInteger tag = -1;
    if (dic == nil) {
        strMess = @"您的网络不可用，请检查您的设置";
    }else {
        strMess = [dic objectForKey:@"msg"];
    }
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:strMess delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    alert.tag = tag;
    [alert show];
}

+ (NSData *)addDESEncrypt:(NSData *)data WithKey:(NSString *)key {
    size_t plainTextBufferSize = [data length];
    const void *vplainText = (const void *)[data bytes];
    size_t movedBytes = 0;
    size_t bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    uint8_t *bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    
    const void *vkey = (const void *) [key UTF8String];
    
    const void *vinitVec = (const void *) [@"01234567" UTF8String];
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithm3DES,
                                          kCCOptionPKCS7Padding,
                                          vkey,
                                          kCCKeySize3DES,
                                          vinitVec,
                                          vplainText,
                                          plainTextBufferSize,
                                          (void *)bufferPtr,
                                          bufferPtrSize,
                                          &movedBytes);
    
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:bufferPtr length:movedBytes];
    }
    free(bufferPtr);
    return nil;
}

+ (void)dataFromServer:(NSString *)urlStr sendDic:(NSDictionary *)sendDic method:(HttpMethod)method kind:(HttpRequstKind)kind tips:(NSString *)tips target:(UIViewController *)target userInfo:(NSDictionary *)userInfo callback:(CompletionBlock)completionBlock errorCallback:(ErrorBlock)errorBlock{
    if ([NetWork connectedToNetwork]) {//115.29.15.140
        
        //get请求，将参数拼接
        
        
        NSURL * url = [NSURL URLWithString:[urlStr URLEncodedString]];
        NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url
                                                                  cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                        timeoutInterval:30.0];
        if(method == HttpMethodPost){
            [theRequest setHTTPMethod:@"POST"];
        }else {
            [theRequest setHTTPMethod:@"GET"];
        }
        if (sendDic != nil) {
            NSData * sendData = [NSJSONSerialization dataWithJSONObject:sendDic options:NSJSONWritingPrettyPrinted error:nil];
            [theRequest setHTTPBody:sendData];
        }
        //[theRequest setValue:@"charset=utf-8" forHTTPHeaderField:@"Content-Type"];
       // [theRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        HttpRequestLoadingView * vLoading = nil;
        if (kind > -1) {
            CGRect rc = CGRectZero;
            if (userInfo == nil) {
                rc = [UIScreen mainScreen].bounds;
            }else {
                rc = CGRectFromString(userInfo[@"RCFrame"]);
            }
            vLoading = [[HttpRequestLoadingView alloc] initWithFrame:rc kind:kind tips:tips];
            [target.view addSubview:vLoading];
        }

        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:theRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            id obj = nil;
            if (data) {
                NSError * err;
                obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&err];
                //
                NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"%@ 服务返回 :%@", urlStr, json);
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [vLoading removeFromSuperview];
                // 更新界面
                if (obj != nil && [[obj objectForKey:@"code"] integerValue] == 0) {
                    if (completionBlock != nil) {
                        completionBlock(obj);
                    }
                }else {
                    if (errorBlock != nil) {
                        errorBlock(obj);
                    }
                    [NetWork errorDeteal:obj];
                }
            });
        }];
        // 使用resume方法启动任务
        [dataTask resume];
    }else {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您的网络不可用，请检查您的设置" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}
+(void)handelJSONResponse:(NSURLSessionDataTask *) task data:(NSData*)jsonData callback:(CompletionBlock)completionBlock errorCallback:(ErrorBlock)errorBlock{
    id obj = nil;
    if (jsonData) {
        NSError * err;
        obj = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
        //
        NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"%@ 服务返回 :%@",[task.currentRequest.URL absoluteString] , json);
    }
    if (obj != nil && [[obj objectForKey:@"code"] integerValue] == 0) {
        if (completionBlock != nil) {
            completionBlock(obj);
        }
    }else {
        if (errorBlock != nil) {
            errorBlock(obj);
        }
        [NetWork errorDeteal:obj];
    }
}

+ (void)AFDataFromServer:(NSString *)urlStr sendDic:(NSDictionary *)sendDic method:(HttpMethod)method kind:(HttpRequstKind)kind tips:(NSString *)tips target:(UIViewController *)target userInfo:(NSDictionary *)userInfo callback:(CompletionBlock)completionBlock errorCallback:(ErrorBlock)errorBlock{
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 实际上就是AFN没有对响应数据做任何处理的情况
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
   
    //NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:@"GET" URLString:self.url  parameters:nil error:nil];
    //设置超时
    [manager.requestSerializer setTimeoutInterval:30];
    HttpRequestLoadingView * vLoading = nil;
    if (kind > -1) {
        CGRect rc = CGRectZero;
        if (userInfo == nil) {
            rc = [UIScreen mainScreen].bounds;
        }else {
            rc = CGRectFromString(userInfo[@"RCFrame"]);
        }
        vLoading = [[HttpRequestLoadingView alloc] initWithFrame:rc kind:kind tips:tips];
        [target.view addSubview:vLoading];
    }
    if (method == HttpMethodGet) {
            [manager GET:urlStr parameters:sendDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [vLoading removeFromSuperview];
                [self handelJSONResponse:task data:responseObject callback:completionBlock errorCallback:errorBlock];
                ;
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [vLoading removeFromSuperview];
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您的网络不可用，请检查您的设置" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }];
    }else{
        [manager POST:urlStr parameters:sendDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [vLoading removeFromSuperview];
                [self handelJSONResponse:task data:responseObject callback:completionBlock errorCallback:errorBlock];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [vLoading removeFromSuperview];
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您的网络不可用，请检查您的设置" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }];
    }

}

+ (void)getDataWithServer:(NSString *)urlStr sendDic:(NSDictionary *)sendDic kind:(HttpRequstKind)kind tips:(NSString *)tips target:(UIViewController *)target userInfo:(NSDictionary *)userInfo  callback:(CompletionBlock)completionBlock errorCallback:(ErrorBlock)errorBlock{
    [self AFDataFromServer:urlStr sendDic:sendDic method:HttpMethodGet kind:kind tips:tips target:target userInfo:userInfo callback:completionBlock errorCallback:errorBlock];
}

+ (void)postDataWithServer:(NSString *)urlStr sendDic:(NSDictionary *)sendDic kind:(HttpRequstKind)kind tips:(NSString *)tips target:(UIViewController *)target userInfo:(NSDictionary *)userInfo  callback:(CompletionBlock)completionBlock errorCallback:(ErrorBlock)errorBlock{
    [self AFDataFromServer:urlStr sendDic:sendDic method:HttpMethodPost kind:kind tips:tips target:target userInfo:userInfo callback:completionBlock errorCallback:errorBlock];
}

+ (void)postFileDataWithServer:(NSString *)urlStr sendDic:(NSDictionary *)sendDic file:(NSString*)uploadFile image:(UIImage*)uploadImage kind:(HttpRequstKind)kind tips:(NSString *)tips target:(UIViewController *)target userInfo:(NSDictionary *)userInfo  callback:(CompletionBlock)completionBlock errorCallback:(ErrorBlock)errorBlock{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 15.0f;
    [manager POST:@"http://121.43.232.204:8098/ashx/uploadImg.ashx?action=upload" parameters:sendDic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData *imageData = UIImagePNGRepresentation(uploadImage);
        [formData appendPartWithFileData:imageData name:@"fsource" fileName:@"fsource" mimeType:@"image/png"];
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        completionBlock(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"上传图片失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }];
}

@end
