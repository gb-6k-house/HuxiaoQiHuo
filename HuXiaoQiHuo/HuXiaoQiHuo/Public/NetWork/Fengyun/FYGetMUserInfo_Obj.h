//
//  FYGetMUserInfo_Obj.h
//  traderex
//
//  Created by cssoft on 15/10/27.
//  Copyright © 2015年 EasyFly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FYGetMUserInfo_Obj : NSObject

@property (nonatomic,retain) NSString *strCode;//成功  其它失败
@property (nonatomic,retain) NSString *strMsg;//输出信息
@property (nonatomic,retain) NSString *strsucceed;//是否调用到接口 "true"或"false"
@property int nAlltimes;//被订阅次数
@property (nonatomic,retain) NSString *strHeaderimg;//全路径头像地址
@property (nonatomic,retain) NSString *strMuname;//模拟(子账户)帐号名
@property NSInteger nSubmoney;
@property BOOL bSubscribe;//是否与自己有订阅关系

@end
