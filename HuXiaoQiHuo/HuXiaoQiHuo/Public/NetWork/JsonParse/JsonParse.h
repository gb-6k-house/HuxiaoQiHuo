//
//  JsonParse.h
//  Trader
//
//  Created by cssoft on 15/4/29.
//  Copyright (c) 2015年 easyfly. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LoginJson_MCL_Obj.h"
#import "LoginJson_OCTDic_obj.h"
#import "LoginJson_opencloseTime_obj.h"
#import "LoginJson_marketlist_Obj.h"
#import "LoginJson_MerpList_Obj.h"
#import "LoginJson_tags_obj.h"
#import "Login_Tags_Obj.h"
#import "Para_MCLObj.h"
#import "Para_MarketListObj.h"
#import "LoginParaObj.h"

#import "FYAddorderhe_Obj.h"
#import "FYAdd_del_order_Obj.h"
#import "FYHistorySubData_Obj.h"


#import "FYMySubscription_Obj.h"
#import "FYPositionsSubData_Obj.h"

#import "FYGetUserMoney_Obj.h"
#import "FYGetMUserInfo_Obj.h"

#import "FYHomepageQuery_uid_Obj.h"

#import "Subscription_Search_Obj.h"

@interface JsonParse : NSObject

- (LoginJson_MCL_Obj*) getLoginJson_MCL_ObjByDIC:(NSMutableDictionary *) dic;

- (LoginJson_OCTDic_obj*) getLoginJson_OCTDic_objByDIC:(NSMutableDictionary *) dic;

- (LoginJson_opencloseTime_obj*) getLoginJson_opencloseTime_objByDIC:(NSMutableDictionary *) dic;

- (LoginJson_marketlist_Obj*) getLoginJson_marketlist_ObjByDIC:(NSMutableDictionary *) dic;

- (LoginJson_MerpList_Obj*) getLoginJson_MerpList_ObjByDIC:(NSMutableDictionary *) dic;

- (LoginJson_tags_obj*) getLoginJson_tags_objByDIC:(NSMutableDictionary *) dic;

- (Login_Tags_Obj*) getLoginJson_Tags_ObjByDIC:(NSMutableDictionary *) dic;

- (Para_MCLObj*) getPara_MCLObj_objByDIC:(NSMutableDictionary *) dic;

- (Para_MarketListObj*) getPara_Para_MarketListObj_objByDIC:(NSMutableDictionary *) dic;

- (LoginParaObj *) getLoginResponse_LoginParaObjByDIC:(NSDictionary *) dic;

- (FYAddorderhe_Obj*) getFYAddorderhe_Obj:(NSDictionary *) dicPara;

- (FYAdd_del_order_Obj *) getFYAdd_del_order_Obj:(NSDictionary *) dicPara;

- (FYHistorySubData_Obj *) getHistoricalData_subObj:(NSArray *) arrayPara;

- (FYPositionsSubData_Obj *) getFYPositionsSubData_Obj:(NSArray *) arrayPara;

- (FYMySubscription_Obj *) getFYMySubscription_Obj:(NSDictionary *) dicFYMySubscription;

- (FYGetUserMoney_Obj*) getFYGetUserMoney_Obj:(FYGetUserMoney_Obj*)obj_FYGetUserMoney AndDic:(NSDictionary *) dicPara;
- (FYGetMUserInfo_Obj*) getFYGetMUserInfo_Obj:(FYGetMUserInfo_Obj*)obj_FYGetMUserInfo AndDic:(NSDictionary *) dicPara;


- (FYHomepageQuery_uid_Obj*) getFYHomepageQuery_uid_Obj:(NSMutableDictionary *) dic;

- (Subscription_Search_Obj *) getSubscription_Search_Obj:(NSMutableDictionary *) dic;


@end
