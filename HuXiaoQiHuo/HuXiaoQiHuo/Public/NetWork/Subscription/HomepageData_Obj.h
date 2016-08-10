//
//  HomepageData_Obj.h
//  traderex
//
//  Created by cssoft on 15/10/30.
//  Copyright © 2015年 EasyFly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomepageData_Obj : NSObject

@property int nAlltimes;//被订阅次数
@property (nonatomic,retain) NSString *strHeaderimg;//全路径头像地址
@property (nonatomic,retain) NSString *strMuname;//模拟(子账户)帐号名
@property NSInteger nSubmoney;//当前订阅费

@property BOOL bSubscribe;//是否与自己有订阅关系



@property  float fBalance;//余额

@property  float fProfit;//收益

@property  float fYield;//收益率

@property  float fWinRange;//胜率

@end
