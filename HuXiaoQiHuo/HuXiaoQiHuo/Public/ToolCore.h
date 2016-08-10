//
//  ToolCore.h
//  IME
//
//  Created by zhangzhao on 13-9-22.
//  Copyright (c) 2013年 zhangzhao. All rights reserved.
//

#import <Foundation/Foundation.h>

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

@interface ToolCore : NSObject
+ (NSString *)getCurrentVersion;
+ (NSString *)makeHardwareUUID;
+ (NSString *)bytesToAvaiUnit:(double)bytes;
+ (long long) freeDiskSpaceInBytes;
+ (NSDate *)dateFromStr:(id)data;
+ (NSString *)strFromTimeStr2:(id)data format:(NSString *)format;
+ (NSString *)strFromTimeStr3:(id)data format:(NSString *)format;


//推算向后num天的时间
+ (NSDate *)dataBackNow:(NSInteger)num;
//推算向前num天的时间
+ (NSDate *)dataForwardNow:(NSInteger)num;

+ (NSString *)strFromTimeStr:(id)data format:(NSString *)format;
+ (NSArray *)dateArr;
+ (NSInteger)month;
+ (double)coordinateDistanceBylat1:(double)lat1 lng1:(double)lng1 lat2:(double)lat2 lng2:(double)lng2;
+ (CGSize)sizeForCurrentScreen;
+ (CGSize)sizeForPreferScreen;
+ (CGFloat)ratioForScreen;
+ (BOOL)compareDate:(NSString *)strBeginDate endDate :(NSString *)strEndDate;
+ (BOOL)validPhone:(NSString*)phone;//手机号码
+ (BOOL)validPassword:(NSString*)registPassword;//注册密码
+ (BOOL)validVerificationCode:(NSString*)verificationCode;//手机验证码
+ (BOOL)validNum:(NSString*)num;//数字
+ (BOOL)validateEmail:(NSString*)email;
+ (void)setViewRadio:(UIView*)view withRadio:(float)radio;  //设置View的圆角
+ (void)setViewDefaultRadio:(UIView*)view;  //设置View的圆角,默认5.0
+ (void)setButton:(UIButton*)btn Title:(NSString*) title subTitle:(NSString*) subTitle;
+ (void)showAlertViewWithTitle:(NSString *)title message:(NSString *)message;
+ (NSInteger)calcDaysFromBegin:(NSDate *)inBegin end:(NSDate *)inEnd;
+ (NSDate*) addSomeDayFromDate :(NSInteger)addDay beginTime:(NSString*)time;

@end
