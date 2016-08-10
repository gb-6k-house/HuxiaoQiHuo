//
//  NetWork.h
//  WashCar
//
//  Created by zhangzhao on 4/21/15.
//  Copyright (c) 2015 NiuPark. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^CompletionBlock)(NSDictionary *resultDic);
typedef void(^ErrorBlock)(NSDictionary *resultDic);
typedef enum {
    HttpRequstLoadingNone = -1,
    HttpRequstLoading,
    HttpRequstSubmit
} HttpRequstKind;

typedef NS_ENUM(NSInteger,HttpMethod){
    HttpMethodPost = 0,
    HttpMethodGet,
};



@interface NetWork : NSObject

+ (void)getDataWithServer:(NSString *)urlStr sendDic:(NSDictionary *)sendDic kind:(HttpRequstKind)kind tips:(NSString *)tips target:(UIViewController *)target userInfo:(NSDictionary *)userInfo  callback:(CompletionBlock)completionBlock errorCallback:(ErrorBlock)errorBlock;

+ (void)postDataWithServer:(NSString *)urlStr sendDic:(NSDictionary *)sendDic kind:(HttpRequstKind)kind tips:(NSString *)tips target:(UIViewController *)target userInfo:(NSDictionary *)userInfo  callback:(CompletionBlock)completionBlock errorCallback:(ErrorBlock)errorBlock;

+ (void)postFileDataWithServer:(NSString *)urlStr sendDic:(NSDictionary *)sendDic file:(NSString*)uploadFile image:(UIImage*)uploadImage kind:(HttpRequstKind)kind tips:(NSString *)tips target:(UIViewController *)target userInfo:(NSDictionary *)userInfo  callback:(CompletionBlock)completionBlock errorCallback:(ErrorBlock)errorBlock;
@end
