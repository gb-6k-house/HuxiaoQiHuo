//
//  ToolCore.m
//  IME
//
//  Created by zhangzhao on 13-9-22.
//  Copyright (c) 2013年 zhangzhao. All rights reserved.
//

#import "ToolCore.h"
#include <sys/param.h>
#include <sys/mount.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <CoreLocation/CoreLocation.h>

@import AdSupport;
@implementation ToolCore
#pragma mark Factory Method
+ (NSString *)makeHardwareUUID {
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    CFStringRef uuidStr = CFUUIDCreateString(NULL, uuid);
    NSString * result = [NSString stringWithFormat:@"%@",uuidStr];
    CFRelease(uuidStr);
    CFRelease(uuid);
    return result;
}

+ (NSString *)getCurrentVersion {
    NSString * strPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"Info.plist"];
    NSDictionary * dicInfo = [NSDictionary dictionaryWithContentsOfFile:strPath];
    NSString * strVersion = [dicInfo objectForKey:@"CFBundleShortVersionString"];
    return strVersion;
}

+ (NSString *)bytesToAvaiUnit:(double)bytes{
    if(bytes < 1024)                // B
    {
        return [NSString stringWithFormat:@"%lf B", bytes];
    }
    else if(bytes >= 1024 && bytes < 1024 * 1024)        // KB
    {
        return [NSString stringWithFormat:@"%.2f KB", (double)bytes / 1024];
    }
    else if(bytes >= 1024 * 1024 && bytes < 1024 * 1024 * 1024)        // MB
    {
        return [NSString stringWithFormat:@"%.2f MB", (double)bytes / (1024 * 1024)];
    }
    else        // GB
    {
        return [NSString stringWithFormat:@"%.2f GB", (double)bytes / (1024 * 1024 * 1024)];
    }
}

+ (long long) freeDiskSpaceInBytes{
    struct statfs buf;
    long long freespace = -1;
    if(statfs("/var", &buf) >= 0){
        freespace = (long long)(buf.f_bsize * buf.f_bfree) - (200 * 1024*1024);//减去200M安全区域
    }
    return freespace;
}
+ (NSDate *)dataBackNow:(NSInteger)num{
    NSDate*nowDate = [NSDate date];
    NSDate* theDate;
    if (num != 0) {
         NSTimeInterval  oneDay = 24*60*60*1;  //1天的长度
        theDate = [nowDate initWithTimeIntervalSinceNow: -oneDay*num];
    }else{
        theDate =  nowDate;
    }
    return theDate;
}
//推算向前num天的时间
+ (NSDate *)dataForwardNow:(NSInteger)num{
    NSDate*nowDate = [NSDate date];
    NSDate* theDate;
    if (num != 0) {
        NSTimeInterval  oneDay = 24*60*60*1;  //1天的长度
        theDate = [nowDate initWithTimeIntervalSinceNow: +oneDay*num];
    }else{
        theDate =  nowDate;
    }
    return theDate;

}

+ (NSDate *)dateFromStr:(id)data {
    NSString * str = [NSString stringWithFormat:@"%@",data];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd'T'HH:mm:ss"];
    return [dateFormatter dateFromString:str];
}
+ (NSDate *)dateFromStr2:(id)data {
    NSString * str = [NSString stringWithFormat:@"%@",data];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    return [dateFormatter dateFromString:str];
}
+ (NSDate *)dateFromStr3:(id)data {
    NSString * str = [NSString stringWithFormat:@"%@",data];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss Z"];
    return [dateFormatter dateFromString:str];
}
+ (NSString *)strFromTimeStr:(id)data format:(NSString *)format{
    NSDate * d = [ToolCore dateFromStr:data];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    return [dateFormatter stringFromDate:d];
}
+ (NSString *)strFromTimeStr2:(id)data format:(NSString *)format{
    NSDate * d = [ToolCore dateFromStr2:data];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    return [dateFormatter stringFromDate:d];
}

+ (NSString *)strFromTimeStr3:(id)data format:(NSString *)format{
    NSDate * d = [ToolCore dateFromStr3:data];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    return [dateFormatter stringFromDate:d];
}

+ (NSArray *)dateArr {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:[NSDate date]];
    NSInteger year = [components year];
    NSMutableArray * arrYear = [NSMutableArray arrayWithObject:@"2014年"];
    for (NSInteger i = 2014; i < year; i++) {
        [arrYear addObject:[NSString stringWithFormat:@"%ld年",(long)i+1]];
    }
    return @[arrYear,@[@"1月",@"2月",@"3月",@"4月",@"5月",@"6月",@"7月",@"8月",@"9月",@"10月",@"11月",@"12月",]];
}

+ (NSInteger)month{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitMonth fromDate:[NSDate date]];
    return  [components month];
}

+ (BOOL)compareDate:(NSString *)strBeginDate endDate :(NSString *)strEndDate {
    NSDate * dateToday = [NSDate date];
    NSDate * dateBegin = [ToolCore dateFromStr:strBeginDate];
    NSDate * dateEnd = [ToolCore dateFromStr:strEndDate];
    NSComparisonResult begin = [dateToday compare:dateBegin];
    NSComparisonResult end = [dateToday compare:dateEnd];
    return (begin == NSOrderedDescending && end == NSOrderedAscending);
}

+ (double)coordinateDistanceBylat1:(double)lat1 lng1:(double)lng1 lat2:(double)lat2 lng2:(double)lng2 {
    CLLocation *orig = [[CLLocation alloc] initWithLatitude:lat1 longitude:lng1];
    CLLocation *dist = [[CLLocation alloc] initWithLatitude:lat2 longitude:lng2];
    CLLocationDistance kilometers = [orig distanceFromLocation:dist]/1000;
    return kilometers;
}

+ (CGSize)sizeForCurrentScreen {
    return [UIScreen mainScreen].bounds.size;
}

+ (CGSize)sizeForPreferScreen {
    return [UIApplication sharedApplication].keyWindow.rootViewController.preferredContentSize;
}

+ (CGFloat)ratioForScreen {
    if ((NSInteger)[ToolCore sizeForPreferScreen].width == 0) {
        return 1.0;
    }else {
        return [ToolCore sizeForCurrentScreen].width / [ToolCore sizeForPreferScreen].width;
    }
}

+ (BOOL)validPhone:(NSString*)phone {
//    NSString *regex = @"^[1][234578][0-9]{9}$";
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
//    return [predicate evaluateWithObject:phone];
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:phone] == YES)
        || ([regextestcm evaluateWithObject:phone] == YES)
        || ([regextestct evaluateWithObject:phone] == YES)
        || ([regextestcu evaluateWithObject:phone] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }

}

+ (BOOL)validNum:(NSString*)num{
    NSString *regex = @"^[0-9]$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:num];
}

+ (BOOL)validPassword:(NSString*)password {
    NSString *regex = @"^[A-Za-z0-9]{6,30}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:password];
}

+ (BOOL)validVerificationCode:(NSString*)verificationCode {
    NSString *regex = @"^[0-9]{4}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:verificationCode];
}

+ (void)setViewRadio:(UIView*)view withRadio:(float)radio{
    view.layer.cornerRadius = radio;
    view.layer.masksToBounds = YES;
}
+ (void)setViewDefaultRadio:(UIView*)view{
    [ToolCore setViewRadio:view withRadio:5.0];
}


+(void)setButton:(UIButton*)btn Title:(NSString*) title subTitle:(NSString*) subTitle;{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n%@",title, subTitle]];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor YColorBlack] range:NSMakeRange(0,[title length])];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0] range:NSMakeRange(0,[title length])];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor YColorGray] range:NSMakeRange([title length],[subTitle length]+1)];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13.0] range:NSMakeRange([title length],[subTitle length]+1)];
    btn.titleLabel.numberOfLines = 0;
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [btn setAttributedTitle:str forState:UIControlStateNormal];
    
    //[btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    
}

+ (void)showAlertViewWithTitle:(NSString *)title message:(NSString *)message
{
    if (nil == title) {
        title = @"温馨提示";
    }
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
    [alertView show];
    
}

+(BOOL)validateEmail:(NSString*)email
{
    if((0 != [email rangeOfString:@"@"].length) &&
       (0 != [email rangeOfString:@"."].length))
    {
        NSCharacterSet* tmpInvalidCharSet = [[NSCharacterSet alphanumericCharacterSet] invertedSet]; NSMutableCharacterSet* tmpInvalidMutableCharSet = [tmpInvalidCharSet mutableCopy]; [tmpInvalidMutableCharSet removeCharactersInString:@"_-"];
        //使用compare option 来设定比较规则,如 //NSCaseInsensitiveSearch是不区分大小写
        //NSLiteralSearch 进行完全比较,区分大小写
        //NSNumericSearch 只比较定符串的个数,而不比较字符串的字面值
        NSRange range1 = [email rangeOfString:@"@"options:NSCaseInsensitiveSearch];
        //取得用户名部分
        NSString* userNameString = [email substringToIndex:range1.location];
        NSArray* userNameArray = [userNameString componentsSeparatedByString:@"."];
        for(NSString* string in userNameArray)
        {
            NSRange rangeOfInavlidChars = [string rangeOfCharacterFromSet: tmpInvalidMutableCharSet]; if(rangeOfInavlidChars.length != 0 || [string isEqualToString:@""])
                return NO;
        }
        NSString *domainString = [email substringFromIndex:range1.location+1]; NSArray *domainArray = [domainString componentsSeparatedByString:@"."];
        for(NSString *string in domainArray)
        {
            NSRange rangeOfInavlidChars=[string rangeOfCharacterFromSet:tmpInvalidMutableCharSet]; if(rangeOfInavlidChars.length !=0 || [string isEqualToString:@""])
                return NO;
        }
        return YES;
    }
    else // no ''@'' or ''.''present
        return NO;
}

//计算两个日期之间的天数
+(NSInteger) calcDaysFromBegin:(NSDate *)inBegin end:(NSDate *)inEnd
{
    NSInteger unitFlags = NSDayCalendarUnit| NSMonthCalendarUnit | NSYearCalendarUnit;
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [cal components:unitFlags fromDate:inBegin];
    NSDate *newBegin  = [cal dateFromComponents:comps];
    
    NSCalendar *cal2 = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps2 = [cal2 components:unitFlags fromDate:inEnd];
    NSDate *newEnd  = [cal2 dateFromComponents:comps2];

    NSTimeInterval interval = [newEnd timeIntervalSinceDate:newBegin];
    NSInteger beginDays=((NSInteger)interval)/(3600*24);
    
    return beginDays;
}

+(NSDate*) addSomeDayFromDate :(NSInteger)addDay beginTime:(NSString*)time{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *myDate = [dateFormatter dateFromString:time];
    NSDate *newDate = [myDate dateByAddingTimeInterval:60 * 60 * 24 * addDay];
    
    return newDate;
}

@end
