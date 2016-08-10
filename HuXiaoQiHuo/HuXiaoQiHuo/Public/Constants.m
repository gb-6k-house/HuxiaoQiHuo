//
//  GlobalValue.h
//  HuXiaoQiHuo
//
//  Created by niupark on 16/5/21.
//  Copyright © 2016年 fukeng. All rights reserved.
//

#import "Constants.h"
NSString * const const_MarketID = @"18758";
NSString * const const_recommondTag = @"9"; // 推荐商品tag
NSString * const const_GlobleMarketQihuoTag = @"26"; // 国际期货

NSString * const const_strName = @"yifei";
NSString * const const_strPass = @"123456";

//NSString * const const_strDomainIP = @"114.215.137.89";
NSString * const const_strDomainIP = @"121.40.94.122";
//NSString * const const_strDomainIP = @"121.43.154.191"; //XMPP服务器

//NSString * const const_strJID = @"yifei@hpry-pc";
NSString * const const_strResource = @"jihao";

//NSString * const const_strDomain = @"iz23s1g23jbz";
NSString * const const_strDomain = @"iZ23fltyq0eZ";
//NSString * const const_strDomain = @"hpry-pc";
NSString * const const_strInformationId = @"userInformationId";

NSString * const const_strVoiceDicName = @"/voice/";

//NSString * const const_strTimeFormatter_YMDHMS = @"yyyy-MM-dd HH:mm:ss";
//NSString * const const_strTimeFormatter_YMD = @"yyyy-MM-dd";
//NSString * const const_strTimeFormatter_MDHM = @"MM-dd HH:mm";
//NSString * const const_strTimeFormatter_MD = @"MM-dd";
//NSString * const const_strTimeFormatter_HM = @"HH:mm";

NSString * const const_strTimeFormatter_YMD_MHS = @"yyyy/MM/dd HH:mm:ss";
NSString * const const_strTimeFormatter_YMD_HM = @"MM/dd HH:mm";

NSString * const const_strTimeFormatter_YMD = @"yyyy/MM/dd";
NSString * const const_strTimeFormatter_HM = @"HH:mm";
NSString * const const_strTimeFormatter_YMDHMS = @"yyyyMMddHHmmss";
NSString * const const_strTimeFormatter_OtherFormat_YMD = @"yyyyMMdd";
NSString * const const_strTimeFormatter_Y_M_D = @"yyyy-MM-dd";
NSString * const const_Trader_strTimeFormatter_YMDHMS = @"yyyy-MM-dd HH:mm:ss";
NSString * const const_Trader_strTimeFormatter_YMDHMSZ = @"yyyy-MM-dd'T'HH:mm:ss";
NSString * const const_strTimeFormatter_HMS = @"HH:mm:ss";
NSString * const const_Trader_strTimeFormatter_YMDHMSF = @"yyyy-MM-dd HH:mm:ss.SSS";
NSString * const const_Trader_strTimeFormatter_HMSF = @"HH:mm:ss.SSS";
NSString * const const_strTimeFormatter_M_D = @"MM-dd";

//论坛与新闻的url
NSString * const const_strLunTanURL = @"http://098jy.com/";
NSString * const const_strNewsURL = @"http://098jy.com/";
NSString * const const_strNewsSubURL = @"http://098jy.com/news/newsdetail.aspx?";

//资讯
NSString * const const_strMsgURL = @"http://www.tfbcj.com/";

//风云榜
NSString * const const_strFYURL = @"http://121.43.232.204/billboard.json";

NSString * const const_strFYDomainIP = @"121.43.232.204"; //风云榜推送服务器地址

NSString * const const_strFYResource = @"9328";//风云榜推送服务器端口号


NSString * const const_FY_strSubsciption_webURL = @"121.43.232.204";
NSString * const const_FY_strSubsciption_webResource = @"8097";

NSString * const const_FY_strSubsciption_InformationURL = @"121.41.36.129";//风云榜交易信息请求数据的服务器地址
NSString * const const_FY_strSubsciption_InformationResource =  @"8092";

NSString * const const_FY_strSubsciption_UserInformationURL = @"121.43.232.204";//风云榜查询数据的服务器地址
NSString * const const_FY_strSubsciption_UserInformationResource = @"8099";


NSString * const const_strURL =@"tfbrj.com";
//NSString * const const_strURL =@"218.244.145.100";

//NSString * const const_strIPAddress = @"121.199.53.94";
NSString * const const_strIPAddress = @"218.244.145.100";

NSString * const const_strSubFolder = @"/mobile/trader/client"; //Market 会自动加上版本号
NSString * const const_strAppID =@"986208961"; // traderex appid

NSString * const const_strVersionFileName = @"version.plist";

NSString * const const_strRegisterSvr_IP = @"121.43.232.204";//注册服务器的IP地址
NSString * const const_strRegisterSvr_Port = @"9402";//注册服务器的端口号


NSString * const const_strLoginSvr_IP = @"121.40.94.122";//行情登陆Ip 测试
//NSString * const const_strLoginSvr_IP = @"121.43.232.204";//行情登陆Ip 正式
NSString * const const_strLoginSvr_Port = @"9401";//行情登陆Port

//NSString * const const_strLoginSvr_IP = @"121.40.94.122";//行情登陆Ip
//NSString * const const_strLoginSvr_Port = @"9401";//行情登陆Port


//NSString * const const_strLoginSvrFile_R_IP = @"121.199.29.61";
//NSString * const const_strLoginSvrFile_R_Port = @"9402";

NSString * const const_strLoginSvrFileName = @"loginsvr.plist";

NSString * const const_strMsgCenterCfgFileName = @"msgcenter.plist";

NSString * const const_strZXFileName = @"zxfilename.plist"; //本地自选保存文件

NSString * const const_strLoginJsonFileName = @"login.json"; //登录回应获取url的文件名
NSString * const const_strRaceFileName = @"race.json"; //登录回应获取url的文件名

NSString * const const_strInitJsonName = @"init"; //init.json的文件名
NSString * const const_strInitJsonNameType = @"json"; // init.json的扩展名

NSString * const const_strMD5LoginJson = @"fce81a7625c4698faee41b244cb1012a";

NSString * const const_strMD5FileName = @"md5.json";
NSString * const const_strRACEMD5FileName = @"racemd5.json";

NSString * const NUMBERS = @"0123456789";
NSString * const NUMBERSPERIOD = @"0123456789.";
NSString * const NUMBERSX = @"0123456789Xx";




NSString * const const_strSymbol = @"\r\n\r\n";
NSString * const const_FY_strSymbol = @"<";
//NSString * const const_strFenShiTuURL = @"http://115.29.175.168/db";


@implementation Constants

@end
