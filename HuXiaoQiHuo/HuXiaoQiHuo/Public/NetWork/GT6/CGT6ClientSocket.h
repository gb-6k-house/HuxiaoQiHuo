//
//  CGT6ClientSocket.h
//  HuXiaoQiHuo
//
//  Created by niupark on 16/6/2.
//  Copyright © 2016年 fukeng. All rights reserved.
//

#import "CClientSocket.h"

@interface CGT6ClientSocket : CClientSocket{
    NSString *currentusername;
    NSString *currentpassword;
    int userID;
    NSNotificationCenter *nc;

}
/**
 *  @author LiuK, 16-06-02 09:06:34
 *
 *  登录交易模块
 *
 *  @param username <#username description#>
 *  @param password <#password description#>
 */
-(void)loginWithUsername:(NSString *)username AndPassword:(NSString *)password;
/**
 *  @author LiuK, 16-06-02 09:06:19
 *
 *  删除订单
 *
 *  @param orderid <#orderid description#>
 */
-(void)deleteOrder:(NSString*)orderid;
/**
 *  @author LiuK, 16-06-03 10:06:33
 *
 *  下单
 *
 *  @param sendData <#sendData description#>
 */
-(void)sendAddOrderMarket:(NSDictionary *)sendData;

@end
