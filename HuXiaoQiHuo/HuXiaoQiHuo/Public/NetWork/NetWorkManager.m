//
//  NetWorkManager.m
//  HuXiaoQiHuo
//
//  Created by niupark on 16/5/25.
//  Copyright © 2016年 fukeng. All rights reserved.
//

#import "NetWorkManager.h"
#import "Constants.h"
#import "FenBi7005Data_Obj.h"
#import "GraphData_M1.h"
#import "GraphData_M5.h"
#import "GraphData_M15.h"
#import "GraphData_M30.h"
#import "GraphData_H1.h"
#import "GraphData_H4.h"
#import "GraphData_D1.h"
#import "GraphData_W1.h"
#import "GraphData_MN.h"

@implementation NetWorkManager

+ (instancetype)sharedInstance
{
    static NetWorkManager *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc ] init];
    });
    return _sharedInstance;
}
#pragma mark--存储（读取）用户名和密码

- (NSDictionary *)getUsernameAndPasswordDic
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"UsernameAndPassword"];
}


-(NSString *)getPasswordWithCurrentUsername:(NSString *)username
{
    NSDictionary * dic = [self getUsernameAndPasswordDic];
    NSString * password;
    if (nil != dic) {
        password = [dic valueForKey:username];
    }
    
    if (nil != password) {
        return password;
    }
    return @"";
}

- (NSString *) getCurrentUserName
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentUsername"];
}

- (void)setCurrentUserName:(NSString *)username
{
    [[NSUserDefaults standardUserDefaults] setValue:username forKey:@"CurrentUsername"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void) saveUserName:(NSString *)username AndPassword:(NSString *)password
{
    NSMutableDictionary * usernameandpassworddic = [[NSMutableDictionary alloc] initWithDictionary:[self getUsernameAndPasswordDic]];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [usernameandpassworddic setValue:password forKey:username];
    
    [userDefaults setObject:usernameandpassworddic forKey:@"UsernameAndPassword"];
    
    [userDefaults setObject:username forKey:@"CurrentUsername"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSArray *)getUserNameList
{
    NSDictionary *dic = [self getUsernameAndPasswordDic];
    NSArray *usernamelist = nil;
    if (dic != nil) {
        usernamelist = [dic allKeys];
    }
    return usernamelist;
}

-(void) deleteUserName:(NSMutableArray *)deleteusernamelist
{
    NSMutableDictionary * usernameandpassworddic = [[NSMutableDictionary alloc] initWithDictionary:[self getUsernameAndPasswordDic]];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [usernameandpassworddic removeObjectsForKeys:deleteusernamelist];
    [userDefaults setObject:usernameandpassworddic forKey:@"UsernameAndPassword"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}


-(BOOL) downloadToFileWithURL:(NSString *)strURL timeout:(int)nTimeout filename:(NSString *)strFileName
{
    NSURLResponse *response = nil;
    NSHTTPURLResponse *httpresponse = nil;
    NSString *urlAsString = strURL;
    
    NSURL    *url = [NSURL URLWithString:urlAsString];
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:nTimeout];
    
    NSError *error = nil;
    NSData   *data = [NSURLConnection sendSynchronousRequest:request
                                           returningResponse:&response
                                                       error:&error];
    
    httpresponse = (NSHTTPURLResponse *) response;
    
    
    /* 下载的数据 */
    
    if (data != nil && (httpresponse.statusCode /100) == 2 )
    {
        NSLog(@"下载成功");
        
        NSString *Path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        
        NSString *filename = [Path stringByAppendingPathComponent:strFileName];
        
        //[self deleteConfigFile:filename];
        
        if ([data writeToFile:filename atomically:NO])
        {
            NSLog(@"保存 %@ 成功.", filename);
            
            return YES;
            
            
        }
        else
        {
            NSLog(@"保存 %@ 失败.", filename);
            
            return NO;
            
            
        }
        
    }
    
    return NO;
    
}

#pragma mark-读取Document本地文件数据
- (NSString *)getMD5FromDocumentLoginJsonFile
{
    NSString *Path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *filePath = [Path stringByAppendingPathComponent:const_strMD5FileName];
    
    //解码
    NSString *string = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    
    return string;
    
}
- (void) saveMD5FileWithStrMD5:(NSString *)strMD5
{
    NSString *Path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *filename = [Path stringByAppendingPathComponent:const_strMD5FileName];
    
    //归档
    NSData *dataMD5 = [NSKeyedArchiver archivedDataWithRootObject:strMD5];
    
    if ([dataMD5 writeToFile:filename atomically:NO])
    {
        NSLog(@"MD5 保存 %@ 成功.", filename);
        
    }
    else
    {
        NSLog(@"MD5 保存 %@ 失败.", filename);
        
    }
    
}
- (NSString *)formatMpcode:(NSString *)strMpcode
{
    
    NSRange dataSearchLeftRange = NSMakeRange(0,strMpcode.length);
    
    NSRange findedRange = [strMpcode rangeOfString:@"_" options:NSCaseInsensitiveSearch range:dataSearchLeftRange];
    
    if (findedRange.location != NSNotFound)
    {
        
        NSArray *array = [strMpcode componentsSeparatedByString:@"_"];
        
        strMpcode =  [array firstObject];
        
        return strMpcode;
    }
    
    return strMpcode;
}

- (NSString *) getStrFromSec:(NSTimeInterval) timeInterval
{
    NSDate *DataTime = [[NSDate alloc] init];
    
    //timeInterval = timeInterval + 8*60*60;
    
    DataTime = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    
    NSString *strTime = [self getStrFromTraderTime:DataTime];
    
    return strTime;
    
}
- (NSInteger) getSecondsFromStr:(NSString *)strTime
{
    //解决符号为负问题  比如“－00:15”
    int nSign = 1;
    if ([strTime hasPrefix:@"-"]) {
        nSign = -1;
        strTime = [strTime stringByReplacingOccurrencesOfString:@"-" withString:@""];
    }
    NSInteger nMinutes = [self getMinuteFromStr:strTime];
    
    return nSign * nMinutes * 60;
}

- (NSInteger) getMinuteFromStr:(NSString *)strTime
{
    NSArray *arrayTemp = [strTime componentsSeparatedByString:@":"];
    
    NSInteger nHours = [arrayTemp[0] integerValue];
    
    NSInteger nMinutes = [arrayTemp[1] integerValue];
    
    return nHours*60+nMinutes;
    
}
- (NSInteger) getMinuteRangeFrom: (NSString *)strFrom To:(NSString *)strTo
{
    NSInteger nOpenTime = [self getMinuteFromStr:strFrom];
    NSInteger nCloseTime = [self getMinuteFromStr:strTo];
    
    NSInteger nRangeTime = 0;
    
    if (nCloseTime > nOpenTime)
    {
        nRangeTime = nCloseTime - nOpenTime;
        
    }
    else
    {
        nRangeTime = 1440 - (nOpenTime - nCloseTime);
    }
    
    return nRangeTime;
    
}
//data转换成time
-(NSString *) getStrFromTraderTime:(NSDate *) curDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:const_Trader_strTimeFormatter_YMDHMS];
    
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GTM+8"]];
    
    NSString *currentDateStr = [dateFormatter stringFromDate:curDate];
    
    return currentDateStr;
    
}

+ (NSString *)getJSONString:(NSDictionary*)theData{
    
    NSError *error = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:theData
                        
                                                       options:NSJSONWritingPrettyPrinted
                        
                                                         error:&error];
    
    if ([jsonData length] > 0 && error == nil)
    {
        
        NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                
                                                     encoding:NSUTF8StringEncoding];
        
        return jsonString;
        
    }
    else
    {
        
        return nil;
        
    }
}

//获得一年中的第几周
- (NSInteger) getWeekNum: (NSString *)strTime
{
    NSDate *date = [self getDateFromStr:strTime];
    
    //获取系统日历
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    // 年月日获得
    NSInteger nFlags =  NSWeekCalendarUnit | NSWeekdayCalendarUnit |NSWeekdayOrdinalCalendarUnit;
    
    // 周几和星期几获得
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    
    comps = [calendar components:nFlags fromDate:date];
    
    NSInteger nWeek = [comps weekOfYear];// 今年的第几周
    /*
     NSIntegerweekday = [comps weekday]; // 星期几（注意，周日是“1”，周一是“2”。。。。）
     
     NSIntegerweekdayOrdinal = [comps weekdayOrdinal]; // 这个月的第几周
     */
    
    return nWeek;
}
- (NSInteger) getWeekDay: (NSString *)strTime
{
    NSDate *date = [self getDateFromStr:strTime];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    
    NSInteger nFlags =  NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
    comps = [calendar components:nFlags fromDate:date];
    
    NSInteger nWeek = [comps weekday];
    
    nWeek--;
    
    return nWeek;
}
- (int) getMonthFromDateString:(NSString *)dateString
{
    NSArray *ArrayDateTime = [dateString componentsSeparatedByString:@" "];
    
    NSString *strYMD =[ArrayDateTime objectAtIndex:0];
    
    NSArray *arrayYMD = [strYMD componentsSeparatedByString:@"-"];
    
    int nMonth = [[arrayYMD objectAtIndex:1] intValue];
    
    return nMonth;
    
}
- (NSDate *) getDateFromStr: (NSString *) strTime
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:const_Trader_strTimeFormatter_YMDHMS];
    
    NSDate *date = [dateFormatter dateFromString:strTime];
    
    return date;
    
}
- (NSDate *) getDateFromStr2: (NSString *) strTime
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:const_strTimeFormatter_Y_M_D];
    
    NSDate *date = [dateFormatter dateFromString:strTime];
    
    return date;
    
}
- (NSDate *) getDateFromStr3: (NSString *) strTime
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:const_Trader_strTimeFormatter_YMDHMSF];
    
    NSDate *date = [dateFormatter dateFromString:strTime];
    
    return date;
    
}
- (NSDate *) getDateFromStr: (NSString *) strTime AndFormatter:(NSString *)formatter
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:formatter];
    
    NSDate *date = [dateFormatter dateFromString:strTime];
    
    return date;
    
}

-(NSTimeInterval) getTimeIntervalFromStr:(NSString *) strTime
{
    NSDate * date = [self getDateFromStr:strTime];
    
    return [date timeIntervalSince1970];
    
}
- (NSString*)convertDateFormatter:(NSString*)s targetFormatter:(NSString*)t dateString:(NSString*)dateString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:s];
    NSDate *date = [dateFormatter dateFromString:dateString];
    [dateFormatter setDateFormat:t];
    return[dateFormatter stringFromDate:date];
}

-(NSTimeInterval) getTimeIntervalForTodayZero
{
    NSString * strCurrrentTime = [self getYMDHMSCurrentAccurateTimer];
    
    NSString *strTimeYMD = [self convertDateFormatter:const_Trader_strTimeFormatter_YMDHMS targetFormatter:const_strTimeFormatter_Y_M_D dateString:strCurrrentTime];
    
    NSString *strTodayZeroTime = [strTimeYMD stringByAppendingString:@" 00:00:00"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:const_Trader_strTimeFormatter_YMDHMS];
    
    NSDate *date = [dateFormatter dateFromString:strTodayZeroTime];
    
    return [date timeIntervalSince1970];
    
}
- (NSString *) getYMDHMSCurrentAccurateTimer
{
    NSDate *now = [NSDate date];
    
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    
    [dateFormater setDateFormat:const_Trader_strTimeFormatter_YMDHMS];
    
    NSString *strCurrentTime= [dateFormater stringFromDate:now];
    
    return strCurrentTime;
}

//通过开收盘时间str,得到 timeInteval
- (OpenCloseTimeInteval_Obj *)getTimeIntervalFromArrayOpenCloseTime:(NSArray *)arrayOpenCloseTime
{
    OpenCloseTimeInteval_Obj *obj_OpenCloseTimeInteval = [[OpenCloseTimeInteval_Obj alloc] init];
    
    OpenCloseTime_Obj * objOpenTime = (OpenCloseTime_Obj *)[arrayOpenCloseTime firstObject];
    OpenCloseTime_Obj * objCloseTime = (OpenCloseTime_Obj *)[arrayOpenCloseTime lastObject];
    
    OpenCloseTime_Obj * objOpenCloseTime = [[OpenCloseTime_Obj alloc] init];
    objOpenCloseTime.strOpentime = objOpenTime.strOpentime;
    objOpenCloseTime.strClosetime = objCloseTime.strClosetime;
    
    int nOpenSign = 1;
    if ([objOpenCloseTime.strOpentime hasSuffix:@"-"]) {
        nOpenSign = -1;
        objOpenCloseTime.strOpentime = [objOpenCloseTime.strOpentime stringByReplacingOccurrencesOfString:@"-" withString:@""];
    }
    
    int nCloseSign = 1;
    if ([objOpenCloseTime.strClosetime hasSuffix:@"-"]) {
        nCloseSign = -1;
        objOpenCloseTime.strClosetime = [objOpenCloseTime.strClosetime stringByReplacingOccurrencesOfString:@"-" withString:@""];
    }
    
    
    
    NSTimeInterval nOpenTime = nOpenSign * [self getSecondsFromStr:objOpenCloseTime.strOpentime];
    
    NSTimeInterval nCloseTime = nCloseSign *[self getSecondsFromStr:objOpenCloseTime.strClosetime];
    
    if (nCloseTime < nOpenTime) {    //如果收盘时间小于开盘时间，收盘时间往后推一天
        nCloseTime += 24*60*60;
    }
    
    obj_OpenCloseTimeInteval.nOpenTime = nOpenTime;
    obj_OpenCloseTimeInteval.nCloseTime = nCloseTime;
    
    return obj_OpenCloseTimeInteval;
}
- (NSString*)getFormatValue:(double) dValue  merplist_obj:(MerpList_Obj*)merplist_obj{
    return [NSString stringWithFormat:[NSString stringWithFormat:@"%%.%ldf", (long)merplist_obj.nPrecision],dValue];
}
- (int) getTimeTypeFromStr:(NSString *)strTime
{
    if ([strTime isEqualToString:@"M1"])
    {
        return 1;
        
    }
    else if ([strTime isEqualToString:@"M5"])
    {
        return 2;
    }
    else if ([strTime isEqualToString:@"M15"])
    {
        return 3;
    }
    else if ([strTime isEqualToString:@"M30"])
    {
        return 4;
    }
    else if ([strTime isEqualToString:@"H1"])
    {
        return 5;
    }
    else if ([strTime isEqualToString:@"H4"])
    {
        return 6;
    }
    else if ([strTime isEqualToString:@"D1"])
    {
        return 7;
    }
    else if ([strTime isEqualToString:@"W1"])
    {
        return 8;
    }
    else
    {
        return 9;
    }
    
}
- (NSArray *)FromGraphDataConversionFenBi7005Data_Obj:(NSArray *)array AndType:(NSString *)type
{
    if (array == nil) {
        return nil;
    }
    
    NSMutableArray *arrayData_Obj = [NSMutableArray array];
    
    for (int i = 0; i < array.count; i++) {
        if ([type isEqualToString:@"M1"]) {
            
            GraphData_M1 *graphEntity = array[i];
            
            FenBi7005Data_Obj *dataObj = [[FenBi7005Data_Obj alloc] init];
            
            dataObj.strAmount = [graphEntity.amount stringValue];
            
            dataObj.strClosePrice = [graphEntity.closeprice stringValue];
            
            dataObj.strTime = graphEntity.datetime;
            
            dataObj.strHighestPrice = [graphEntity.highestprice stringValue];
            
            dataObj.strLowestPrice = [graphEntity.lowestprice stringValue];
            
            dataObj.strOpenPrice = [graphEntity.openprice stringValue];
            
            dataObj.nTime = [graphEntity.time integerValue];
            
            dataObj.strVolume = [graphEntity.volume stringValue];
            
            [arrayData_Obj addObject:dataObj];
            
        } else if ([type isEqualToString:@"M5"]) {
            
            GraphData_M5 *graphEntity = array[i];
            
            FenBi7005Data_Obj *dataObj = [[FenBi7005Data_Obj alloc] init];
            
            dataObj.strAmount = [graphEntity.amount stringValue];
            
            dataObj.strClosePrice = [graphEntity.closeprice stringValue];
            
            dataObj.strTime = graphEntity.datetime;
            
            dataObj.strHighestPrice = [graphEntity.highestprice stringValue];
            
            dataObj.strLowestPrice = [graphEntity.lowestprice stringValue];
            
            dataObj.strOpenPrice = [graphEntity.openprice stringValue];
            
            dataObj.nTime = [graphEntity.time integerValue];
            
            dataObj.strVolume = [graphEntity.volume stringValue];
            
            [arrayData_Obj addObject:dataObj];
            
        } else if ([type isEqualToString:@"M15"]) {
            
            GraphData_M15 *graphEntity = array[i];
            
            FenBi7005Data_Obj *dataObj = [[FenBi7005Data_Obj alloc] init];
            
            dataObj.strAmount = [graphEntity.amount stringValue];
            
            dataObj.strClosePrice = [graphEntity.closeprice stringValue];
            
            dataObj.strTime = graphEntity.datetime;
            
            dataObj.strHighestPrice = [graphEntity.highestprice stringValue];
            
            dataObj.strLowestPrice = [graphEntity.lowestprice stringValue];
            
            dataObj.strOpenPrice = [graphEntity.openprice stringValue];
            
            dataObj.nTime = [graphEntity.time integerValue];
            
            dataObj.strVolume = [graphEntity.volume stringValue];
            
            [arrayData_Obj addObject:dataObj];
            
            
        } else if ([type isEqualToString:@"M30"]) {
            
            GraphData_M30 *graphEntity = array[i];
            
            FenBi7005Data_Obj *dataObj = [[FenBi7005Data_Obj alloc] init];
            
            dataObj.strAmount = [graphEntity.amount stringValue];
            
            dataObj.strClosePrice = [graphEntity.closeprice stringValue];
            
            dataObj.strTime = graphEntity.datetime;
            
            dataObj.strHighestPrice = [graphEntity.highestprice stringValue];
            
            dataObj.strLowestPrice = [graphEntity.lowestprice stringValue];
            
            dataObj.strOpenPrice = [graphEntity.openprice stringValue];
            
            dataObj.nTime = [graphEntity.time integerValue];
            
            dataObj.strVolume = [graphEntity.volume stringValue];
            
            [arrayData_Obj addObject:dataObj];
            
        } else if ([type isEqualToString:@"H1"]) {
            
            GraphData_H1 *graphEntity = array[i];
            
            FenBi7005Data_Obj *dataObj = [[FenBi7005Data_Obj alloc] init];
            
            dataObj.strAmount = [graphEntity.amount stringValue];
            
            dataObj.strClosePrice = [graphEntity.closeprice stringValue];
            
            dataObj.strTime = graphEntity.datetime;
            
            dataObj.strHighestPrice = [graphEntity.highestprice stringValue];
            
            dataObj.strLowestPrice = [graphEntity.lowestprice stringValue];
            
            dataObj.strOpenPrice = [graphEntity.openprice stringValue];
            
            dataObj.nTime = [graphEntity.time integerValue];
            
            dataObj.strVolume = [graphEntity.volume stringValue];
            
            [arrayData_Obj addObject:dataObj];
            
            
        } else if ([type isEqualToString:@"H4"]) {
            
            GraphData_H4 *graphEntity = array[i];
            
            FenBi7005Data_Obj *dataObj = [[FenBi7005Data_Obj alloc] init];
            
            dataObj.strAmount = [graphEntity.amount stringValue];
            
            dataObj.strClosePrice = [graphEntity.closeprice stringValue];
            
            dataObj.strTime = graphEntity.datetime;
            
            dataObj.strHighestPrice = [graphEntity.highestprice stringValue];
            
            dataObj.strLowestPrice = [graphEntity.lowestprice stringValue];
            
            dataObj.strOpenPrice = [graphEntity.openprice stringValue];
            
            dataObj.nTime = [graphEntity.time integerValue];
            
            dataObj.strVolume = [graphEntity.volume stringValue];
            
            [arrayData_Obj addObject:dataObj];
            
            
        } else if ([type isEqualToString:@"D1"]) {
            
            GraphData_D1 *graphEntity = array[i];
            
            FenBi7005Data_Obj *dataObj = [[FenBi7005Data_Obj alloc] init];
            
            dataObj.strAmount = [graphEntity.amount stringValue];
            
            dataObj.strClosePrice = [graphEntity.closeprice stringValue];
            
            dataObj.strTime = graphEntity.datetime;
            
            dataObj.strHighestPrice = [graphEntity.highestprice stringValue];
            
            dataObj.strLowestPrice = [graphEntity.lowestprice stringValue];
            
            dataObj.strOpenPrice = [graphEntity.openprice stringValue];
            
            dataObj.nTime = [graphEntity.time integerValue];
            
            dataObj.strVolume = [graphEntity.volume stringValue];
            
            [arrayData_Obj addObject:dataObj];
            
            
        } else if ([type isEqualToString:@"W1"]) {
            
            GraphData_W1 *graphEntity = array[i];
            
            FenBi7005Data_Obj *dataObj = [[FenBi7005Data_Obj alloc] init];
            
            dataObj.strAmount = [graphEntity.amount stringValue];
            
            dataObj.strClosePrice = [graphEntity.closeprice stringValue];
            
            dataObj.strTime = graphEntity.datetime;
            
            dataObj.strHighestPrice = [graphEntity.highestprice stringValue];
            
            dataObj.strLowestPrice = [graphEntity.lowestprice stringValue];
            
            dataObj.strOpenPrice = [graphEntity.openprice stringValue];
            
            dataObj.nTime = [graphEntity.time integerValue];
            
            dataObj.strVolume = [graphEntity.volume stringValue];
            
            [arrayData_Obj addObject:dataObj];
            
            
        } else if ([type isEqualToString:@"MN"]) {
            
            GraphData_MN *graphEntity = array[i];
            
            FenBi7005Data_Obj *dataObj = [[FenBi7005Data_Obj alloc] init];
            
            dataObj.strAmount = [graphEntity.amount stringValue];
            
            dataObj.strClosePrice = [graphEntity.closeprice stringValue];
            
            dataObj.strTime = graphEntity.datetime;
            
            dataObj.strHighestPrice = [graphEntity.highestprice stringValue];
            
            dataObj.strLowestPrice = [graphEntity.lowestprice stringValue];
            
            dataObj.strOpenPrice = [graphEntity.openprice stringValue];
            
            dataObj.nTime = [graphEntity.time integerValue];
            
            dataObj.strVolume = [graphEntity.volume stringValue];
            
            [arrayData_Obj addObject:dataObj];
        }
    }
    
    return arrayData_Obj;
    
}

- (NSArray *)getGraphaDataBeginTimeAndEndTime:(int)nGraphType
{
    NSDate *end = [NSDate date];
    
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    
    [dateFormater setDateFormat:const_Trader_strTimeFormatter_YMDHMS];
    
    NSString *strEndTime= [dateFormater stringFromDate:end];
    
    NSString *strBeginTime = nil;
    
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    
    NSDate *begin = [end dateByAddingTimeInterval: -30*secondsPerDay];
    
    if (nGraphType == 0) {
        
        strBeginTime = [strEndTime stringByReplacingCharactersInRange:NSMakeRange(strEndTime.length-8, 8) withString:@"00:00:00"];
        
    } else if (nGraphType == 6){
        
        strBeginTime = [dateFormater stringFromDate:begin];
        
    }
    
    return @[strBeginTime,strEndTime];
}
- (void) deleteConfigFile:(NSString *)strFileName AndFileURL:(NSString *)strURL
{
    NSFileManager *fileManger = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    
    NSString *filePath = [docDir stringByAppendingString:strURL];
    
    [fileManger changeCurrentDirectoryPath:[filePath stringByExpandingTildeInPath]];
    
    [fileManger removeItemAtPath:strFileName error:nil];
    
}
//获取文件的修改日期
- (NSTimeInterval) getFileModificationDateFromPathString:(NSString *)strPath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //    NSDictionary *fileAttributes = [fileManager fileAttributesAtPath:strPath traverseLink:YES];
    
    NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:strPath error:nil];
    
    NSDate *fileModDate;
    
    if (fileAttributes != nil)
    {
        //文件修改日期
        fileModDate = [fileAttributes objectForKey:NSFileModificationDate];
        
    }
    else
    {
        NSLog(@"%@文件不存在",strPath);
    }
    
    NSString *strFileModDate =[self getStrFromTraderTime:fileModDate];
    
    return [self getTimeIntervalFromStr:strFileModDate];
    
}
- (TimeShare_Obj *)fenbi7005ConvertToTimeShare:(FenBi7005Data_Obj*)obj_Fenibi
{
    TimeShare_Obj *obj_TimeShare =[[TimeShare_Obj alloc] init];
    obj_TimeShare.strAvgPrice = @"0";
    obj_TimeShare.strNowPrice = obj_Fenibi.strClosePrice;
    obj_TimeShare.strAllTranNum = obj_Fenibi.strVolume;
    obj_TimeShare.strMaxPrice = obj_Fenibi.strHighestPrice;
    obj_TimeShare.strMinPrice = obj_Fenibi.strLowestPrice;
    obj_TimeShare.strTime = obj_Fenibi.strTime;
    obj_TimeShare.strTime_Old = obj_Fenibi.strTime;
    obj_TimeShare.nTime = obj_Fenibi.nTime;
    return obj_TimeShare;
}

@end
