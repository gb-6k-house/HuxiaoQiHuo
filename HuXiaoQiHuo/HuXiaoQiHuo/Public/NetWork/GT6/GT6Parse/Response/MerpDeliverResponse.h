//
//  MerpDeliverResponse.h
//  XMClient
//
//  Created by wenbo.fan on 12-11-7.
//  Copyright (c) 2012年 wenbo.fan. All rights reserved.
//

#import "GT6Response.h"
@interface MerpDeliverResponseData : GT6ResponseData
@property int result; // 返回结果
@property int user; // 用户Id
@property NSString *info; // 返回结果说明
@property NSString * clidoid; // 客户端唯一编码
@end

@interface MerpDeliverResponse : GT6Response

@end
