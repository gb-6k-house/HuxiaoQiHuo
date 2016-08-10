//
//  NetWorkManager.h
//  HuXiaoQiHuo
//
//  Created by niupark on 16/5/25.
//  Copyright © 2016年 fukeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OpenCloseTimeInteval_Obj.h"
#import "MerpList_Obj.h"
#import "TimeShare_Obj.h"
#import "FenBi7005Data_Obj.h"

@interface NetWorkManager : NSObject
+ (instancetype)sharedInstance;
@property(nonatomic, assign) uint64_t nCurTimeSec; //最新服务器时间，心跳包更新

- (NSDictionary *)getUsernameAndPasswordDic;

-(NSString *)getPasswordWithCurrentUsername:(NSString *)username;

- (void) saveUserName:(NSString *)username AndPassword:(NSString *)password;

- (NSString *) getCurrentUserName;
- (void)setCurrentUserName:(NSString *)username;
-(NSArray *)getUserNameList;
-(void) deleteUserName:(NSMutableArray *)deleteusernamelist;

-(BOOL) downloadToFileWithURL:(NSString *)strURL timeout:(int)nTimeout filename:(NSString *)strFileName;
//login.json文件处理
- (NSString *)getMD5FromDocumentLoginJsonFile;
- (void) saveMD5FileWithStrMD5:(NSString *)strMD5;
- (NSString *) formatMpcode:(NSString *)strMpcode;
//时间相关函数
- (NSString *) getStrFromSec:(NSTimeInterval) timeInterval;
- (NSInteger) getSecondsFromStr:(NSString *)strTime;
- (NSDate *) getDateFromStr: (NSString *) strTime;
- (NSDate *) getDateFromStr2: (NSString *) strTime;
- (NSDate *) getDateFromStr3: (NSString *) strTime;
- (NSDate *) getDateFromStr: (NSString *) strTime AndFormatter:(NSString *)formatter;
-(NSTimeInterval) getTimeIntervalFromStr:(NSString *) strTime;
- (NSString *) getStrFromTraderTime:(NSDate *) curDate;
+ (NSString *)getJSONString:(NSDictionary*)theData;
- (NSInteger) getWeekNum: (NSString *)strTime;
- (NSInteger) getWeekDay: (NSString *)strTime;
- (int) getMonthFromDateString:(NSString *)dateString;
-(NSTimeInterval) getTimeIntervalForTodayZero;
- (NSString *) getYMDHMSCurrentAccurateTimer;
- (NSString*)convertDateFormatter:(NSString*)s targetFormatter:(NSString*)t dateString:(NSString*)dateString;
///////////////
- (OpenCloseTimeInteval_Obj *)getTimeIntervalFromArrayOpenCloseTime:(NSArray *)arrayOpenCloseTime;
- (NSString*)getFormatValue:(double) dValue  merplist_obj:(MerpList_Obj*)merplist_obj;
- (int) getTimeTypeFromStr:(NSString *)strTime;
- (NSArray *)FromGraphDataConversionFenBi7005Data_Obj:(NSArray *)array AndType:(NSString *)type;
- (NSArray *)getGraphaDataBeginTimeAndEndTime:(int)nGraphType;
- (void) deleteConfigFile:(NSString *)strFileName AndFileURL:(NSString *)strURL;
//获取文件的修改日期
- (NSTimeInterval) getFileModificationDateFromPathString:(NSString *)strPath;
- (TimeShare_Obj *)fenbi7005ConvertToTimeShare:(FenBi7005Data_Obj*)obj_Fenibi;
@end
