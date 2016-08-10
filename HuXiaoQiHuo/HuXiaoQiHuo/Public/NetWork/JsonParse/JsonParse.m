//
//  JsonParse.m
//  Trader
//
//  Created by cssoft on 15/4/29.
//  Copyright (c) 2015年 easyfly. All rights reserved.
//

#import "JsonParse.h"

@implementation JsonParse

-(JsonParse *) init
{
    if (self = [super init]) {
        
        
        [self initJsonParse];
    }
    return self;
}

- (void) initJsonParse
{
}
- (LoginParaObj *) getLoginResponse_LoginParaObjByDIC:(NSDictionary *) dic
{
    //初始化对象
    LoginParaObj *obj_LoginPara = [[LoginParaObj alloc]init];
    
    obj_LoginPara.MD5 = [dic objectForKey:@"MD5"];
    
    obj_LoginPara.URL = [dic objectForKey:@"URL"];
    
    obj_LoginPara.graphServer = [dic objectForKey:@"graphServer"];
    
    obj_LoginPara.fy_socketServer = [dic objectForKey:@"DistributeServer"];
    
    obj_LoginPara.quoteServer = [dic objectForKey:@"quoteServer"];
    
    obj_LoginPara.menusID = [dic objectForKey:@"menusID"];
    
    obj_LoginPara.marketlist = [dic objectForKey:@"marketlist"];
    
    obj_LoginPara.MCL = [dic objectForKey:@"MCL"];
    
    obj_LoginPara.IntervalTime = [[dic objectForKey:@"IntervalTime"] intValue];
    
    obj_LoginPara.GIntervalTime = [[dic objectForKey:@"GIntervalTime"] intValue];
    
    obj_LoginPara.PIntervalTime = [[dic objectForKey:@"PIntervalTime"] intValue];
    obj_LoginPara.muserInfo = [dic objectForKey:@"MuserList"][0];
    
    obj_LoginPara.analogaccount = [dic objectForKey:@"analogaccount"];
    
    obj_LoginPara.analogpwd = [dic objectForKey:@"analogpwd"];
    
    obj_LoginPara.RACEMD5 = [dic objectForKey:@"RACEMD5"];
    
    return obj_LoginPara;
    
}

- (Login_Tags_Obj*) getLoginJson_Tags_ObjByDIC:(NSMutableDictionary *) dic
{
    //初始化对象
    Login_Tags_Obj *obj_LoginJson_Tags = [[Login_Tags_Obj alloc]init];
    
    obj_LoginJson_Tags.ID = [[dic objectForKey:@"id"]integerValue];
    
    obj_LoginJson_Tags.name = [dic objectForKey:@"name"];
    
    obj_LoginJson_Tags.order = [dic objectForKey:@"order"];
    
    obj_LoginJson_Tags.parentID = [[dic objectForKey:@"parentID"]integerValue];
    
    return obj_LoginJson_Tags;
    
}

- (LoginJson_MCL_Obj*) getLoginJson_MCL_ObjByDIC:(NSMutableDictionary *) dic
{
    //初始化对象
    LoginJson_MCL_Obj *obj_LoginJson_MCL = [[LoginJson_MCL_Obj alloc]init];
    
    obj_LoginJson_MCL.ID = [[dic objectForKey:@"ID"] integerValue];
    
    obj_LoginJson_MCL.name = [dic objectForKey:@"name"];
    
    obj_LoginJson_MCL.URL = [dic objectForKey:@"URL"];
    
    return obj_LoginJson_MCL;
}


- (LoginJson_OCTDic_obj*) getLoginJson_OCTDic_objByDIC:(NSMutableDictionary *) dic
{
    
    //初始化对象
    LoginJson_OCTDic_obj *obj_LoginJson_OCTDic = [[LoginJson_OCTDic_obj alloc]init];
    
    obj_LoginJson_OCTDic.index = [[dic objectForKey:@"index"] integerValue];
    
    obj_LoginJson_OCTDic.OTCT = [dic objectForKey:@"OTCT"];
    
    obj_LoginJson_OCTDic.week = [dic objectForKey:@"week"];
    
    //    NSArray *arrayWeek = [dic objectForKey:@"week"];
    
    //    //修复后的合适的礼拜几，用week对7取模得到正确的礼拜几
    //    NSMutableArray *arrayFixedWeek = [NSMutableArray array];
    //
    //    //用week对7取整得到往后推的天数
    //    NSMutableDictionary *dicWeek = [NSMutableDictionary dictionary];
    //
    //    NSMutableDictionary *dicWeekSign = [NSMutableDictionary dictionary];
    //
    //    for (NSNumber *week in arrayWeek) {
    //
    //        int nWeek = [week intValue];
    //
    //        NSString *weekSign = @"0";   // nWeek 0~7 则按原来的逻辑
    //
    //        if (nWeek < 0) {      //小于0开盘时间往前推
    //            weekSign = @"-";
    //        } else if (nWeek > 7) {        //大于7收盘时间往后推
    //            weekSign = @"+";
    //        }
    //        //取绝对值进行运算
    //        nWeek = abs(nWeek);
    //
    //        int nFixedWeek = nWeek % 7;
    //        int nFixedDay = nWeek / 7;
    //
    //
    //        [arrayFixedWeek addObject:[NSNumber numberWithInt:nFixedWeek]];
    //        [dicWeek setObject:[NSNumber numberWithInt:nFixedDay] forKey:[NSString stringWithFormat:@"%d",nFixedWeek]];
    //        [dicWeekSign setObject:weekSign forKey:[NSString stringWithFormat:@"%d",nFixedWeek]];
    //    }
    //
    //    obj_LoginJson_OCTDic.week = arrayFixedWeek;
    //    obj_LoginJson_OCTDic.dicWeek = dicWeek;
    //    obj_LoginJson_OCTDic.dicWeekSign = dicWeekSign;
    
    return obj_LoginJson_OCTDic;
    
}

- (LoginJson_opencloseTime_obj*) getLoginJson_opencloseTime_objByDIC:(NSMutableDictionary *) dic
{
    //初始化对象
    LoginJson_opencloseTime_obj *obj_LoginJson_opencloseTime = [[LoginJson_opencloseTime_obj alloc]init];
    
    obj_LoginJson_opencloseTime.opentime = [dic objectForKey:@"opentime"];
    
    obj_LoginJson_opencloseTime.closetime = [dic objectForKey:@"closetime"];
    
    return obj_LoginJson_opencloseTime;
    
}

- (LoginJson_marketlist_Obj*) getLoginJson_marketlist_ObjByDIC:(NSMutableDictionary *) dic
{
    //初始化对象
    LoginJson_marketlist_Obj *obj_LoginJson_marketlist = [[LoginJson_marketlist_Obj alloc]init];
    
    obj_LoginJson_marketlist.marketID = [[dic objectForKey:@"marketID"] integerValue];
    
    obj_LoginJson_marketlist.name = [dic objectForKey:@"name"];
    
    obj_LoginJson_marketlist.type = [[dic objectForKey:@"type"] intValue];
    
    obj_LoginJson_marketlist.merplist = [dic objectForKey:@"merplist"];
    
    obj_LoginJson_marketlist.index = [[dic objectForKey:@"index"] intValue];
    
    obj_LoginJson_marketlist.unit = [[dic objectForKey:@"unit"] intValue];
    
    return obj_LoginJson_marketlist;
}


- (LoginJson_MerpList_Obj*) getLoginJson_MerpList_ObjByDIC:(NSMutableDictionary *) dic
{
    //初始化对象
    LoginJson_MerpList_Obj *obj_LoginJson_MerpList = [[LoginJson_MerpList_Obj alloc]init];
    
    obj_LoginJson_MerpList.index = [[dic objectForKey:@"index"] integerValue];
    
    obj_LoginJson_MerpList.OCTlist = [dic objectForKey:@"OCTlist"];
    
    obj_LoginJson_MerpList.diff = [[dic objectForKey:@"diff"] doubleValue];
    
    obj_LoginJson_MerpList.mpcode = [dic objectForKey:@"mpcode"];
    
    obj_LoginJson_MerpList.mpname = [dic objectForKey:@"mpname"];
    
    obj_LoginJson_MerpList.precision = [[dic objectForKey:@"precision"] integerValue];
    
    obj_LoginJson_MerpList.unit = [[dic objectForKey:@"unit"] intValue];
    
    obj_LoginJson_MerpList.opt = [[dic objectForKey:@"opt"] intValue];
    
    obj_LoginJson_MerpList.dStep = [[dic objectForKey:@"step"] doubleValue];

    obj_LoginJson_MerpList.dd = [dic objectForKey:@"dd"];
    
    return obj_LoginJson_MerpList;
    
}

- (LoginJson_tags_obj*) getLoginJson_tags_objByDIC:(NSMutableDictionary *) dic
{
    //初始化对象
    LoginJson_tags_obj *obj_LoginJson_tags = [[LoginJson_tags_obj alloc]init];
    
    obj_LoginJson_tags.id = [[dic objectForKey:@"id"] integerValue];
    
    obj_LoginJson_tags.name = [dic objectForKey:@"name"];
    
    obj_LoginJson_tags.order = [[dic objectForKey:@"order"] doubleValue];
    
    return obj_LoginJson_tags;
}

- (Para_MCLObj*) getPara_MCLObj_objByDIC:(NSMutableDictionary *) dic
{
    //初始化对象
    Para_MCLObj *obj_Para_MCLObj = [[Para_MCLObj alloc]init];
    
    obj_Para_MCLObj.ID = [[dic objectForKey:@"id"] integerValue];
    
    obj_Para_MCLObj.expiretime = [dic objectForKey:@"name"];
    
    return obj_Para_MCLObj;
    
}

- (Para_MarketListObj*) getPara_Para_MarketListObj_objByDIC:(NSMutableDictionary *) dic
{
    //初始化对象
    Para_MarketListObj *obj_Para_MarketListObj = [[Para_MarketListObj alloc]init];
    
    obj_Para_MarketListObj.marketID = [[dic objectForKey:@"marketID"] integerValue];
    
    obj_Para_MarketListObj.expiretime = [dic objectForKey:@"expiretime"];
    
    return obj_Para_MarketListObj;
    
}


- (FYAddorderhe_Obj*) getFYAddorderhe_Obj:(NSDictionary *) dicPara
{
    
    //mmcode 商品编码，Isbuy  1:买0:卖， number 成交数量， price成交价，adverse  0:建仓 1:平仓， dealtime 成交时间，user 用户id，
    
    FYAddorderhe_Obj *obj_FYAddorderhe = [[FYAddorderhe_Obj alloc]init];
    
    obj_FYAddorderhe.nUserId = [[dicPara objectForKey:@"user"] integerValue];
    
    NSString *strMmcode = [dicPara objectForKey:@"mmcode"];
    
    obj_FYAddorderhe.strMmcode = [[NetWorkManager sharedInstance]formatMpcode:strMmcode];
    
    obj_FYAddorderhe.nIsbuy = [[dicPara objectForKey:@"isbuy"] integerValue];
    
    obj_FYAddorderhe.fNumber = [[dicPara objectForKey:@"number"] floatValue];
    
    obj_FYAddorderhe.fPrice = [[dicPara objectForKey:@"price"] floatValue];
    
    obj_FYAddorderhe.nAdverse = [[dicPara objectForKey:@"adverse"] integerValue];
    
    obj_FYAddorderhe.strDealtime = [dicPara objectForKey:@"time"];
    
    return obj_FYAddorderhe;
}

- (FYAdd_del_order_Obj *) getFYAdd_del_order_Obj:(NSDictionary *) dicPara
{
    FYAdd_del_order_Obj *obj_FYAdd_del_order = [[FYAdd_del_order_Obj alloc]init];
    
    obj_FYAdd_del_order.nId = [[dicPara objectForKey:@"id"] integerValue];
    
    obj_FYAdd_del_order.nMatchid = [[dicPara objectForKey:@"matchid"] integerValue];
    
    obj_FYAdd_del_order.strIp = [dicPara objectForKey:@"ip"];
    
    obj_FYAdd_del_order.nUserId = [[dicPara objectForKey:@"user"] integerValue];
    
    obj_FYAdd_del_order.strMmcode = [dicPara objectForKey:@"mmcode"];
    
    obj_FYAdd_del_order.strTime = [dicPara objectForKey:@"time"];
    
    obj_FYAdd_del_order.nIsbuy = [[dicPara objectForKey:@"isbuy"] integerValue];
    
    obj_FYAdd_del_order.fNumber = [[dicPara objectForKey:@"number"] floatValue];
    
    obj_FYAdd_del_order.fOddnumber = [[dicPara objectForKey:@"oddnumber"] floatValue];
    
    obj_FYAdd_del_order.nAdverse = [[dicPara objectForKey:@"adverse"] integerValue];
    
    obj_FYAdd_del_order.fPrice = [[dicPara objectForKey:@"price"] floatValue];
    
    obj_FYAdd_del_order.strClidoid = [dicPara objectForKey:@"clidoid"];
    
    obj_FYAdd_del_order.nModetype = [[dicPara objectForKey:@"modetype"] integerValue];
    
    obj_FYAdd_del_order.nMakertype = [[dicPara objectForKey:@"makertype"] integerValue];
    
    obj_FYAdd_del_order.nUdtype = [[dicPara objectForKey:@"udtype"] integerValue];
    
    obj_FYAdd_del_order.fLoss = [[dicPara objectForKey:@"loss"] floatValue];
    
    obj_FYAdd_del_order.fProfit = [[dicPara objectForKey:@"profit"] floatValue];
    
    obj_FYAdd_del_order.fBtprice = [[dicPara objectForKey:@"btprice"] floatValue];
    
    return obj_FYAdd_del_order;
}

- (FYHistorySubData_Obj *) getHistoricalData_subObj:(NSArray *) arrayPara
{
    FYHistorySubData_Obj *obj_FYHistoricalData_subObj = [[FYHistorySubData_Obj alloc]init];
    
    obj_FYHistoricalData_subObj.nOheid = [[arrayPara objectAtIndex:0] integerValue];
    
    obj_FYHistoricalData_subObj.nOheoid= [[arrayPara objectAtIndex:1] integerValue];
    
    NSString *strMpcode = [arrayPara objectAtIndex:2];
    
    obj_FYHistoricalData_subObj.strOhemcode = [[NetWorkManager sharedInstance]formatMpcode:strMpcode];
    
    obj_FYHistoricalData_subObj.strOhedealtime = [arrayPara objectAtIndex:3];
    
    obj_FYHistoricalData_subObj.nOhetype = [[arrayPara objectAtIndex:4] integerValue];
    
    obj_FYHistoricalData_subObj.fOhenumber = [[arrayPara objectAtIndex:5] floatValue];
    
    obj_FYHistoricalData_subObj.fOheprice = [[arrayPara objectAtIndex:6] floatValue];
    
    obj_FYHistoricalData_subObj.fOheoddnum = [[arrayPara objectAtIndex:7] floatValue];
    
    obj_FYHistoricalData_subObj.fOhedealcost = [[arrayPara objectAtIndex:8] floatValue];
    
    obj_FYHistoricalData_subObj.nOheadverse = [[arrayPara objectAtIndex:9] integerValue];
    
    obj_FYHistoricalData_subObj.fOheProfit = [[arrayPara objectAtIndex:10] floatValue];
    
    obj_FYHistoricalData_subObj.fOheNBalance = [[arrayPara objectAtIndex:11] floatValue];
    
    obj_FYHistoricalData_subObj.nModeType = [[arrayPara objectAtIndex:12] integerValue];
    
    obj_FYHistoricalData_subObj.nMakerType = [[arrayPara objectAtIndex:13] integerValue];
    
    obj_FYHistoricalData_subObj.nUDTypet = [[arrayPara objectAtIndex:14] integerValue];
    
    obj_FYHistoricalData_subObj.fOheLossP = [[arrayPara objectAtIndex:15] floatValue];
    
    obj_FYHistoricalData_subObj.fOheProfitP = [[arrayPara objectAtIndex:16] floatValue];
    
    
    return obj_FYHistoricalData_subObj;
    
}

- (FYPositionsSubData_Obj *) getFYPositionsSubData_Obj:(NSArray *) arrayPara
{
    FYPositionsSubData_Obj *obj_FYPositionsSubData = [[FYPositionsSubData_Obj alloc]init];
    
    obj_FYPositionsSubData.nPositionsid = [[arrayPara objectAtIndex:0] integerValue];
    
    obj_FYPositionsSubData.nPositionsUserid = [[arrayPara objectAtIndex:1] integerValue];
    
    NSString *strMpcode = [arrayPara objectAtIndex:2];
    
    obj_FYPositionsSubData.strPositionsmcode = [[NetWorkManager sharedInstance] formatMpcode:strMpcode];
    
    obj_FYPositionsSubData.nPositionsType = [[arrayPara objectAtIndex:3] integerValue];
    
    obj_FYPositionsSubData.fPositionsPrice = [[arrayPara objectAtIndex:4] floatValue];
    
    obj_FYPositionsSubData.fPositionsNumber = [[arrayPara objectAtIndex:5] floatValue];
    
    obj_FYPositionsSubData.fPositionsLossP = [[arrayPara objectAtIndex:6] floatValue];
    
    obj_FYPositionsSubData.fPositionsProfitP = [[arrayPara objectAtIndex:7] floatValue];
    
    obj_FYPositionsSubData.strPositionstime = [arrayPara objectAtIndex:8];
    
    obj_FYPositionsSubData.nPositionsTransactionType = [[arrayPara objectAtIndex:9] integerValue];
    
    obj_FYPositionsSubData.fPositionsProfit = [[arrayPara objectAtIndex:10] floatValue];
    
    obj_FYPositionsSubData.strPositionsUserName = [arrayPara objectAtIndex:11];
    
    obj_FYPositionsSubData.fTestzqtest = [[arrayPara objectAtIndex:12] floatValue];
    
    return obj_FYPositionsSubData;
}

- (FYMySubscription_Obj *) getFYMySubscription_Obj:(NSDictionary *) dicFYMySubscription
{
    
    FYMySubscription_Obj *obj_FYMySubscription = [[FYMySubscription_Obj alloc]init];
    
    obj_FYMySubscription.nUid = [[dicFYMySubscription objectForKey:@"uid"] integerValue];
    
    obj_FYMySubscription.nbeSubscriberInvesttype = [[dicFYMySubscription objectForKey:@"investtype"] integerValue];
    
    obj_FYMySubscription.nMuid = [[dicFYMySubscription objectForKey:@"muid"] integerValue];
    
    obj_FYMySubscription.strUserName = [dicFYMySubscription objectForKey:@"UserName"];
    
    obj_FYMySubscription.strAccountName = [dicFYMySubscription objectForKey:@"account"];
    
    
    NSString *strendDate = [dicFYMySubscription objectForKey:@"endDate"];
    
    if (strendDate.length>=10) {
        
        NSString *strendDateFir = [strendDate substringToIndex:10];
        
        NSString *strendDateSecond = [strendDate substringFromIndex:10];
        
        strendDate = [NSString stringWithFormat:@"%@ %@",strendDateFir,strendDateSecond];
        
        obj_FYMySubscription.strEndDate = strendDate;
    }
    else
    {
        obj_FYMySubscription.strEndDate = strendDate;
    }
    
    
    
    obj_FYMySubscription.strImageURL = [dicFYMySubscription objectForKey:@"ImageURL"];
    
    NSString *strmodifytime = [dicFYMySubscription objectForKey:@"modifytime"];
    
    if (strmodifytime.length>=10) {
        
        NSString *strFir = [strmodifytime substringToIndex:10];
        
        NSString *strSecond = [strmodifytime substringFromIndex:10];
        
        strmodifytime = [NSString stringWithFormat:@"%@ %@",strFir,strSecond];
        
        obj_FYMySubscription.strModifyTime = strmodifytime;
    }
    else
    {
        obj_FYMySubscription.strModifyTime = strmodifytime;
    }
    
    
    return obj_FYMySubscription;
}


- (FYGetUserMoney_Obj*) getFYGetUserMoney_Obj:(FYGetUserMoney_Obj*)obj_FYGetUserMoney AndDic:(NSDictionary *) dicPara
{
    
    obj_FYGetUserMoney.nPoint = [[dicPara objectForKey:@"piont"] intValue];
    
    obj_FYGetUserMoney.fAmount_money = [[dicPara objectForKey:@"amount_money"] floatValue];
    
    obj_FYGetUserMoney.fAmount_cjb = [[dicPara objectForKey:@"amount_cjb"] floatValue];
    
    obj_FYGetUserMoney.fFree_money = [[dicPara objectForKey:@"free_money"] floatValue];
    
    obj_FYGetUserMoney.fFree_cjb = [[dicPara objectForKey:@"free_cjb"] floatValue];
    
    obj_FYGetUserMoney.fToday_money = [[dicPara objectForKey:@"today_money"] floatValue];
    
    obj_FYGetUserMoney.fToday_cjb = [[dicPara objectForKey:@"today_cjb"]floatValue];
    
    obj_FYGetUserMoney.nlevelmaxpoint = [[dicPara objectForKey:@"levelmaxpoint"] intValue];
    
    obj_FYGetUserMoney.strlevelname = [dicPara objectForKey:@"levelname"];
    
    obj_FYGetUserMoney.tgcode = [dicPara objectForKey:@"tgcode"];
    
    obj_FYGetUserMoney.alltimes = [[dicPara objectForKey:@"alltimes"] floatValue];
    
    obj_FYGetUserMoney.myracecount = [[dicPara objectForKey:@"myracecount"] floatValue];
    
    
    return obj_FYGetUserMoney;
}

- (FYGetMUserInfo_Obj*) getFYGetMUserInfo_Obj:(FYGetMUserInfo_Obj*)obj_FYGetMUserInfo AndDic:(NSDictionary *) dicPara;
{
    obj_FYGetMUserInfo.nAlltimes = [[dicPara objectForKey:@"alltimes"] intValue];
    
    obj_FYGetMUserInfo.strHeaderimg = [dicPara objectForKey:@"headerimg"];
    
    obj_FYGetMUserInfo.strMuname = [dicPara objectForKey:@"muname"];
    
    obj_FYGetMUserInfo.nSubmoney = [[dicPara objectForKey:@"submoney"] integerValue];
    
    obj_FYGetMUserInfo.bSubscribe = [[dicPara objectForKey:@"subscribe"] boolValue];
    
    return obj_FYGetMUserInfo;
}


- (FYHomepageQuery_uid_Obj*) getFYHomepageQuery_uid_Obj:(NSMutableDictionary *) dic
{
    FYHomepageQuery_uid_Obj *obj_FYHomepageQuery_uid = [[FYHomepageQuery_uid_Obj alloc]init];
    
    obj_FYHomepageQuery_uid.nmuid = [[dic objectForKey:@"muid"] integerValue];
    
    obj_FYHomepageQuery_uid.straccount = [dic objectForKey:@"account"];
    
    obj_FYHomepageQuery_uid.strinvesttype = [dic objectForKey:@"investtype"];
    
    return obj_FYHomepageQuery_uid;
}

- (Subscription_Search_Obj *) getSubscription_Search_Obj:(NSMutableDictionary *) dic
{
    Subscription_Search_Obj * obj_Subscription_Search = [[Subscription_Search_Obj alloc]init];
    
    obj_Subscription_Search.nUid = [[dic objectForKey:@"uid"] integerValue];
    
    obj_Subscription_Search.nMuid = [[dic objectForKey:@"muid"] integerValue];
    
    obj_Subscription_Search.strUserName = [dic objectForKey:@"UserName"];
    
    obj_Subscription_Search.strAccountName = [dic objectForKey:@"account"];
    
    obj_Subscription_Search.nbeSubscriberInvesttype = [[dic objectForKey:@"investtype"] integerValue];
    
    obj_Subscription_Search.strHeaderUrl = [dic objectForKey:@"ImageURL"];
    
    return obj_Subscription_Search;
}


@end
