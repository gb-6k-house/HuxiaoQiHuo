//
//  GlobalValue.h
//  HuXiaoQiHuo
//
//  Created by niupark on 16/5/21.
//  Copyright © 2016年 fukeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginParaObj.h"
@interface GlobalValue : NSObject
+ (instancetype)sharedInstance;
@property(nonatomic, assign)BOOL isLogin; //是否登录
@property(nonatomic, copy)NSString* uname; //账号
@property NSInteger uid;
@property NSInteger sid;
@property(nonatomic, copy)NSString* pwd; //密码
@property(nonatomic, assign)NSInteger tradeUID; //交易账户
@property(nonatomic, copy)NSString* tradeAccount; //交易账户
@property(nonatomic, copy)NSString* tradePwd; //交易密码

-(BOOL)ifZXWithMpId:(NSString*)mpId;
-(void)addZxWithMpId:(NSString*)mpId;
-(void)removeZxWithMpId:(NSString*)mpId;
- (NSMutableArray*) loadZXFile;
@end
