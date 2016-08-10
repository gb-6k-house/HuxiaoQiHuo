//
//  AddOrderResponse.h
//  Test
//
//  Created by wenbo.fan on 12-10-12.
//  Copyright (c) 2012年 wenbo.fan. All rights reserved.
//

#import "GT6Response.h"
@interface AddOrderResponseData : GT6ResponseData
@property int UID;
@property  NSString * RST;
@property  NSString * TP; //错误信息
@end

@interface AddOrderResponse : GT6Response
-(BOOL)ifSucess;
@end
