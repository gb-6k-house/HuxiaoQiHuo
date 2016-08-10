//
//  GlobalValue.h
//  HuXiaoQiHuo
//
//  Created by niupark on 16/5/21.
//  Copyright © 2016年 fukeng. All rights reserved.
//

#import <Foundation/Foundation.h>



extern NSString * const const_MarketID; //app 端市场ID
extern NSString * const const_recommondTag; // 推荐商品tag
extern NSString * const const_GlobleMarketQihuoTag; // 推荐商品tag
extern NSString * const const_strName;
extern NSString * const const_strPass;
extern NSString * const const_strDomain;
extern NSString * const const_strDomainIP ;
extern NSString * const const_strResource;

//extern NSString * const const_strJID;
extern NSString * const const_strInformationId;
extern NSString * const const_strVoiceDicName;


//Trader



#define AlertViewID_VERERROR    1001
#define AlertViewID_RESENDMSG    1002
#define AlertViewID_LOGINERROR    1003

#define AdminImage_Height    80.0//图片的高度
#define AdminImage_Width    60.0//图片的宽度

#define AdminHead_portrait_Height    60.0//头像的高度
#define AdminHead_portrait_Width    60.0//头像的宽度


#define AdminFileMark_Height    50.0//文件图标的高度
#define AdminFileMark_Width    40.0//文件图标的宽度
#define Admin_ChartViewRect_FileMark_Height    70.0//文件图标背景的高度
#define Admin_ChartViewRect_FileMark_Width    200.0//文件图标背景的宽度



#define AdminChartViewRect_Height    50.0 //ChartView的高度
#define AdminChartViewRect_Width    30.0//ChartView的宽度

#define kAdmin_Chat_nUser_Self 1 //用户是自己
#define kAdmin_Chat_nUser_Other 0//用户是他人

#define kAdmin_Chart_MessageTime 300//两条消息之间的时间间隔值

//Chat中每次显示的消息条数
#define kUI_CHAT_MSG_COUNT  15  //
#define kUI_CHAT_TEXTVIEW_HEIGHT  16.7 //聊天界面textView的行高度
#define kUI_CHAT_TEXTVIEW_BASEAMOUNT_HEIGHT  18.4 //聊天界面textView的行高度

//UI的超时间隔
#define kUI_TIMEOUT_LOGIN   120.0f   //登录超时时间
#define kUI_TIMEOUT_WAITREADY   60.0f   //等待ready消息超时时间
#define kUI_TIMEOUT_WAIT_CONNECT   2.0f   //等待链接超时时间
#define kUI_TIMEOUT_SEARCH_WAITREADY   20.0f
//labletag


#define kAdmin_Chart_lableUserNickeNameTag 1998 // 用户昵称 lable的tag值
//#define kAdmin_Chart_lableUserJidTag 1999 //
#define kAdmin_Chat_lableEmailTag 1999 //用户Email lable的tag值
#define kAdmin_Chat_lablePhoneNumberTag 2000 //用户电话 lable的tag值
#define kAdmin_Chat_lableRemarkTag 2001 //用户备注 lable的tag值
#define kAdmin_Chat_lableNameTag 2002 //用户名字 lable的tag值
#define kAdmin_Chat_lableDescriptionTag 2003 //用户描述 lable的tag值


#define kAdmin_Chat_voiceFileNameTag 0 //语音文件的tag值
#define kAdmin_Chat_imageFileNameTag 1 //图片文件的tag值
#define kAdmin_Chat_otherFileNameTag 2 //其它文件的tag值

//JPush
extern NSString * const kAPNetworkDidSetupNotification; // 建立连接
extern NSString * const kAPNetworkDidCloseNotification;  // 关闭连接
extern NSString * const kAPNetworkDidRegisterNotification; // 注册成功
extern NSString * const kAPNetworkDidLoginNotification; // 登录成功
extern NSString * const kAPNetworkDidReceiveMessageNotification; // 收到消息(非APNS)


extern NSString * const const_strTimeFormatter_YMD_MHS;
extern NSString * const const_strTimeFormatter_YMD_HM;
extern NSString * const const_Trader_strTimeFormatter_YMDHMS;
extern NSString * const const_Trader_strTimeFormatter_YMDHMSZ;
extern NSString * const const_strTimeFormatter_YMD;
extern NSString * const const_strTimeFormatter_HM;
extern NSString * const const_strTimeFormatter_YMDHMS;
extern NSString * const const_strTimeFormatter_OtherFormat_YMD;
extern NSString * const const_strTimeFormatter_Y_M_D;
extern NSString * const const_strTimeFormatter_HMS;
extern NSString * const const_Trader_strTimeFormatter_YMDHMSF;
extern NSString * const const_Trader_strTimeFormatter_HMSF;
extern NSString * const const_strTimeFormatter_M_D;
extern NSString * const const_strLunTanURL;
extern NSString * const const_strNewsURL;
extern NSString * const const_strNewsSubURL;

//资讯
extern NSString * const const_strMsgURL;

//风云榜
extern NSString * const const_strFYURL;

extern NSString * const const_strFYDomainIP;//风云榜推送服务器地址

extern NSString * const const_strFYResource;//风云榜推送服务器端口号

extern NSString * const const_FY_strSubsciption_webURL;//风云榜请求数据的服务器地址
extern NSString * const const_FY_strSubsciption_webResource;

extern NSString * const const_FY_strSubsciption_InformationURL;//风云榜交易信息请求数据的服务器地址
extern NSString * const const_FY_strSubsciption_InformationResource;

extern NSString * const const_FY_strSubsciption_UserInformationURL;//风云榜查询数据的服务器地址
extern NSString * const const_FY_strSubsciption_UserInformationResource;

//extern NSString * const const_FY_strSubsciption_webURL;//风云榜请求数据的服务器地址
//extern NSString * const const_FY_strSubsciption_webResource;
/*
其中,kAPNetworkDidReceiveMessageNotification通知是有传递数据的,可以通过NSNotification中的userI
nfo方法获取,包括标题、内容、内容类型、扩展信息等
 */
extern NSString * const const_strRegisterSvr_IP;//注册服务器的IP地址
extern NSString * const const_strRegisterSvr_Port;//注册服务器的端口号

extern NSString * const const_strURL;
extern NSString * const const_strIPAddress;

extern NSString * const const_strSubFolder;

extern NSString * const const_strVersionFileName;

extern NSString * const const_strLoginSvr_IP ;

extern NSString * const const_strLoginSvr_Port ;

//extern NSString * const const_strLoginSvrFile_R_IP ;
//
//extern NSString * const const_strLoginSvrFile_R_Port;

extern NSString * const const_strLoginSvrFileName;

extern NSString * const const_strMsgCenterCfgFileName;

extern NSString * const const_strZXFileName;

extern NSString * const const_strLoginJsonFileName; //登录回应获取url的文件名

extern NSString * const const_strRaceFileName;

extern NSString * const const_strInitJsonName;
extern NSString * const const_strInitJsonNameType;

extern NSString * const const_strMD5LoginJson; //Login.Json文件的MD5值

extern NSString * const const_strMD5FileName; // 保存 login.json 文件的MD5

extern NSString * const const_strRACEMD5FileName; // 保存 race.json 文件的MD5

extern NSString * const const_strAppID;


extern NSString * const NUMBERS ;
extern NSString * const NUMBERSPERIOD ;
extern NSString * const NUMBERSX ;


//extern NSString * const const_strTimeFormatter_YMD;
//extern NSString * const const_strTimeFormatter_MDHM;
//extern NSString * const const_strTimeFormatter_MD;
//extern NSString * const const_strTimeFormatter_HM;


extern NSString * const const_strSymbol;
extern NSString * const const_FY_strSymbol;
//extern NSString * const const_strFenShiTuURL;



#define MaxGraphDataCount   2000000
#define MinGraphDataCount   100

#define AlertViewID_VERERROR    1001
#define AlertViewID_NETERROR    1002

#define AlertViewID_REGISTER    1989
#define AlertViewID_SUBCRIPTION    1988
#define AlertViewID_HOMEPAGE_LOGOUT 1987

#define VIEW_WIDTH         self.view.bounds.size.width
#define VIEW_HEIGHT        self.view.bounds.size.height
#define WINDOW_HEIGHT      [UIScreen mainScreen].bounds.size.height
#define WINDOW_WIDTH       [UIScreen mainScreen].bounds.size.width

#define NAV_HEIGHT_H        32
#define NAV_HEIGHT_V        44
#define BAR_HEIGHT          20

#define TSVIEWHEIGHT        0.8


#define TOPVIEW_HEIGHT      150



//GraphView 详情view 竖立
#define InfoView_X_V         0
#define InfoView_Y_V         0
#define InfoView_Width_V     WINDOW_WIDTH
#define InfoView_Height_V    112

//GraphView 详情view 水平
#define InfoView_X_H          0
#define InfoView_Y_H          0
#define InfoView_Width_H      0
#define InfoView_Height_H     0


//GraphView 详情tab view 竖立
#define InfoTabBar_X_V          10
#define InfoTabBar_Y_V          117
#define InfoTabBar_Width_V      WINDOW_WIDTH -20
#define InfoTabBar_Width_V_Ex   WINDOW_HEIGHT //当从横屏变竖屏时获取的宽度为设备的高度
#define InfoTabBar_Height_V     30


//GraphView 详情tab view 水平
#define InfoTabBar_X_H          0
#define InfoTabBar_Y_H          0
#define InfoTabBar_Width_H      0
#define InfoTabBar_Height_H     0


//ChartView 图形view 竖立
#define ChartView_X_V           0
#define ChartView_Y_V           (InfoTabBar_Y_V + InfoTabBar_Height_V + 5)

#define ChartView_Width_V       WINDOW_WIDTH
#define ChartView_Height_V      (WINDOW_HEIGHT - InfoTabBar_Y_V - InfoTabBar_Height_V-5 - BottomView_Height_V - 64)

//GraphView 图形view 水平
#define ChartView_X_H           0
#define ChartView_Y_H           0
#define ChartView_Width_H       WINDOW_HEIGHT
#define ChartView_Height_H      (WINDOW_WIDTH - BottomView_Height_H - NAV_HEIGHT_H - BAR_HEIGHT)

//ChartView + TraderNum View  竖立
#define ChartView_Min_X_V           0
#define ChartView_Min_Y_V           (InfoTabBar_Y_V + InfoTabBar_Height_V + 5)
#define ChartView_Min_Width_V       WINDOW_WIDTH
#define ChartView_Min_Height_V      (ChartView_Height_V*TSVIEWHEIGHT)


//GraphView + TraderNum View  水平
#define ChartView_Min_X_H           0
#define ChartView_Min_Y_H           0
#define ChartView_Min_Width_H       WINDOW_HEIGHT
#define ChartView_Min_Height_H      (ChartView_Height_H*TSVIEWHEIGHT)

//TraderNum View 竖立


#define TraderNum_X_V           0
#define TraderNum_Y_V           (InfoTabBar_Y_V + InfoTabBar_Height_V + 5 + ChartView_Min_Height_V)
#define TraderNum_Width_V       WINDOW_WIDTH
#define TraderNum_Height_V      (ChartView_Height_V - ChartView_Min_Height_V)

//TraderNum View 水平
#define TraderNum_X_H           0
#define TraderNum_Y_H           (InfoView_Height_H + InfoTabBar_Height_H + ChartView_Min_Height_H)+10
#define TraderNum_Width_H       WINDOW_HEIGHT
#define TraderNum_Height_H      (ChartView_Height_H - ChartView_Min_Height_H)

//GraphView Bottom view 竖立
#define BottomView_X_V          0
#define BottomView_Y_V          (InfoTabBar_Y_V + InfoTabBar_Height_V + ChartView_Height_V + 5)
#define BottomView_Width_V      WINDOW_WIDTH
#define BottomView_Height_V     35

//GraphView Bottom view 水平
#define BottomView_X_H          0
#define BottomView_Y_H          0
#define BottomView_Width_H      0
#define BottomView_Height_H     0

//#define BottomView_X_H          0
//#define BottomView_Y_H          ChartView_Height_H
//#define BottomView_Width_H      WINDOW_HEIGHT
//#define BottomView_Height_H     33




#define SYSTEMFONT(s)      [UIFont systemFontOfSize:s]
#define BOLDSYSTEMFONT(s)  [UIFont boldSystemFontOfSize:s]

#define MarketType_Match    1
#define MarketType_Market   2

#define VISITOR_USERNAME "user1"
#define VISITOR_PASSWORD "user1"

#define MsgCode_Heart           101
#define MsgCode_Login           102
#define MsgCode_Quit            103
#define MsgCode_UserInfo        104
#define MsgCode_MarketList      105
#define MsgCode_ChangeUserInfo  106
#define MsgCode_ChangePass      107
#define MsgCode_MsgNotify       108
#define MsgCode_MsgCenterList   109
//#define MsgCode_Subscription      117
#define MsgCode_Subscription    118
#define MsgCode_SubscriptionNumber   119
#define MsgCode_HomepageQuery_uid   121
#define MsgCode_SubscriptionNotify   122

#define MsgCode_RaceStatus   123    //参赛活动
#define MsgCode_RaceNumber   124    //参赛活动人数
#define MsgCode_SUBSCRIPTION_SEARCHNOTIFY   125    //查询订阅排名数据

#define MsgCode_Register        201
#define MsgCode_Captcha        202
#define MsgCode_CaptchaForModiyPSW        204
#define MsgCode_ModifyPassword        205

/***********GT6***********/
#define TypeID_Market  1
#define TypeID_Match   2
#define TypeID_Web     3

#define TypeID_Match2  82

#define TypeID_MarketAndMatch  12
#define TypeID_MarketAndWeb    13
#define TypeID_MatchAndWeb     22

#define TypeID_All         88



#define SYSTEMFONT(s)      [UIFont systemFontOfSize:s]
#define BOLDSYSTEMFONT(s)  [UIFont boldSystemFontOfSize:s]


@interface Constants : NSObject

@end
