//
//  FYSetSubscribeFee_Obj.h
//  traderex
//
//  Created by cssoft on 15/10/27.
//  Copyright © 2015年 EasyFly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FYSetSubscribeFee_Obj : NSObject
@property (nonatomic,retain) NSString *strCode;//成功  其它失败
@property (nonatomic,retain) NSString *strMsg;//输出信息
@property (nonatomic,retain) NSString *strsucceed;//是否调用到接口 "true"或"false"
@end
