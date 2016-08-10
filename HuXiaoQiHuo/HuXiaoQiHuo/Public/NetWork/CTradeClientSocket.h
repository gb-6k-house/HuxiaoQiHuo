//
//  CTradeClientSocket.h
//  HuXiaoQiHuo
//
//  Created by niupark on 16/5/19.
//  Copyright © 2016年 fukeng. All rights reserved.
//

#import "CClientSocket.h"
#import "TraderResponse.h"
#import "CSocketListenerManager.h"
#import "LoginParaObj.h"
#import "JsonParse.h"
#import "TTFileCache.h"
#import "Tags_Obj.h"
#import "Login_Tags_Obj.h"
#import "MessageCenterList_Obj.h"
#import "OCTDic_Obj.h"
#import "OpenCloseTime_Obj.h"
#import "MarketID_Obj.h"
#import "MerpList_Obj.h"
#import "Constants.h"
#import "GraphServerObj.h"
#import "QuoteServerObj.h"
#import "LoginJson_menus_Obj.h"
#import "FYRaceData_Obj.h"
#import "marketIndex_Obj.h"
#import "OpenCloseTimeInfo_Obj.h"
#import "OpenTimePointObj.h"
/*交易相关的，包含登录交易系统。登录之后应该有交易信息返回*/
@interface CTradeClientSocket : CClientSocket
//行情数据，行情数据由行情socket返回,此处只做保存
@property (nonatomic, strong) NSMutableDictionary * dicPriceData;

//登录
-(void)loginWithUsername:(NSString *)username AndPassword:(NSString *)password;
-(void)logout;

//获取login.json数据 force =true则无论是否是最新都从服务器获取
-(void)getLoginJsonFileForce:(BOOL)force;

//根据商品码，获取商品详情
//根据mpcode检索市场商品信息
-(MerpList_Obj*)merpListObjWithMpcode:(NSString*)mpCode marketId:(NSString *)marketID;
-(MerpList_Obj*)merpListObjWithMpIndex:(NSString*)mpIndex;

-(MerpList_Obj*)merpListObjWithMpcode:(NSString*)mpCode;
//推荐商品list MerpList_Obj
-(NSArray*)recommendMerpListObj;
//根据分类获取分类商品
-(NSArray*)merpLitObjByClassicID:(NSString*)classicID;


/**
 *  @author LiuK, 16-05-26 16:05:08
 *
 *  根据市场ID 连接市场的行情服务
 */
-(void)connectQuoteServerWithMarketID:(NSString *)marketID;

-(void)disConnectQuoteServerWithMarketID:(NSString *)marketID;
/**
 *  @author LiuK, 16-05-27 09:05:07
 *
 *  根据商品的index 获取商品的最新行情信息
 */

-(void)updateMarketInfoWithMpIndexs:(NSSet*)mpIndexs;
/**
 *  @author LiuK, 16-05-27 15:05:04
 *
 *  获取商品的市场ID信息
 */
-(marketIndex_Obj*)marketIndexByMpIndex:(NSString*)mpIndex;
/**
 *  @author LiuK, 16-05-30 16:05:22
 *
 *  获取商品的K线图服务器
 *
 *  @param  mpIndex
 *
 *  @return <#return value description#>
 */
-(GraphServerObj*)graphServerByMpIndex:(NSNumber*)mpIndex;
/**
 *  @author LiuK, 16-05-30 14:05:51
 *
 *  开盘，闭市时间
 */
-(OpenCloseTime_Obj *) getOpenCloseTime_Obj: (NSTimeInterval) nTime AndMapID:(NSString *) strMapID;
-(NSArray *) getOpenTimePiontArrayFromMapId:(NSString *) strMapID AndTime: (NSTimeInterval) nTime;
/**
 *  @author LiuK, 16-05-30 15:05:56
 *
 *  收盘价
 *
 *  @param strProductCode <#strProductCode description#>
 *  @param strMarketID    <#strMarketID description#>
 *
 *  @return <#return value description#>
 */
- (NSString *) getClosePrice: (NSString *)strProductCode marketID:(NSString *)strMarketID;
/**
 *  @author LiuK, 16-06-01 10:06:47
 *
 *  获取二级tag，没有返回nil
 *
 *  @param tagID <#tagID description#>
 *
 *  @return <#return value description#>
 */
-(NSArray*)getSubTagForTagID:(NSString*)tagID;


@end
