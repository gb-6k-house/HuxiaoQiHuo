//
//  Response.h
//  HuXiaoQiHuo
//
//  Created by niupark on 16/5/19.
//  Copyright © 2016年 fukeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Response : NSObject
@property int cmd;
@property int rst;
@property(nonatomic,copy)NSString * reason;
@property int SID;
@property int UID;
@property(nonatomic, strong) id para;

@end
