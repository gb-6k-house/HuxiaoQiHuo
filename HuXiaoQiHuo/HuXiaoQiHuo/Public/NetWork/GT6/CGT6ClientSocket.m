//
//  CGT6ClientSocket.m
//  HuXiaoQiHuo
//
//  Created by niupark on 16/6/2.
//  Copyright © 2016年 fukeng. All rights reserved.
//

#import "CGT6ClientSocket.h"

#import <CoreFoundation/CFStringEncodingExt.h>
#import "GT6LoginRequest.h"
#import "TradeMainResponse.h"
#import "GT6LoginResponse.h"
#import "LoadUserInfoRequest.h"
#import "LoadUserInfoResponse.h"
#import "PushAllMsgResponse.h"

#import "AddOrderRequest_Market.h"
#import "AddOrderRequest_Match.h"

#import "AddOrderResponse.h"
#import "DeleteOrderResponse.h"
#import "OutoffUserRequest.h"
#import "DeleteOrderRequest.h"
#import "UpdateUserResponse.h"

#import "MerpDeliverRequest2.h"
#import "MerpDeliverRequest.h"
#import "MerpDeliverResponse.h"
#import "ChangeLoweHighPriceResponse.h"
#import "ChangeLowePriceRequest.h"
#import "ModifyLossAndProfitRequest.h"

#import "Constants.h"
#import "CTradeClientSocket.h"
#import "NetWorkManager.h"
#import "MerpDTO.h"
#import "CSocketListenerManager.h"
#import "NetProtocol.h"
@implementation CGT6ClientSocket
-(void) login
{
    GT6LoginRequest *loginRequest = [[GT6LoginRequest alloc] initWithUsername:currentusername AndPassword:currentpassword];
    [self sendData:[loginRequest getJSONString]];
    //NSLog(@"LoginRequest = %@", loginRequest);
}

-(void) loginWithUsername:(NSString *)username AndPassword:(NSString *)password{
    
    currentusername = username;
    if (!password || [password isEqualToString:@""]) {
        currentpassword = @"123456";

    }else{
        currentpassword = password;
 
    }
    [self login];
}

-(void)deleteOrder:(NSString*)orderid;{    
    DeleteOrderRequest * deleteorderrequest = [[ DeleteOrderRequest alloc] initWithUserID:[NSString stringWithFormat:@"%d",userID] AndOrderID:orderid];
    [self sendData:[deleteorderrequest getJSONString]];
}

-(void) sendLoadUserInfo
{
    LoadUserInfoRequest *loadUserInfoRequest = [[LoadUserInfoRequest alloc] initWithUserID:userID];
    [self sendData:[loadUserInfoRequest getJSONString]];
}

-(void)sendAddOrderMarket:(NSDictionary *)sendData{
    
    AddOrderRequest_Market *addorderrequest = [[AddOrderRequest_Market alloc] initWithUserID:sendData[@"UID"] mpcode:sendData[@"PRODCODE"] isBuy:[sendData[@"BUYSELL"] boolValue] number:sendData[@"QTY"] price:sendData[@"PRICE"] type:[sendData[@"ORDERTYPE"] integerValue] stopPrice:sendData[@"STOPLEVEL"] stopType:sendData[@"STOPTYPE"] pid:sendData[@"PID"]];
    
    
    [self sendData:[addorderrequest getJSONString]];
}



-(void) sendDelivery:(NSNotification *)notify
{
    NSString *mmcode = [notify.userInfo valueForKey:@"mmcode"];
    NSString *isbuy = [notify.userInfo valueForKey:@"IsBuy"];
    NSString *number = [notify.userInfo valueForKey:@"number"];
    MerpDeliverRequest * deliveryrequest = [[MerpDeliverRequest alloc] initWithUserID:[NSString stringWithFormat:@"%d",userID] mmcode:mmcode Isbuy:isbuy AndNumber:number];
    [self sendData:[deliveryrequest getJSONString]];
}

-(void) sendDelivery2:(NSNotification *)notify
{
    
    NSString *mmcode = [notify.userInfo valueForKey:@"mmcode"];
    NSString *isbuy = [notify.userInfo valueForKey:@"IsBuy"];
    NSString *number = [notify.userInfo valueForKey:@"number"];
    NSString *posid = [notify.userInfo valueForKey:@"posid"];
    MerpDeliverRequest2 * deliveryrequest2 = [[MerpDeliverRequest2 alloc] initWithUserID:[NSString stringWithFormat:@"%d",userID] mmcode:mmcode Isbuy:isbuy AndNumber:number posid:posid];
    [self sendData:[deliveryrequest2 getJSONString]];
}

-(void) SENDModifyProfitPrice:(NSNotification *)notify
{
    NSString *mmcode = [notify.userInfo valueForKey:@"mpcode"];
    NSString *isbuy = [notify.userInfo valueForKey:@"IsBuy"];
    NSString *profit = [notify.userInfo valueForKey:@"profit"];
    ChangeLowePriceRequest * changelowpricerequest = [[ChangeLowePriceRequest alloc] initWithLoss:profit mpcode:mmcode isBuy:isbuy];
    [self sendData:[changelowpricerequest getJSONString]];
}

-(void) sendModifyLossAndProfit:(NSNotification *)notify
{
    NSString *loss = [notify.userInfo valueForKey:@"loss"];
    NSString *profit = [notify.userInfo valueForKey:@"profit"];
    NSString *orderid = [notify.userInfo valueForKey:@"orderid"];
    ModifyLossAndProfitRequest * modifyLossAndProfitReq = [[ModifyLossAndProfitRequest alloc] initWithLoss:loss profit:profit orderid:orderid];
    [self sendData:[modifyLossAndProfitReq getJSONString]];
}


-(void) handelSocketJSON:(NSString *)tradeMsg{
    //NSLog(@"Test tradMsg string = %@", tradeMsg);
    TradeMainResponse * tradeResponse = [[TradeMainResponse alloc] initWithString:tradeMsg];
    
    if ([((TradeResponseData *)tradeResponse.responseData).Bc isEqualToString:@"login"]) {
        GT6LoginResponse * loginResponse = [[GT6LoginResponse alloc] initWithString:((TradeResponseData *)tradeResponse.responseData).para];
        
        if ([loginResponse isLoginSucess])
        {
            
            userID = loginResponse.userStatus.userID;
            [self sendLoadUserInfo];
            [[CSocketListenerManager sharedInstance] callBack:PROTOCOL_SEL(GT6Login) withObjcet:loginResponse];

        }else
        {
           
            [[CSocketListenerManager sharedInstance] callBack:PROTOCOL_SEL(GT6Login) withObjcet:loginResponse];
        }
    }
    else if ([((TradeResponseData *)tradeResponse.responseData).Bc isEqualToString:@"load_userinfo"])
    {
        LoadUserInfoResponse * loadUserInfoResponse = [[LoadUserInfoResponse alloc] initWithString:((TradeResponseData *)tradeResponse.responseData).para];
        //NSLog(@"%@", loadUserInfoResponse);
        [[CSocketListenerManager sharedInstance] callBack:PROTOCOL_SEL(GT6UserInfo) withObjcet:loadUserInfoResponse];

        
        
    }else if([((TradeResponseData *)tradeResponse.responseData).Bc isEqualToString:@"add_order_net_real"])
    {
        AddOrderResponse * addOrderResponse = [[AddOrderResponse alloc] initWithString:((TradeResponseData *)tradeResponse.responseData).para];
        
        AddOrderResponseData * addorderresponsedata = ((AddOrderResponseData *)addOrderResponse.responseData);
        NSLog(@"%@", addorderresponsedata);
        if ([addOrderResponse ifSucess]) {
            [self sendLoadUserInfo];
        }
        
        [[CSocketListenerManager sharedInstance] callBack:PROTOCOL_SEL(GT6AddOrder) withObjcet:addOrderResponse];
        
        
    }else if([((TradeResponseData *)tradeResponse.responseData).Bc isEqualToString:@"del_order"])
    {        
        DeleteOrderResponse * deleteOrderResponse = [[DeleteOrderResponse alloc] initWithString:((TradeResponseData *)tradeResponse.responseData).para];
        
        NSString *title;
        NSString *message;
        
        DeleteOrderResponseData * deleteorderresponsedata = ((DeleteOrderResponseData *)deleteOrderResponse.responseData);
        if (0 != deleteorderresponsedata.user && userID != deleteorderresponsedata.user) {
            return;
        }
        
        switch (deleteorderresponsedata.result) {
            case 1:
                if (deleteorderresponsedata.orderid != 0) {
                    title = @"撤单";
                    message = @"撤单成功";
                }else{
                    title = @"撤单";
                    message = @"订单编号不正确";
                }
                break;
            case 12:
                title = @"撤单";
                message = @"未找到对应用户";
                break;
            case 13:
                title = @"撤单";
                message = @"用户订单已经成交或者已经撤销";
                break;
            case 15:
                title = @"撤单";
                message = @"订单正在交易中";
                break;
                
            default:
                title = @"撤单";
                message = @"未知错误";
                break;
        }
        [nc postNotificationName:@"WARNING" object:[self class] userInfo:[[NSMutableDictionary alloc] initWithObjectsAndKeys: title, @"TITLE",message,@"MESSAGE", nil ]];
        [self sendLoadUserInfo];
    }else
    {
    }
    //NSLog(@"%@++++%@",((TradeResponseData *)tradeResponse.responseData).Bc, tradeMsg);
}





@end
