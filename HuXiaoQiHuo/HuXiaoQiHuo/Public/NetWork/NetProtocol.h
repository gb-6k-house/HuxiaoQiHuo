//
//  NetProtocol.h
//  HuXiaoQiHuo
//
//  Created by niupark on 16/5/19.
//  Copyright © 2016年 fukeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TraderResponse.h"
/**
 *  @author LiuK, 16-05-19 14:05:33
 *
 *  socket 协议定义
 *
 *  @return <#return value description#>
 */

/*
 网络层说明
 /NetWork/Http/ ，是http协议相关封装
 /NetWork/Socket/ socket协议请求的封装
 /NetWork/Request/ 请求数据封装
 /NetWork/Response/ 返回数据封装
 /NetWork/NetProtocol  服务相关协议定义信息
 socket 通信说明
 /NetWork/Socket/CTradeClientSocket 类负责整个soket通信是个单例。
 1、发送socket请求命令参照loginWithUsername:AndPassword:的实现
 2、对于socket返回的数据已经路由到相应的parseXXXXResponse 方法，根据具体业务需求实现parseXXXXResponse 方法。
 */


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

/***********GT6***********/
#define TypeID_Market  1
#define TypeID_Match   2
#define TypeID_Web     3

#define TypeID_Match2  82

#define TypeID_MarketAndMatch  12
#define TypeID_MarketAndWeb    13
#define TypeID_MatchAndWeb     22

#define TypeID_All         88

#define  SOCKET_PROTOCOL(name)\
-(void)socket##name##CallBack:(id)response;

#define  PROTOCOL_SEL(name)\
@selector(socket##name##CallBack:)

@protocol SocketCallBackProtocol <NSObject>
@optional
/**
 *  @author LiuK, 16-06-07 17:06:58
 *
 *  socket链接成功返回
 *  NSDictionary;{
 * socket: 当前socket对象
 }
 *  @param SocketConnected <#SocketConnected description#>
 *
 *  @return <#return value description#>
 */
SOCKET_PROTOCOL(SocketConnected) //socket链接成功
//返回协议的名称统一为:-socketXXXCallBack:(id)data
//定义登录返回协议协议
SOCKET_PROTOCOL(Login)
SOCKET_PROTOCOL(LoginJson)
SOCKET_PROTOCOL(Logout)
SOCKET_PROTOCOL(Register)
SOCKET_PROTOCOL(RegisterCode)
SOCKET_PROTOCOL(ModifyPassword)

//行情信息刷新, 返回PriceData_Obj信息
SOCKET_PROTOCOL(NewPrice)
//K线图数据返回 GraphResponse
SOCKET_PROTOCOL(KGraph)
//分时图数据返回
SOCKET_PROTOCOL(TimeShareGraph)

SOCKET_PROTOCOL(7005Request)
/**
 *  @author LiuK, 16-06-02 10:06:34
 *
 *  模拟交易服务器接口 返回 GT6LoginResponse
 *
 *  @return <#return value description#>
 */
SOCKET_PROTOCOL(GT6Login)
SOCKET_PROTOCOL(GT6UserInfo)
SOCKET_PROTOCOL(GT6AddOrder)



@end
